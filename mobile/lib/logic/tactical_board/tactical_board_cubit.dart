import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/player_model.dart';
import '../../data/repositories/tactical_repository.dart';
import 'tactical_board_state.dart';

class TacticalBoardCubit extends Cubit<TacticalBoardState> {
  final TacticalRepository repository;

  TacticalBoardCubit({required this.repository})
      : super(TacticalBoardState(
          formation: '4-2-3-1',
          startingSlots: const {},
          benchPlayers: const [],
          ppdaIntensity: 5.5,
          defensiveLineHeight: 8.0,
          buildUpTempo: 7.0,
        ));

  void loadInitialSquad() async {
    final allPlayers = await repository.getSquadPlayers();

    final Set<int> assignedIds = {};

    PlayerModel findStarter({
      required List<String> preferredNames,
      required String position,
      required int fallbackIndex,
    }) {
      // 1. Cari berdasarkan nama prioritas yang belum terpasang
      for (final name in preferredNames) {
        final matches = allPlayers
            .where((p) => !assignedIds.contains(p.id) && p.name.toLowerCase().contains(name.toLowerCase()))
            .toList();
        if (matches.isNotEmpty) {
          assignedIds.add(matches.first.id);
          return matches.first;
        }
      }

      // 2. Cari berdasarkan posisi yang cocok dan belum terpasang
      final posMatches = allPlayers
          .where((p) => !assignedIds.contains(p.id) && p.position == position)
          .toList();
      if (posMatches.isNotEmpty) {
        assignedIds.add(posMatches.first.id);
        return posMatches.first;
      }

      // 3. Ambil pemain manapun yang belum terpasang
      final anyUnassigned = allPlayers
          .where((p) => !assignedIds.contains(p.id))
          .toList();
      if (anyUnassigned.isNotEmpty) {
        assignedIds.add(anyUnassigned.first.id);
        return anyUnassigned.first;
      }

      // 4. Fallback aman
      final fallback = allPlayers[fallbackIndex % allPlayers.length];
      assignedIds.add(fallback.id);
      return fallback;
    }

    // Inisialisasi starting XI resmi disinkronkan dengan AllSportsAPI Team 97
    final Map<String, PlayerModel?> defaultXi = {
      'GK': findStarter(
        preferredNames: ['Joan Garcia', 'Szczesny', 'Livakovic'],
        position: 'GK',
        fallbackIndex: 0,
      ),
      'LB': findStarter(
        preferredNames: ['Balde', 'Gerard Martin'],
        position: 'LB',
        fallbackIndex: 1,
      ),
      'LCB': findStarter(
        preferredNames: ['Christensen', 'Cubarsi', 'Eric Garcia'],
        position: 'CB',
        fallbackIndex: 2,
      ),
      'RCB': findStarter(
        preferredNames: ['Cubarsi', 'Christensen', 'Alex Campos'],
        position: 'CB',
        fallbackIndex: 3,
      ),
      'RB': findStarter(
        preferredNames: ['Kounde', 'Cancelo'],
        position: 'RB',
        fallbackIndex: 4,
      ),
      'LDM': findStarter(
        preferredNames: ['Rodri', 'Bernal'],
        position: 'DM',
        fallbackIndex: 5,
      ),
      'RDM': findStarter(
        preferredNames: ['Pedri', 'Frenkie', 'Gavi'],
        position: 'CM',
        fallbackIndex: 6,
      ),
      'LW': findStarter(
        preferredNames: ['Raphinha', 'Gordon', 'Adeyemi'],
        position: 'LW',
        fallbackIndex: 7,
      ),
      'AM': findStarter(
        preferredNames: ['Dani Olmo', 'Olmo', 'Fermin'],
        position: 'AM',
        fallbackIndex: 8,
      ),
      'RW': findStarter(
        preferredNames: ['Yamal', 'Lamine', 'Bardghji'],
        position: 'RW',
        fallbackIndex: 9,
      ),
      'CF': findStarter(
        preferredNames: ['Jesus', 'Gabriel', 'Adeyemi', 'Bardghji'],
        position: 'CF',
        fallbackIndex: 10,
      ),
    };

    final bench = allPlayers.where((p) => !assignedIds.contains(p.id)).toList();

    emit(state.copyWith(
      startingSlots: defaultXi,
      benchPlayers: bench,
    ));
  }

  void assignPlayerToSlot(String slotKey, PlayerModel player) {
    final currentSlots = Map<String, PlayerModel?>.from(state.startingSlots);
    final currentBench = List<PlayerModel>.from(state.benchPlayers);

    final previousPlayerInSlot = currentSlots[slotKey];

    // Cek apakah pemain baru ini sebenarnya sudah ada di posisi lain di lapangan
    String? existingSlotKey;
    for (final entry in currentSlots.entries) {
      if (entry.key != slotKey && entry.value?.id == player.id) {
        existingSlotKey = entry.key;
        break;
      }
    }

    if (existingSlotKey != null) {
      // Pemain sudah di lapangan -> Langsung Tukar Posisi (SWAP)
      currentSlots[existingSlotKey] = previousPlayerInSlot;
      currentSlots[slotKey] = player;
    } else {
      // Pemain ditarik dari bangku cadangan
      if (previousPlayerInSlot != null) {
        currentBench.add(previousPlayerInSlot);
      }
      currentSlots[slotKey] = player;
      currentBench.removeWhere((p) => p.id == player.id);
    }

    emit(state.copyWith(
      startingSlots: currentSlots,
      benchPlayers: currentBench,
    ));
  }

  void switchFormation(String newFormation) {
    if (newFormation == state.formation) return;

    final currentSlots = Map<String, PlayerModel?>.from(state.startingSlots);
    final Map<String, PlayerModel?> newSlots = {};

    if (newFormation == '3-2-4-1') {
      // Konversi dari 4-2-3-1 ke 3-2-4-1
      newSlots['GK'] = currentSlots['GK'];
      newSlots['LCB'] = currentSlots['LCB'] ?? currentSlots['LB'];
      newSlots['CB'] = currentSlots['RCB'] ?? currentSlots['LCB'];
      newSlots['RCB'] = currentSlots['RB'] ?? currentSlots['RCB'];
      newSlots['LDM'] = currentSlots['LDM'];
      newSlots['RDM'] = currentSlots['RDM'];
      newSlots['LW'] = currentSlots['LW'];
      newSlots['LAM'] = currentSlots['AM'];
      newSlots['RAM'] = currentSlots['LB'] ?? currentSlots['RB'];
      newSlots['RW'] = currentSlots['RW'];
      newSlots['CF'] = currentSlots['CF'];
    } else {
      // Konversi dari 3-2-4-1 ke 4-2-3-1
      newSlots['GK'] = currentSlots['GK'];
      newSlots['LB'] = currentSlots['RAM'] ?? currentSlots['LCB'];
      newSlots['LCB'] = currentSlots['LCB'];
      newSlots['RCB'] = currentSlots['CB'] ?? currentSlots['RCB'];
      newSlots['RB'] = currentSlots['RCB'];
      newSlots['LDM'] = currentSlots['LDM'];
      newSlots['RDM'] = currentSlots['RDM'];
      newSlots['LW'] = currentSlots['LW'];
      newSlots['AM'] = currentSlots['LAM'] ?? currentSlots['RAM'];
      newSlots['RW'] = currentSlots['RW'];
      newSlots['CF'] = currentSlots['CF'];
    }

    emit(state.copyWith(
      formation: newFormation,
      startingSlots: newSlots,
    ));
  }

  void updatePpda(double value) {
    emit(state.copyWith(ppdaIntensity: value));
  }

  void updateDefensiveLine(double value) {
    emit(state.copyWith(defensiveLineHeight: value));
  }

  void updateTempo(double value) {
    emit(state.copyWith(buildUpTempo: value));
  }
}

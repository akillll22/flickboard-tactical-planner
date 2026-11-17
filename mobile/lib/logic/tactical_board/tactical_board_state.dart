import 'package:equatable/equatable.dart';
import '../../data/models/player_model.dart';

class TacticalBoardState extends Equatable {
  final String formation; // "4-2-3-1" or "3-2-4-1"
  final Map<String, PlayerModel?> startingSlots; // slotKey -> Player
  final List<PlayerModel> benchPlayers;
  final double ppdaIntensity; // 2.0 to 15.0
  final double defensiveLineHeight; // 1.0 to 10.0
  final double buildUpTempo; // 1.0 to 10.0

  const TacticalBoardState({
    required this.formation,
    required this.startingSlots,
    required this.benchPlayers,
    required this.ppdaIntensity,
    required this.defensiveLineHeight,
    required this.buildUpTempo,
  });

  bool get isStartingXiComplete =>
      startingSlots.values.where((p) => p != null).length == 11;

  List<int> get startingXiIds =>
      startingSlots.values.where((p) => p != null).map((p) => p!.id).toList();

  TacticalBoardState copyWith({
    String? formation,
    Map<String, PlayerModel?>? startingSlots,
    List<PlayerModel>? benchPlayers,
    double? ppdaIntensity,
    double? defensiveLineHeight,
    double? buildUpTempo,
  }) {
    return TacticalBoardState(
      formation: formation ?? this.formation,
      startingSlots: startingSlots ?? this.startingSlots,
      benchPlayers: benchPlayers ?? this.benchPlayers,
      ppdaIntensity: ppdaIntensity ?? this.ppdaIntensity,
      defensiveLineHeight: defensiveLineHeight ?? this.defensiveLineHeight,
      buildUpTempo: buildUpTempo ?? this.buildUpTempo,
    );
  }

  @override
  List<Object?> get props => [
        formation,
        startingSlots,
        benchPlayers,
        ppdaIntensity,
        defensiveLineHeight,
        buildUpTempo,
      ];
}

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/glassmorphism.dart';
import '../../data/models/match_model.dart';
import '../../data/models/player_model.dart';
import '../../logic/tactical_board/tactical_board_cubit.dart';
import '../../logic/tactical_board/tactical_board_state.dart';
import '../../logic/simulation/simulation_cubit.dart';
import '../../logic/simulation/simulation_state.dart';
import '../widgets/tactical_pitch_widget.dart';
import '../widgets/tactical_sliders_panel.dart';
import 'simulation_report_screen.dart';

class TacticalBoardScreen extends StatefulWidget {
  final MatchModel match;

  const TacticalBoardScreen({Key? key, required this.match}) : super(key: key);

  @override
  State<TacticalBoardScreen> createState() => _TacticalBoardScreenState();
}

class _TacticalBoardScreenState extends State<TacticalBoardScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TacticalBoardCubit>();
    if (cubit.state.startingSlots.isEmpty) {
      cubit.loadInitialSquad();
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    return BlocListener<SimulationCubit, SimulationState>(
      listener: (context, simState) {
        if (simState is SimulationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SimulationReportScreen(
                result: simState.result,
                match: match,
              ),
            ),
          );
        } else if (simState is SimulationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(simState.message),
              backgroundColor: BarcaColors.warningVermilion,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: BarcaColors.obsidianCanvas,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PAPAN TAKTIK FLICKBOARD', style: BarcaTypography.headlineMd),
              Text('vs ${match.opponent!.teamName}', style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.senyeraGold)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: BarcaColors.senyeraGold),
              tooltip: 'Reset ke Starting XI Sekarang',
              onPressed: () {
                context.read<TacticalBoardCubit>().loadInitialSquad();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Starting XI direset ke susunan utama Hansi Flick saat ini'),
                    backgroundColor: BarcaColors.royalBlue,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            BlocBuilder<TacticalBoardCubit, TacticalBoardState>(
              builder: (context, state) {
                return PopupMenuButton<String>(
                  color: BarcaColors.surfaceTier1,
                  initialValue: state.formation,
                  onSelected: (form) => context.read<TacticalBoardCubit>().switchFormation(form),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: '4-2-3-1', child: Text('4-2-3-1 (Nominal / Bertahan)', style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(value: '3-2-4-1', child: Text('3-2-4-1 (Fase In-Possession)', style: TextStyle(color: Colors.white))),
                  ],
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: BarcaColors.royalBlue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: BarcaColors.royalBlue),
                    ),
                    child: Row(
                      children: [
                        Text(state.formation, style: BarcaTypography.telemetrySm.copyWith(color: Colors.white)),
                        const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SimulationCubit, SimulationState>(
          builder: (context, simState) {
            if (simState is SimulationLoading) {
              return _buildHighTechLoader(simState);
            }

            return BlocBuilder<TacticalBoardCubit, TacticalBoardState>(
              builder: (context, boardState) {
                if (boardState.startingSlots.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: BarcaColors.senyeraGold),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Lapangan Taktis Interaktif (Tactical Pitch)
                          TacticalPitchWidget(
                            formation: boardState.formation,
                            slots: boardState.startingSlots,
                            onPlayerDropped: (slotKey, player) {
                              context.read<TacticalBoardCubit>().assignPlayerToSlot(slotKey, player);
                            },
                            onSlotTapped: (slotKey) {
                              _showSlotPlayerPicker(context, slotKey, boardState);
                            },
                          ),
                          const SizedBox(height: 16),

                          // 2. Daftar Pemain Cadangan (Bench Drag Tray)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('BANGKU CADANGAN', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.0)),
                              Text(
                                kIsWeb ? 'Tarik (Drag) atau Klik pemain' : 'Geser • Tahan drag / Tap',
                                style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.senyeraGold, fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildBenchTray(boardState.benchPlayers, boardState, context),
                          const SizedBox(height: 20),

                          // 3. Panel Slider Taktis Hansi Flick
                          Text('INSTRUKSI TAKTIK HANSI FLICK', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.0)),
                          const SizedBox(height: 10),
                          TacticalSlidersPanel(
                            ppda: boardState.ppdaIntensity,
                            defensiveLine: boardState.defensiveLineHeight,
                            tempo: boardState.buildUpTempo,
                            onPpdaChanged: (val) => context.read<TacticalBoardCubit>().updatePpda(val),
                            onDefensiveLineChanged: (val) => context.read<TacticalBoardCubit>().updateDefensiveLine(val),
                            onTempoChanged: (val) => context.read<TacticalBoardCubit>().updateTempo(val),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<SimulationCubit, SimulationState>(
          builder: (context, simState) {
            if (simState is SimulationLoading) return const SizedBox.shrink();

            return BlocBuilder<TacticalBoardCubit, TacticalBoardState>(
              builder: (context, boardState) {
                return Container(
                  color: BarcaColors.surfaceTier1,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 532 ? 500 : MediaQuery.of(context).size.width - 32,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BarcaColors.royalBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: BarcaColors.senyeraGold, width: 1.5),
                                ),
                                elevation: 10,
                              ),
                              onPressed: () {
                                context.read<SimulationCubit>().executeSimulation(
                                      matchId: match.id,
                                      formation: boardState.formation,
                                      startingXi: boardState.startingXiIds,
                                      ppda: boardState.ppdaIntensity,
                                      defensiveLine: boardState.defensiveLineHeight,
                                      tempo: boardState.buildUpTempo,
                                    );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.flash_on, color: BarcaColors.senyeraGold),
                                  const SizedBox(width: 8),
                                  Text('SIMULASIKAN PERTANDINGAN', style: BarcaTypography.headlineMd.copyWith(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBenchTray(List<PlayerModel> benchPlayers, TacticalBoardState boardState, BuildContext context) {
    if (benchPlayers.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('Semua pemain telah masuk Starting XI', style: TextStyle(color: Colors.white54))),
      );
    }

    return SizedBox(
      height: 74,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: benchPlayers.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final p = benchPlayers[index];
            final card = _buildBenchCard(p);

            if (kIsWeb) {
              return Draggable<PlayerModel>(
                data: p,
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: Material(
                  color: Colors.transparent,
                  child: Opacity(
                    opacity: 0.9,
                    child: _buildBenchCard(p, isDragging: true),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.25,
                  child: card,
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: GestureDetector(
                    onTap: () => _showPositionPickerForBenchPlayer(context, p, boardState),
                    child: card,
                  ),
                ),
              );
            }

            return LongPressDraggable<PlayerModel>(
              data: p,
              delay: const Duration(milliseconds: 180),
              hapticFeedbackOnStart: true,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: 0.9,
                  child: _buildBenchCard(p, isDragging: true),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.25,
                child: card,
              ),
              child: GestureDetector(
                onTap: () => _showPositionPickerForBenchPlayer(context, p, boardState),
                child: card,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBenchCard(PlayerModel p, {bool isDragging = false}) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: BarcaColors.surfaceTier1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BarcaColors.borderLight),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: BarcaColors.royalBlue.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: BarcaColors.royalBlue,
            child: Text('${p.shirtNumber}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  p.name.split(' ').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${p.position} • OVR ${p.overallRating}',
                  style: const TextStyle(fontSize: 10, color: BarcaColors.senyeraGold),
                ),
              ],
            ),
          ),
          const Icon(Icons.drag_indicator, size: 16, color: Colors.white30),
        ],
      ),
    );
  }

  void _showPositionPickerForBenchPlayer(BuildContext context, PlayerModel player, TacticalBoardState boardState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BarcaColors.surfaceTier1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: BarcaColors.royalBlue,
                      child: Text('${player.shirtNumber}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tempatkan ${player.name}', style: BarcaTypography.headlineMd.copyWith(fontSize: 16)),
                        Text('${player.position} • OVR ${player.overallRating}', style: const TextStyle(color: BarcaColors.senyeraGold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Pilih posisi di lapangan untuk digantikan:', style: BarcaTypography.bodySm.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: boardState.startingSlots.entries.map((entry) {
                      final slotKey = entry.key;
                      final currentPlayer = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          dense: true,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          tileColor: Colors.white.withOpacity(0.04),
                          leading: Container(
                            width: 44,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: BarcaColors.royalBlue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: BarcaColors.royalBlue),
                            ),
                            child: Text(slotKey, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          title: Text(
                            currentPlayer?.name ?? 'Kosong',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          subtitle: currentPlayer != null
                              ? Text('${currentPlayer.position} | OVR ${currentPlayer.overallRating}', style: const TextStyle(color: Colors.white54, fontSize: 11))
                              : null,
                          trailing: const Icon(Icons.swap_horiz, color: BarcaColors.senyeraGold, size: 20),
                          onTap: () {
                            context.read<TacticalBoardCubit>().assignPlayerToSlot(slotKey, player);
                            Navigator.pop(ctx);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSlotPlayerPicker(BuildContext context, String slotKey, TacticalBoardState boardState) {
    final currentPlayer = boardState.startingSlots[slotKey];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BarcaColors.surfaceTier1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Ganti Posisi [$slotKey]', style: BarcaTypography.headlineMd.copyWith(fontSize: 16)),
                if (currentPlayer != null)
                  Text('Saat ini: ${currentPlayer.name} (${currentPlayer.position} | OVR ${currentPlayer.overallRating})',
                      style: const TextStyle(color: BarcaColors.senyeraGold, fontSize: 12)),
                const SizedBox(height: 12),
                Text('Pilih pemain cadangan pengganti:', style: BarcaTypography.bodySm.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                if (boardState.benchPlayers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Tidak ada pemain di bangku cadangan', style: TextStyle(color: Colors.white54))),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: boardState.benchPlayers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (ctx, idx) {
                        final p = boardState.benchPlayers[idx];
                        return ListTile(
                          dense: true,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          tileColor: Colors.white.withOpacity(0.04),
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: BarcaColors.royalBlue,
                            child: Text('${p.shirtNumber}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          subtitle: Text('${p.position} | OVR ${p.overallRating}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                          trailing: const Icon(Icons.arrow_forward_ios, color: BarcaColors.senyeraGold, size: 14),
                          onTap: () {
                            context.read<TacticalBoardCubit>().assignPlayerToSlot(slotKey, p);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighTechLoader(SimulationLoading simLoading) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [BarcaColors.royalBlue, BarcaColors.obsidianCanvas],
                ),
                border: Border.all(color: BarcaColors.senyeraGold, width: 2),
                boxShadow: [
                  BoxShadow(color: BarcaColors.royalBlue.withOpacity(0.5), blurRadius: 24),
                ],
              ),
              child: const CircularProgressIndicator(
                color: BarcaColors.senyeraGold,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 28),
            Text('MEMPROSES SIMULASI TAKTIS', style: BarcaTypography.headlineMd),
            const SizedBox(height: 12),
            Text(
              simLoading.statusText,
              textAlign: TextAlign.center,
              style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.pitchGreen),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: simLoading.progress,
                minHeight: 6,
                backgroundColor: Colors.white12,
                color: BarcaColors.pitchGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

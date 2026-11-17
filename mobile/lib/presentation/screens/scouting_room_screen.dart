import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/glassmorphism.dart';
import '../../data/models/opponent_model.dart';

class ScoutingRoomScreen extends StatelessWidget {
  final OpponentModel opponent;

  const ScoutingRoomScreen({Key? key, required this.opponent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarcaColors.obsidianCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('OPPONENT SCOUTING', style: BarcaTypography.headlineMd),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Opponent Header Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              border: Border.all(color: BarcaColors.deepCrimson.withOpacity(0.4)),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white10,
                      border: Border.all(color: BarcaColors.borderLight, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        opponent.teamName.substring(0, 3).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opponent.teamName, style: BarcaTypography.headlineLg),
                        const SizedBox(height: 2),
                        Text(
                          'Pemain Kunci: ${opponent.keyPlayerName} (Pace: ${opponent.keyPlayerPace})',
                          style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.senyeraGold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Radar Chart Matriks Taktis 5-Poros
            Text('RADAR METRIKS TAKTIS 5-POROS', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.2)),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: RadarChart(
                      RadarChartData(
                        radarShape: RadarShape.polygon,
                        dataSets: [
                          RadarDataSet(
                            fillColor: BarcaColors.deepCrimson.withOpacity(0.45),
                            borderColor: BarcaColors.deepCrimson,
                            borderWidth: 2,
                            entryRadius: 3,
                            dataEntries: [
                              RadarEntry(value: opponent.attackingStrength.toDouble()),
                              RadarEntry(value: opponent.defensiveStrength.toDouble()),
                              RadarEntry(value: opponent.counterAttackThreat.toDouble()),
                              RadarEntry(value: opponent.pressingVulnerability.toDouble()),
                              RadarEntry(value: opponent.keyPlayerPace.toDouble()),
                            ],
                          ),
                        ],
                        radarBackgroundColor: Colors.transparent,
                        borderData: FlBorderData(show: false),
                        radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                        titlePositionPercentageOffset: 0.22,
                        titleTextStyle: BarcaTypography.telemetrySm.copyWith(color: Colors.white70),
                        getTitle: (index, angle) {
                          switch (index) {
                            case 0:
                              return RadarChartTitle(text: 'Daya Gedor (${opponent.attackingStrength})');
                            case 1:
                              return RadarChartTitle(text: 'Pertahanan (${opponent.defensiveStrength})');
                            case 2:
                              return RadarChartTitle(text: 'Serangan Balik (${opponent.counterAttackThreat})');
                            case 3:
                              return RadarChartTitle(text: 'Kerentanan Pressing (${opponent.pressingVulnerability})');
                            case 4:
                              return RadarChartTitle(text: 'Kecepatan (${opponent.keyPlayerPace})');
                            default:
                              return const RadarChartTitle(text: '');
                          }
                        },
                        tickCount: 4,
                        ticksTextStyle: const TextStyle(fontSize: 8, color: Colors.transparent),
                        tickBorderData: const BorderSide(color: Colors.white12, width: 0.8),
                        gridBorderData: const BorderSide(color: Colors.white12, width: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Semakin lebar area merah, semakin dominan ancaman spesifik lawan.',
                    style: BarcaTypography.bodySm.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Player Profile Card
            Text('PROFIL ANCAMAN PEMAIN UTAMA', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.2)),
            const SizedBox(height: 10),
            GlassCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BarcaColors.surfaceTier2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flash_on, color: BarcaColors.senyeraGold, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opponent.keyPlayerName, style: BarcaTypography.headlineMd.copyWith(fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Sprint Pace: ', style: BarcaTypography.bodySm),
                            Text('${opponent.keyPlayerPace}/100', style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.pitchGreen, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Text('Counter: ', style: BarcaTypography.bodySm),
                            Text('${opponent.counterAttackThreat}/100', style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.warningVermilion, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Scouting Intelligence Notes
            Text('CATATAN INTELIJEN TAKTIK', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.2)),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              border: Border.all(color: BarcaColors.royalBlue.withOpacity(0.3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb, color: BarcaColors.senyeraGold, size: 18),
                      const SizedBox(width: 8),
                      Text('Rekomendasi Staf Analis Ciutat Esportiva', style: BarcaTypography.headlineMd.copyWith(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opponent.scoutingNotes ?? 'Tidak ada catatan tambahan untuk lawan ini.',
                    style: BarcaTypography.bodyMd.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

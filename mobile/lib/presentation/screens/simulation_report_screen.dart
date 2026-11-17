import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/glassmorphism.dart';
import '../../data/models/match_model.dart';
import '../../data/models/simulation_result_model.dart';

class SimulationReportScreen extends StatelessWidget {
  final SimulationResultModel result;
  final MatchModel match;

  const SimulationReportScreen({
    Key? key,
    required this.result,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final probs = result.probabilities;
    final stats = result.projectedStats;

    return Scaffold(
      backgroundColor: BarcaColors.obsidianCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('POST-MATCH TACTICAL REPORT', style: BarcaTypography.headlineMd),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kartu Ringkasan Hasil & Nilai Taktik (Tactical Grade Badge)
            GlassCard(
              padding: const EdgeInsets.all(20),
              border: Border.all(color: BarcaColors.senyeraGold.withOpacity(0.5)),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [BarcaColors.senyeraGold, Color(0xFF8C6D00)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: BarcaColors.senyeraGold.withOpacity(0.4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        result.tacticalGrade,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GRADE TAKTIK HANSI FLICK', style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.senyeraGold)),
                        const SizedBox(height: 2),
                        Text(
                          'vs ${match.opponent!.teamName}',
                          style: BarcaTypography.headlineLg.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          probs.win >= 0.60
                              ? 'Struktur taktis sangat dominan dan solid.'
                              : 'Terdapat kerentanan transisi yang perlu dikoreksi.',
                          style: BarcaTypography.bodySm.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Donut Chart Persentase Probabilitas Hasil
            Text('PROBABILITAS HASIL LAGA (NAIVE BAYES MAP)', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.0)),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            color: BarcaColors.royalBlue,
                            value: probs.win * 100,
                            title: '${(probs.win * 100).toStringAsFixed(0)}%',
                            radius: 36,
                            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                          ),
                          PieChartSectionData(
                            color: Colors.blueGrey,
                            value: probs.draw * 100,
                            title: '${(probs.draw * 100).toStringAsFixed(0)}%',
                            radius: 32,
                            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                          ),
                          PieChartSectionData(
                            color: BarcaColors.deepCrimson,
                            value: probs.loss * 100,
                            title: '${(probs.loss * 100).toStringAsFixed(0)}%',
                            radius: 32,
                            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Menang', BarcaColors.royalBlue, probs.win),
                      _buildLegendItem('Seri', Colors.blueGrey, probs.draw),
                      _buildLegendItem('Kalah', BarcaColors.deepCrimson, probs.loss),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Grid Statistik Proyeksi Pertandingan
            Text('PROYEKSI STATISTIK PERTANDINGAN', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.0)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildMetricBox('Penguasaan Bola', '${stats.possessionPct}%', Icons.pie_chart, BarcaColors.pitchGreen)),
                const SizedBox(width: 10),
                Expanded(child: _buildMetricBox('xG Barcelona', '${stats.expectedGoalsBarca}', Icons.sports_soccer, BarcaColors.senyeraGold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildMetricBox('xG Lawan', '${stats.expectedGoalsOpponent}', Icons.shield, BarcaColors.warningVermilion)),
                const SizedBox(width: 10),
                Expanded(child: _buildMetricBox('Jebakan Offside', '${stats.offsideTrapsProjected}x', Icons.flag, BarcaColors.electricCyan)),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Kartu Umpan Balik Asisten Pelatih (Explainable AI Engine)
            Text('UMPAN BALIK ASISTEN PELATIH (EXPLAINABLE AI)', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.0)),
            const SizedBox(height: 10),
            ...result.assistantFeedback.map((fb) => _buildFeedbackCard(fb)).toList(),
            const SizedBox(height: 30),

            // 5. Tombol Aksi Kembali / Modifikasi
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BarcaColors.surfaceTier2,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: BarcaColors.borderLight),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ubah Taktik & Uji Ulang'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double val) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label: ${(val * 100).toStringAsFixed(0)}%', style: BarcaTypography.bodySm.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildMetricBox(String label, String value, IconData icon, Color accentColor) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: BarcaTypography.bodySm.copyWith(color: Colors.white70)),
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: BarcaTypography.headlineLg.copyWith(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackItemModel fb) {
    Color badgeColor;
    String badgeText;
    IconData icon;

    switch (fb.type) {
      case 'WARNING':
        badgeColor = BarcaColors.warningVermilion;
        badgeText = 'PERINGATAN RISIKO';
        icon = Icons.warning_amber_rounded;
        break;
      case 'RECOMMENDATION':
        badgeColor = BarcaColors.electricCyan;
        badgeText = 'REKOMENDASI TAKTIS';
        icon = Icons.lightbulb_outline;
        break;
      case 'STRENGTH':
      default:
        badgeColor = BarcaColors.pitchGreen;
        badgeText = 'KEKUATAN TAKTIS';
        icon = Icons.check_circle_outline;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: badgeColor, size: 16),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
                  ),
                ),
                const Spacer(),
                Text(fb.ruleId, style: BarcaTypography.telemetrySm),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              fb.text,
              style: BarcaTypography.bodyMd.copyWith(color: Colors.white, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

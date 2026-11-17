import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/glassmorphism.dart';

class TacticalSlidersPanel extends StatelessWidget {
  final double ppda;
  final double defensiveLine;
  final double tempo;
  final ValueChanged<double> onPpdaChanged;
  final ValueChanged<double> onDefensiveLineChanged;
  final ValueChanged<double> onTempoChanged;

  const TacticalSlidersPanel({
    Key? key,
    required this.ppda,
    required this.defensiveLine,
    required this.tempo,
    required this.onPpdaChanged,
    required this.onDefensiveLineChanged,
    required this.onTempoChanged,
  }) : super(key: key);

  String getPpdaLabel(double val) {
    if (val < 6.0) return 'EKSTREM AGRESIF (Aturan 6 Detik)';
    if (val < 8.5) return 'AGRESIF (Standar Hansi Flick)';
    if (val < 11.5) return 'MODERAT (Pressing Zonal)';
    return 'PASIF (Mid-to-Low Block)';
  }

  Color getPpdaColor(double val) {
    if (val < 6.0) return BarcaColors.pitchGreen;
    if (val < 8.5) return BarcaColors.senyeraGold;
    return BarcaColors.warningVermilion;
  }

  String getLineLabel(double val) {
    if (val >= 8.5) return 'EKSTREM TINGGI (Kompresi Vertikal Total)';
    if (val >= 6.5) return 'TINGGI STANDAR (Jebakan Offside Terkoordinasi)';
    if (val >= 4.0) return 'MEDIUM (Mengurangi Celah Belakang)';
    return 'RENDAH DALAM (Area Penalti Rapat)';
  }

  Color getLineColor(double val) {
    if (val >= 8.5) return BarcaColors.deepCrimson;
    if (val >= 6.5) return BarcaColors.royalBlue;
    return Colors.blueGrey;
  }

  String getTempoLabel(double val) {
    if (val >= 7.5) return 'VERTIKAL CEPAT (Transisi Langsung)';
    if (val >= 4.5) return 'FLUIDA TRANSISI (Sirkulasi Dinamis)';
    return 'POSSESSION SABAR (Juego de Posición)';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slider 1: Gegenpressing / PPDA
        _buildSliderTile(
          title: 'Gegenpressing Intensity (Target PPDA)',
          valueText: '${ppda.toStringAsFixed(1)} PPDA',
          semanticLabel: getPpdaLabel(ppda),
          labelColor: getPpdaColor(ppda),
          value: ppda,
          min: 2.0,
          max: 15.0,
          onChanged: onPpdaChanged,
        ),
        const SizedBox(height: 12),

        // Slider 2: Defensive Line Height
        _buildSliderTile(
          title: 'Defensive Line Height (Ketinggian Garis)',
          valueText: 'Level ${defensiveLine.toStringAsFixed(1)}',
          semanticLabel: getLineLabel(defensiveLine),
          labelColor: getLineColor(defensiveLine),
          value: defensiveLine,
          min: 1.0,
          max: 10.0,
          onChanged: onDefensiveLineChanged,
        ),
        const SizedBox(height: 12),

        // Slider 3: Build-up Tempo
        _buildSliderTile(
          title: 'Build-up Tempo (Kecepatan Aliran Bola)',
          valueText: 'Tempo ${tempo.toStringAsFixed(1)}',
          semanticLabel: getTempoLabel(tempo),
          labelColor: BarcaColors.senyeraGold,
          value: tempo,
          min: 1.0,
          max: 10.0,
          onChanged: onTempoChanged,
        ),
      ],
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String valueText,
    required String semanticLabel,
    required Color labelColor,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: BarcaTypography.bodySm.copyWith(color: Colors.white70)),
              Text(valueText, style: BarcaTypography.telemetryMd.copyWith(color: BarcaColors.senyeraGold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            semanticLabel,
            style: BarcaTypography.telemetrySm.copyWith(color: labelColor, fontWeight: FontWeight.bold),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: labelColor,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              overlayColor: labelColor.withOpacity(0.2),
              trackHeight: 3.5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

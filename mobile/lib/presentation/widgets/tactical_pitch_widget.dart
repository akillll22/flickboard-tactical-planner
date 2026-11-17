import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../data/models/player_model.dart';

class TacticalPitchWidget extends StatelessWidget {
  final String formation;
  final Map<String, PlayerModel?> slots;
  final Function(String slotKey, PlayerModel player) onPlayerDropped;
  final Function(String slotKey)? onSlotTapped;

  const TacticalPitchWidget({
    Key? key,
    required this.formation,
    required this.slots,
    required this.onPlayerDropped,
    this.onSlotTapped,
  }) : super(key: key);

  // Koordinat slot (x: 0.0 - 1.0, y: 0.0 - 1.0) untuk formasi 4-2-3-1
  static const Map<String, Offset> coordinates4231 = {
    'GK': Offset(0.50, 0.90),
    'LB': Offset(0.15, 0.73),
    'LCB': Offset(0.38, 0.76),
    'RCB': Offset(0.62, 0.76),
    'RB': Offset(0.85, 0.73),
    'LDM': Offset(0.35, 0.56),
    'RDM': Offset(0.65, 0.56),
    'LW': Offset(0.18, 0.35),
    'AM': Offset(0.50, 0.38),
    'RW': Offset(0.82, 0.35),
    'CF': Offset(0.50, 0.16),
  };

  // Koordinat slot formasi transisi in-possession 3-2-4-1 khas Hansi Flick
  static const Map<String, Offset> coordinates3241 = {
    'GK': Offset(0.50, 0.90),
    'LCB': Offset(0.24, 0.77),
    'CB': Offset(0.50, 0.78),
    'RCB': Offset(0.76, 0.77),
    'LDM': Offset(0.36, 0.60),
    'RDM': Offset(0.64, 0.60),
    'LW': Offset(0.10, 0.36),
    'LAM': Offset(0.36, 0.36),
    'RAM': Offset(0.64, 0.36),
    'RW': Offset(0.90, 0.36),
    'CF': Offset(0.50, 0.15),
  };

  @override
  Widget build(BuildContext context) {
    final activeCoords = formation == '3-2-4-1' ? coordinates3241 : coordinates4231;

    return AspectRatio(
      aspectRatio: 0.72, // Rasio lapangan sepak bola vertikal
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1A12), // Deep tactical green base
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BarcaColors.borderSubtle, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 1. Gambar Garis Lapangan Taktis
              CustomPaint(
                size: Size.infinite,
                painter: PitchMarkingsPainter(),
              ),

              // 2. Render Pin Pemain & Target Drag and Drop
              ...activeCoords.entries.map((entry) {
                final slotKey = entry.key;
                final offset = entry.value;
                final player = slots[slotKey];

                return Align(
                  alignment: FractionalOffset(offset.dx, offset.dy),
                  child: DragTarget<PlayerModel>(
                    onWillAcceptWithDetails: (details) => true,
                    onAcceptWithDetails: (details) {
                      onPlayerDropped(slotKey, details.data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovered = candidateData.isNotEmpty;

                      return GestureDetector(
                        onTap: () => onSlotTapped?.call(slotKey),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isHovered ? BarcaColors.pitchGreen.withOpacity(0.35) : Colors.transparent,
                            border: isHovered
                                ? Border.all(color: BarcaColors.pitchGreen, width: 2.0)
                                : null,
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: BarcaColors.pitchGreen.withOpacity(0.8),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: _buildDraggablePlayerPin(slotKey, player),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggablePlayerPin(String slotKey, PlayerModel? player) {
    if (player == null) {
      return _buildPlayerPin(slotKey, null);
    }

    final pinWidget = _buildPlayerPin(slotKey, player);

    if (kIsWeb) {
      return Draggable<PlayerModel>(
        data: player,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.9,
            child: pinWidget,
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.25,
          child: pinWidget,
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: pinWidget,
        ),
      );
    }

    return LongPressDraggable<PlayerModel>(
      data: player,
      delay: const Duration(milliseconds: 180),
      hapticFeedbackOnStart: true,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.9,
          child: pinWidget,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: pinWidget,
      ),
      child: pinWidget,
    );
  }

  Widget _buildPlayerPin(String slotKey, PlayerModel? player) {
    if (player == null) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: BarcaColors.surfaceTier1.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30, width: 1.2),
        ),
        child: Center(
          child: Text(
            slotKey,
            style: BarcaTypography.telemetrySm.copyWith(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [BarcaColors.royalBlue, BarcaColors.deepCrimson],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: BarcaColors.senyeraGold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${player.shirtNumber}',
              style: BarcaTypography.telemetryMd.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24, width: 0.5),
          ),
          child: Text(
            _getDisplayName(player.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _getDisplayName(String fullName) {
    if (fullName.contains('Eric') && fullName.contains('Garcia')) return 'Eric Garcia';
    if (fullName.contains('Joan') || (fullName.contains('Garcia') && !fullName.contains('Eric'))) return 'Joan Garcia';
    if (fullName.contains('Szczesny')) return 'Szczesny';
    if (fullName.contains('Livakovic')) return 'Livakovic';
    if (fullName.contains('Cancelo')) return 'Cancelo';
    if (fullName.contains('Cubarsi')) return 'Cubarsi';
    if (fullName.contains('Kounde')) return 'Kounde';
    if (fullName.contains('Christensen')) return 'Christensen';
    if (fullName.contains('Balde')) return 'Balde';
    if (fullName.contains('Martin')) return 'G. Martin';
    if (fullName.contains('Rodri')) return 'Rodri';
    if (fullName.contains('Pedri')) return 'Pedri';
    if (fullName.contains('Gavi')) return 'Gavi';
    if (fullName.toLowerCase().contains('jong')) return 'De Jong';
    if (fullName.contains('Olmo')) return 'Dani Olmo';
    if (fullName.contains('Fermin')) return 'Fermin';
    if (fullName.contains('Bernal')) return 'Bernal';
    if (fullName.contains('Yamal') || fullName.contains('Lamine')) return 'Lamine Yamal';
    if (fullName.contains('Raphinha')) return 'Raphinha';
    if (fullName.contains('Jesus') || fullName.contains('Gabriel')) return 'Gabriel Jesus';
    if (fullName.contains('Gordon')) return 'Gordon';
    if (fullName.contains('Adeyemi')) return 'Adeyemi';
    if (fullName.contains('Bardghji')) return 'Bardghji';
    if (fullName.contains('Abdelkarim')) return 'Abdelkarim';
    return fullName.split(' ').last;
  }
}

class PitchMarkingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final spotPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer Boundary
    canvas.drawRect(Rect.fromLTWH(10, 10, w - 20, h - 20), paint);

    // Halfway Line
    canvas.drawLine(Offset(10, h / 2), Offset(w - 10, h / 2), paint);

    // Center Circle & Spot
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.16, paint);
    canvas.drawCircle(Offset(w / 2, h / 2), 3, spotPaint);

    // Top Penalty Area (Opponent Box)
    canvas.drawRect(Rect.fromLTWH(w * 0.20, 10, w * 0.60, h * 0.16), paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.35, 10, w * 0.30, h * 0.06), paint);
    canvas.drawCircle(Offset(w / 2, 10 + h * 0.11), 2.5, spotPaint);

    // Bottom Penalty Area (Barca Box)
    canvas.drawRect(Rect.fromLTWH(w * 0.20, h - 10 - h * 0.16, w * 0.60, h * 0.16), paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.35, h - 10 - h * 0.06, w * 0.30, h * 0.06), paint);
    canvas.drawCircle(Offset(w / 2, h - 10 - h * 0.11), 2.5, spotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

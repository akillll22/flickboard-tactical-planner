import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/glassmorphism.dart';
import '../../data/models/match_model.dart';
import '../../data/repositories/tactical_repository.dart';
import 'scouting_room_screen.dart';
import 'tactical_board_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final TacticalRepository repository = TacticalRepository();
  List<MatchModel> matches = [];
  int selectedMatchIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatchData();
  }

  void _loadMatchData() async {
    final loadedMatches = await repository.getUpcomingMatches();
    setState(() {
      matches = loadedMatches.isNotEmpty ? loadedMatches : TacticalRepository.mockMatches;
      isLoading = false;
    });
  }

  MatchModel get currentMatch => matches.isNotEmpty ? matches[selectedMatchIndex] : TacticalRepository.mockMatch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarcaColors.obsidianCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [BarcaColors.royalBlue, BarcaColors.deepCrimson],
                ),
              ),
              child: const Icon(Icons.shield, color: BarcaColors.senyeraGold, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BARÇA TACTICAL PLANNER', style: BarcaTypography.headlineMd.copyWith(fontSize: 16)),
                Text('Ciutat Esportiva Joan Gamper • Hansi Flick Blueprint', style: BarcaTypography.telemetrySm),
              ],
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: BarcaColors.senyeraGold))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner Analis
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: BarcaColors.surfaceTier1.withOpacity(0.9),
                    border: Border.all(color: BarcaColors.royalBlue.withOpacity(0.4)),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: BarcaColors.royalBlue,
                          child: Icon(Icons.psychology, color: BarcaColors.senyeraGold, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ruang Analis Taktik Hansi Flick', style: BarcaTypography.headlineMd.copyWith(fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(
                                'Formulasi strategi Gegenpressing & Jebakan Offside aktif untuk jadwal laga musim ini.',
                                style: BarcaTypography.bodySm,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Carousel Jadwal Pertandingan Musim 2026/2027
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('JADWAL PERTANDINGAN (PILIH LAWAN)', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.2)),
                      Text('${selectedMatchIndex + 1}/${matches.length} Laga', style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.senyeraGold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildMatchSelector(),
                  const SizedBox(height: 20),

                  // Selected Match Card Detail
                  Text('DETAIL PERTANDINGAN TERPILIH', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  _buildNextMatchCard(currentMatch),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BarcaColors.surfaceTier2,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: BarcaColors.borderLight),
                            ),
                          ),
                          icon: const Icon(Icons.analytics_outlined, size: 18),
                          label: const Text('Scouting Lawan'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ScoutingRoomScreen(opponent: currentMatch.opponent!),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BarcaColors.royalBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: BarcaColors.senyeraGold, width: 1.2),
                            ),
                            elevation: 8,
                          ),
                          icon: const Icon(Icons.sports_soccer, size: 18),
                          label: const Text('Papan Taktik'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TacticalBoardScreen(match: currentMatch),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Squad Fitness & Readiness Card
                  Text('STATUS KEBUGARAN SKUAD 2026/2027', style: BarcaTypography.telemetryMd.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  _buildSquadFitnessCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildMatchSelector() {
    return SizedBox(
      height: 95,
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
          itemCount: matches.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final m = matches[index];
            final isSelected = index == selectedMatchIndex;
            final isUCL = m.competition.contains('Champions');

            return InkWell(
              onTap: () {
                setState(() {
                  selectedMatchIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 180,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? BarcaColors.surfaceTier2 : BarcaColors.surfaceTier1.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? BarcaColors.senyeraGold : BarcaColors.borderSubtle,
                    width: isSelected ? 1.8 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: BarcaColors.senyeraGold.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isUCL ? BarcaColors.royalBlue.withOpacity(0.4) : BarcaColors.deepCrimson.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isUCL ? 'UCL' : 'LA LIGA',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isUCL ? BarcaColors.electricCyan : BarcaColors.senyeraGold,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM').format(m.matchDate),
                          style: const TextStyle(fontSize: 10, color: Colors.white54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white12,
                          child: Text(
                            (m.opponent?.teamName.substring(0, 1) ?? 'L'),
                            style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'vs ${m.opponent?.teamName ?? 'Lawan'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      m.venue.contains('Montjuïc') || m.venue.startsWith('HOME') ? 'Estadi Olímpic (Montjuïc)' : 'Laga Tandang (Away)',
                      style: const TextStyle(fontSize: 9, color: Colors.white38),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNextMatchCard(MatchModel match) {
    final opp = match.opponent!;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      border: Border.all(color: BarcaColors.borderLight),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BarcaColors.royalBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(match.competition, style: BarcaTypography.telemetrySm.copyWith(color: BarcaColors.senyeraGold)),
              ),
              Text(
                'VENUE: ${match.venue}',
                style: BarcaTypography.telemetrySm.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // FC Barcelona
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [BarcaColors.royalBlue, BarcaColors.deepCrimson],
                      ),
                      border: Border.all(color: BarcaColors.senyeraGold, width: 2),
                    ),
                    child: const Center(
                      child: Text('FCB', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('FC Barcelona', style: BarcaTypography.headlineMd.copyWith(fontSize: 15)),
                ],
              ),
              Text('VS', style: BarcaTypography.headlineLg.copyWith(color: Colors.white30)),
              // Opponent
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                      border: Border.all(color: BarcaColors.borderLight, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        opp.teamName.substring(0, 3).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(opp.teamName, style: BarcaTypography.headlineMd.copyWith(fontSize: 15)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          Text(
            match.contextDescription,
            textAlign: TextAlign.center,
            style: BarcaTypography.bodySm.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSquadFitnessCard() {
    return GlassCard(
      child: Column(
        children: [
          _buildFitnessRow('Yamal Lamine & Raphinha', '100% Siap (Pilar Sayap Utama)', BarcaColors.pitchGreen),
          const SizedBox(height: 10),
          _buildFitnessRow('Pedri & Rodri', '99% Siap (Double Pivot Kunci)', BarcaColors.pitchGreen),
          const SizedBox(height: 10),
          _buildFitnessRow('Jesus Gabriel & Dani Olmo', '96% Siap (Lini Serang Sentral)', BarcaColors.pitchGreen),
          const SizedBox(height: 10),
          _buildFitnessRow('Pau Cubarsi & Christensen', '98% Siap (Dinding Pertahanan)', BarcaColors.pitchGreen),
          const SizedBox(height: 10),
          _buildFitnessRow('Joan Garcia / Szczesny', '95% Siap (Penjaga Gawang)', BarcaColors.senyeraGold),
        ],
      ),
    );
  }

  Widget _buildFitnessRow(String title, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: BarcaTypography.bodyMd.copyWith(color: Colors.white)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

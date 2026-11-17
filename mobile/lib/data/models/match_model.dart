import 'opponent_model.dart';

class MatchModel {
  final int id;
  final int opponentId;
  final DateTime matchDate;
  final String venue;
  final String competition;
  final String contextDescription;
  final String status;
  final OpponentModel? opponent;

  const MatchModel({
    required this.id,
    required this.opponentId,
    required this.matchDate,
    required this.venue,
    required this.competition,
    required this.contextDescription,
    required this.status,
    this.opponent,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'],
      opponentId: json['opponent_id'],
      matchDate: DateTime.parse(json['match_date']),
      venue: json['venue'] ?? 'HOME',
      competition: json['competition'] ?? 'La Liga EA Sports',
      contextDescription: json['context_description'] ?? '',
      status: json['status'] ?? 'UPCOMING',
      opponent: json['opponent'] != null ? OpponentModel.fromJson(json['opponent']) : null,
    );
  }
}

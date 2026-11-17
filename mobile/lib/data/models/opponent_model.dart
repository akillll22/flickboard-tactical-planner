class OpponentModel {
  final int id;
  final String teamName;
  final String? logoUrl;
  final int attackingStrength;
  final int defensiveStrength;
  final int pressingVulnerability;
  final int counterAttackThreat;
  final String keyPlayerName;
  final int keyPlayerPace;
  final String? scoutingNotes;

  const OpponentModel({
    required this.id,
    required this.teamName,
    this.logoUrl,
    required this.attackingStrength,
    required this.defensiveStrength,
    required this.pressingVulnerability,
    required this.counterAttackThreat,
    required this.keyPlayerName,
    required this.keyPlayerPace,
    this.scoutingNotes,
  });

  factory OpponentModel.fromJson(Map<String, dynamic> json) {
    return OpponentModel(
      id: json['id'],
      teamName: json['team_name'],
      logoUrl: json['logo_url'],
      attackingStrength: json['attacking_strength'],
      defensiveStrength: json['defensive_strength'],
      pressingVulnerability: json['pressing_vulnerability'],
      counterAttackThreat: json['counter_attack_threat'],
      keyPlayerName: json['key_player_name'],
      keyPlayerPace: json['key_player_pace'],
      scoutingNotes: json['scouting_notes'],
    );
  }
}

class ProbabilitiesModel {
  final double win;
  final double draw;
  final double loss;

  const ProbabilitiesModel({
    required this.win,
    required this.draw,
    required this.loss,
  });

  factory ProbabilitiesModel.fromJson(Map<String, dynamic> json) {
    return ProbabilitiesModel(
      win: (json['win'] as num).toDouble(),
      draw: (json['draw'] as num).toDouble(),
      loss: (json['loss'] as num).toDouble(),
    );
  }
}

class ProjectedStatsModel {
  final double possessionPct;
  final double expectedGoalsBarca;
  final double expectedGoalsOpponent;
  final double offsideTrapsProjected;

  const ProjectedStatsModel({
    required this.possessionPct,
    required this.expectedGoalsBarca,
    required this.expectedGoalsOpponent,
    required this.offsideTrapsProjected,
  });

  factory ProjectedStatsModel.fromJson(Map<String, dynamic> json) {
    return ProjectedStatsModel(
      possessionPct: (json['possession_pct'] as num).toDouble(),
      expectedGoalsBarca: (json['expected_goals_barca'] as num).toDouble(),
      expectedGoalsOpponent: (json['expected_goals_opponent'] as num).toDouble(),
      offsideTrapsProjected: (json['offside_traps_projected'] as num).toDouble(),
    );
  }
}

class FeedbackItemModel {
  final String type; // STRENGTH, WARNING, RECOMMENDATION
  final String ruleId;
  final String text;

  const FeedbackItemModel({
    required this.type,
    required this.ruleId,
    required this.text,
  });

  factory FeedbackItemModel.fromJson(Map<String, dynamic> json) {
    return FeedbackItemModel(
      type: json['type'] ?? 'INFO',
      ruleId: json['rule_id'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class SimulationResultModel {
  final String status;
  final int matchId;
  final ProbabilitiesModel probabilities;
  final String tacticalGrade;
  final ProjectedStatsModel projectedStats;
  final List<FeedbackItemModel> assistantFeedback;
  final int? simulationId;
  final bool fromCache;

  const SimulationResultModel({
    required this.status,
    required this.matchId,
    required this.probabilities,
    required this.tacticalGrade,
    required this.projectedStats,
    required this.assistantFeedback,
    this.simulationId,
    this.fromCache = false,
  });

  factory SimulationResultModel.fromJson(Map<String, dynamic> json) {
    return SimulationResultModel(
      status: json['status'] ?? 'success',
      matchId: json['match_id'] ?? 0,
      probabilities: ProbabilitiesModel.fromJson(json['probabilities']),
      tacticalGrade: json['tactical_grade'] ?? 'B',
      projectedStats: ProjectedStatsModel.fromJson(json['projected_stats']),
      assistantFeedback: (json['assistant_feedback'] as List? ?? [])
          .map((item) => FeedbackItemModel.fromJson(item))
          .toList(),
      simulationId: json['simulation_id'],
      fromCache: json['from_cache'] ?? false,
    );
  }
}

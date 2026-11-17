from typing import List, Optional, Literal
from pydantic import BaseModel, Field

class TacticalParameters(BaseModel):
    ppda_intensity: float = Field(..., ge=2.0, le=15.0, description="Passes Per Defensive Action target (2.0 - 15.0)")
    defensive_line_height: float = Field(..., ge=1.0, le=10.0, description="Garis Pertahanan (1.0 - 10.0)")
    build_up_tempo: float = Field(..., ge=1.0, le=10.0, description="Tempo Build-up (1.0 - 10.0)")

class OpponentAttributes(BaseModel):
    id: Optional[int] = None
    team_name: str = "Opponent FC"
    attacking_strength: int = Field(75, ge=1, le=100)
    defensive_strength: int = Field(75, ge=1, le=100)
    pressing_vulnerability: int = Field(50, ge=1, le=100)
    counter_attack_threat: int = Field(60, ge=1, le=100)
    key_player_name: str = "Star Forward"
    key_player_pace: int = Field(80, ge=1, le=100)

class TeamAggregates(BaseModel):
    team_avg_pace: float = Field(81.0, ge=1.0, le=100.0)
    team_avg_passing: float = Field(84.0, ge=1.0, le=100.0)
    team_avg_defending: float = Field(79.0, ge=1.0, le=100.0)
    defense_avg_pace: float = Field(78.0, ge=1.0, le=100.0)
    pivot_defensive_power: float = Field(80.0, ge=1.0, le=100.0)

class SimulationRequest(BaseModel):
    user_id: int = 1
    match_id: int
    opponent_id: int
    formation_used: str = "4-2-3-1"
    starting_xi: List[int] = Field(..., min_length=11, max_length=11)
    tactical_parameters: TacticalParameters
    opponent: Optional[OpponentAttributes] = None
    team_aggregates: Optional[TeamAggregates] = None

class Probabilities(BaseModel):
    win: float
    draw: float
    loss: float

class ProjectedStats(BaseModel):
    possession_pct: float
    expected_goals_barca: float
    expected_goals_opponent: float
    offside_traps_projected: float

class AssistantFeedback(BaseModel):
    type: Literal["STRENGTH", "WARNING", "RECOMMENDATION", "INFO"]
    rule_id: str
    text: str

class SimulationResponse(BaseModel):
    status: str = "success"
    match_id: int
    probabilities: Probabilities
    tactical_grade: str
    projected_stats: ProjectedStats
    assistant_feedback: List[AssistantFeedback]
    simulation_id: Optional[int] = None

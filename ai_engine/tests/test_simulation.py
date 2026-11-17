import pytest
from app.schemas.tactical import (
    SimulationRequest,
    TacticalParameters,
    OpponentAttributes,
    TeamAggregates
)
from app.services.naive_bayes_service import NaiveBayesService
from app.services.decision_tree_service import DecisionTreeXAIEngine
from app.services.projected_stats_service import ProjectedStatsService

@pytest.fixture
def services():
    return {
        "nb": NaiveBayesService(),
        "xai": DecisionTreeXAIEngine(),
        "stats": ProjectedStatsService()
    }

def test_tc01_real_madrid_high_line_passive_pressing(services):
    """
    TC-01: El Clásico vs Real Madrid
    Garis pertahanan ekstrem (9.5), Pressing pasif (12.0).
    Lawan: Mbappe/Vinicius Jr (Pace: 92, Counter threat: 88).
    Expected: Probabilitas kalah tinggi (> 0.50), peringatan XAI muncul.
    """
    tactics = TacticalParameters(
        ppda_intensity=12.0,
        defensive_line_height=9.5,
        build_up_tempo=6.0
    )
    opponent = OpponentAttributes(
        team_name="Real Madrid",
        attacking_strength=90,
        defensive_strength=86,
        pressing_vulnerability=42,
        counter_attack_threat=90,
        key_player_name="Kylian Mbappé",
        key_player_pace=94
    )
    team = TeamAggregates(
        team_avg_pace=82.0,
        team_avg_passing=85.0,
        team_avg_defending=80.0,
        defense_avg_pace=77.0,
        pivot_defensive_power=79.0
    )

    probs = services["nb"].compute_probabilities(tactics, opponent, team)
    feedback = services["xai"].generate_feedback(tactics, opponent, team)

    # Probabilitas kalah harus tinggi karena High Line tanpa pressing adalah kelemahan fatal
    assert probs.loss >= 0.45
    # Harus ada peringatan (WARNING) menyebutkan nama Mbappe atau garis pertahanan
    warnings = [f for f in feedback if f.type == "WARNING"]
    assert len(warnings) > 0
    assert any("Mbappé" in f.text or "ruang" in f.text for f in warnings)

def test_tc02_real_madrid_tactical_adaptation(services):
    """
    TC-02: El Clásico vs Real Madrid (Koreksi Taktis Adaptif)
    Garis diturunkan ke 6.5, PPDA dinaikkan ke 4.5 (Agresif), Double Pivot kokoh.
    Expected: Probabilitas menang melonjak (> 0.55), umpan balik positif/apresiasi.
    """
    tactics = TacticalParameters(
        ppda_intensity=4.5,
        defensive_line_height=6.5,
        build_up_tempo=7.5
    )
    opponent = OpponentAttributes(
        team_name="Real Madrid",
        attacking_strength=90,
        defensive_strength=86,
        pressing_vulnerability=42,
        counter_attack_threat=90,
        key_player_name="Kylian Mbappé",
        key_player_pace=94
    )
    team = TeamAggregates(
        team_avg_pace=84.0,
        team_avg_passing=86.0,
        team_avg_defending=82.0,
        defense_avg_pace=80.0,
        pivot_defensive_power=84.0
    )

    probs = services["nb"].compute_probabilities(tactics, opponent, team)
    feedback = services["xai"].generate_feedback(tactics, opponent, team)

    assert probs.win >= 0.55
    assert probs.loss < 0.35
    strengths = [f for f in feedback if f.type == "STRENGTH"]
    assert len(strengths) > 0

def test_tc03_bayern_munich_pressing_duel(services):
    """
    TC-03: Duel Tekanan vs Bayern Munchen
    PPDA = 5.0 (Ekstrem Agresif), Line = 7.5 (Tinggi), Tempo = 8.0 (Cepat).
    Expected: Laga sengit terbuka, xG tinggi (> 1.8), Grade A atau A+.
    """
    tactics = TacticalParameters(
        ppda_intensity=5.0,
        defensive_line_height=7.5,
        build_up_tempo=8.0
    )
    opponent = OpponentAttributes(
        team_name="Bayern München",
        attacking_strength=92,
        defensive_strength=85,
        pressing_vulnerability=45,
        counter_attack_threat=82,
        key_player_name="Harry Kane",
        key_player_pace=78
    )
    team = TeamAggregates(
        team_avg_pace=84.0,
        team_avg_passing=86.0,
        team_avg_defending=82.0,
        defense_avg_pace=80.0,
        pivot_defensive_power=84.0
    )

    probs = services["nb"].compute_probabilities(tactics, opponent, team)
    stats, grade = services["stats"].calculate_stats(tactics, opponent, team, probs.win, probs.loss)
    feedback = services["xai"].generate_feedback(tactics, opponent, team)

    assert stats.expected_goals_barca >= 1.80
    assert grade in ["S", "A+", "A", "B+"]
    assert len(feedback) >= 2

def test_tc04_getafe_low_block_possession(services):
    """
    TC-04: Blok Rendah vs Getafe CF
    Penguasaan bola tinggi (> 65%), saran menembus blok rendah.
    """
    tactics = TacticalParameters(
        ppda_intensity=6.0,
        defensive_line_height=7.0,
        build_up_tempo=3.5 # Tempo lambat
    )
    opponent = OpponentAttributes(
        team_name="Getafe CF",
        attacking_strength=65,
        defensive_strength=84,
        pressing_vulnerability=68,
        counter_attack_threat=50,
        key_player_name="Borja Mayoral",
        key_player_pace=72
    )
    team = TeamAggregates(
        team_avg_pace=82.0,
        team_avg_passing=86.0,
        team_avg_defending=80.0,
        defense_avg_pace=78.0,
        pivot_defensive_power=80.0
    )

    probs = services["nb"].compute_probabilities(tactics, opponent, team)
    stats, grade = services["stats"].calculate_stats(tactics, opponent, team, probs.win, probs.loss)
    feedback = services["xai"].generate_feedback(tactics, opponent, team)

    assert stats.possession_pct >= 65.0
    # Rekomendasi menembus blok rapat
    assert any("half-space" in f.text or "sirkulasi" in f.text for f in feedback)

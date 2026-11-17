from ..schemas.tactical import TacticalParameters, OpponentAttributes, TeamAggregates, ProjectedStats

class ProjectedStatsService:
    """
    Kalkulator statistik proyeksi pertandingan sepak bola (xG, Penguasaan Bola, Jebakan Offside, Nilai Taktik).
    """

    @staticmethod
    def calculate_stats(
        tactics: TacticalParameters,
        opponent: OpponentAttributes,
        team_aggregates: TeamAggregates,
        win_prob: float,
        loss_prob: float
    ) -> tuple[ProjectedStats, str]:
        # 1. Proyeksi Penguasaan Bola (Possession %)
        # Dipengaruhi oleh tempo, passing skuad, dan intensitas pressing
        base_possession = 58.0
        passing_impact = (team_aggregates.team_avg_passing - 75.0) * 0.4
        pressing_impact = (10.0 - tactics.ppda_intensity) * 0.8
        tempo_impact = (7.0 - tactics.build_up_tempo) * 1.0
        # Tim dengan daya serang rendah (low block) membiarkan Barca mendominasi bola
        opponent_possession_contest = (opponent.attacking_strength - 70.0) * 0.2

        possession = base_possession + passing_impact + pressing_impact + tempo_impact - opponent_possession_contest
        possession = max(42.0, min(82.0, round(possession, 1)))

        # 2. Proyeksi Expected Goals (xG) Barca
        # Dipengaruhi tempo, kualitas penyerangan, kerentanan lawan
        base_xg_barca = 1.75
        xg_tempo = (tactics.build_up_tempo - 5.0) * 0.12
        xg_pressing = (10.0 - tactics.ppda_intensity) * 0.08
        xg_vulnerability = (opponent.pressing_vulnerability - 50.0) * 0.015
        xg_defense_opp = (80.0 - opponent.defensive_strength) * 0.02

        xg_barca = base_xg_barca + xg_tempo + xg_pressing + xg_vulnerability + xg_defense_opp
        xg_barca = max(0.60, min(4.20, round(xg_barca, 2)))

        # 3. Proyeksi Expected Goals (xG) Lawan
        # Dipengaruhi ancaman counter, garis pertahanan tinggi, pace pemain kunci lawan
        base_xg_opp = 0.90
        counter_factor = (opponent.counter_attack_threat - 50.0) * 0.018
        pace_factor = (opponent.key_player_pace - 75.0) * 0.02
        line_risk = 0.0

        if tactics.defensive_line_height >= 8.5:
            # Garis tinggi ekstrem: jika PPDA pasif (> 8.0), resiko jebol tinggi
            if tactics.ppda_intensity > 8.0:
                line_risk = 0.75 + (tactics.defensive_line_height - 8.5) * 0.3
            else:
                line_risk = 0.15
        elif tactics.defensive_line_height <= 4.0:
            # Garis rendah memberi ruang lawan menembak dari luar kotak
            line_risk = 0.30

        xg_opp = base_xg_opp + counter_factor + pace_factor + line_risk
        xg_opp = max(0.20, min(3.80, round(xg_opp, 2)))

        # 4. Proyeksi Jebakan Offside (Offside Traps Projected)
        # Khas Hansi Flick: semakin tinggi garis pertahanan dan semakin terkoordinasi, semakin banyak offside trap
        base_offside = 2.0
        line_offside = (tactics.defensive_line_height / 10.0) * 4.5
        pace_trigger = (opponent.key_player_pace / 100.0) * 1.5
        projected_offside = max(1.0, min(8.5, round(base_offside + line_offside + pace_trigger, 1)))

        projected = ProjectedStats(
            possession_pct=possession,
            expected_goals_barca=xg_barca,
            expected_goals_opponent=xg_opp,
            offside_traps_projected=projected_offside
        )

        # 5. Penentuan Tactical Grade (S, A+, A, B+, B, C, D)
        net_xg = xg_barca - xg_opp
        if win_prob >= 0.72 and net_xg >= 1.5:
            grade = "S"
        elif win_prob >= 0.62 and net_xg >= 0.9:
            grade = "A+"
        elif win_prob >= 0.52 and net_xg >= 0.4:
            grade = "A"
        elif win_prob >= 0.42:
            grade = "B+"
        elif win_prob >= 0.35:
            grade = "B"
        elif win_prob >= 0.25:
            grade = "C"
        else:
            grade = "D"

        return projected, grade

import math
from typing import Dict
from ..core.discretizer import Discretizer
from ..schemas.tactical import TacticalParameters, OpponentAttributes, TeamAggregates, Probabilities

class NaiveBayesService:
    """
    Naive Bayes Classifier berbasis Maximum A Posteriori (MAP)
    untuk menghitung probabilitas hasil pertandingan secara seketika (real-time).
    """

    def __init__(self):
        # Prior probabilities log-odds (diselaraskan dengan baseline dominasi Hansi Flick)
        # Dilakukan penyesuaian bobot kelas (Class Weights) agar tidak bias naif
        self.log_priors = {
            "win": math.log(0.60),
            "draw": math.log(0.22),
            "loss": math.log(0.18)
        }

    def compute_probabilities(
        self,
        tactics: TacticalParameters,
        opponent: OpponentAttributes,
        team_aggregates: TeamAggregates
    ) -> Probabilities:
        # 1. Diskretisasi parameter kontinu
        ppda_cat = Discretizer.discretize_ppda(tactics.ppda_intensity)
        line_cat = Discretizer.discretize_defensive_line(tactics.defensive_line_height)
        tempo_cat = Discretizer.discretize_tempo(tactics.build_up_tempo)
        pace_cat = Discretizer.discretize_pace(opponent.key_player_pace)
        vulnerability_cat = Discretizer.discretize_pressing_vulnerability(opponent.pressing_vulnerability)

        # 2. Inisialisasi skor log posterior dengan log prior
        log_scores = {
            "win": self.log_priors["win"],
            "draw": self.log_priors["draw"],
            "loss": self.log_priors["loss"]
        }

        # 3. Pengaruh Fitur PPDA vs Pressing Vulnerability (Synergy Interaction)
        if ppda_cat in ["EKSTREM_AGRESIF", "AGRESIF"] and vulnerability_cat == "HIGH_VULNERABLE":
            log_scores["win"] += 0.85
            log_scores["loss"] -= 0.65
        elif ppda_cat in ["EKSTREM_AGRESIF"] and vulnerability_cat == "RESISTANT":
            # Lawan tenang keluar dari pressing: resiko fatigue / counter
            log_scores["win"] += 0.10
            log_scores["loss"] += 0.35
        elif ppda_cat == "PASIF":
            # Barca pasif bertentangan dengan filosofi Hansi Flick
            log_scores["win"] -= 0.70
            log_scores["loss"] += 0.60

        # 4. Pengaruh Garis Pertahanan Tinggi (High Line) vs Kecepatan Lawan (Key Player Pace)
        # TC-01 & TC-02: Non-linear interaction
        if line_cat == "EKSTREM_TINGGI":
            if pace_cat in ["EXTREME", "HIGH"]:
                if ppda_cat != "EKSTREM_AGRESIF":
                    # Bahaya fatal: High line tanpa pressing ketat memberi ruang umpan lambung
                    log_scores["win"] -= 1.10
                    log_scores["loss"] += 1.30
                else:
                    # High line didukung pressing ekstrem: resiko ditekan
                    log_scores["win"] += 0.20
                    log_scores["loss"] += 0.15
            else:
                # Lawan lambat dihadapkan garis tinggi: dominasi Barca mutlak
                log_scores["win"] += 0.65
                log_scores["loss"] -= 0.50
        elif line_cat == "TINGGI_STANDAR":
            if pace_cat == "EXTREME":
                log_scores["win"] += 0.30
                log_scores["loss"] += 0.10
            else:
                log_scores["win"] += 0.55
                log_scores["loss"] -= 0.30
        elif line_cat == "RENDAH_DALAM":
            # Garis terlalu rendah menghilangkan identitas Flick dan kompresi lapangan
            log_scores["win"] -= 0.40
            log_scores["draw"] += 0.50

        # 5. Pengaruh Tempo vs Kekuatan Bertahan Lawan
        if tempo_cat == "VERTIKAL_CEPAT":
            if opponent.counter_attack_threat > 75:
                # Pertukaran serangan cepat: fluktuatif
                log_scores["win"] += 0.30
                log_scores["loss"] += 0.30
            else:
                log_scores["win"] += 0.50
        elif tempo_cat == "POSSESSION_SABAR":
            if opponent.defensive_strength > 80:
                # Potensi kebuntuan / seri
                log_scores["draw"] += 0.60
                log_scores["win"] -= 0.20

        # 6. Pengaruh Kualitas Agregat Skuad
        quality_diff = (team_aggregates.team_avg_passing + team_aggregates.team_avg_pace) / 2.0 - (opponent.defensive_strength + opponent.attacking_strength) / 2.0
        log_scores["win"] += quality_diff * 0.02
        log_scores["loss"] -= quality_diff * 0.02

        # 7. Normalisasi Softmax untuk menjamin total probabilitas = 1.00
        max_log = max(log_scores.values())
        exp_scores = {k: math.exp(v - max_log) for k, v in log_scores.items()}
        total_exp = sum(exp_scores.values())

        p_win = round(exp_scores["win"] / total_exp, 4)
        p_draw = round(exp_scores["draw"] / total_exp, 4)
        p_loss = round(1.0 - (p_win + p_draw), 4)

        # Pastikan tidak ada nilai negatif karena pembulatan
        p_loss = max(0.01, p_loss)
        sum_p = p_win + p_draw + p_loss
        p_win = round(p_win / sum_p, 2)
        p_draw = round(p_draw / sum_p, 2)
        p_loss = round(1.0 - (p_win + p_draw), 2)

        return Probabilities(win=p_win, draw=p_draw, loss=p_loss)

from typing import List
from ..core.discretizer import Discretizer
from ..schemas.tactical import TacticalParameters, OpponentAttributes, TeamAggregates, AssistantFeedback

class DecisionTreeXAIEngine:
    """
    Explainable AI (XAI) Engine berbasis traversal aturan pohon keputusan (Decision Tree IF-THEN Rules)
    yang diterjemahkan menjadi narasi taktis natural asisten pelatih di Ciutat Esportiva.
    """

    def generate_feedback(
        self,
        tactics: TacticalParameters,
        opponent: OpponentAttributes,
        team_aggregates: TeamAggregates
    ) -> List[AssistantFeedback]:
        feedback_list: List[AssistantFeedback] = []

        ppda_cat = Discretizer.discretize_ppda(tactics.ppda_intensity)
        line_cat = Discretizer.discretize_defensive_line(tactics.defensive_line_height)
        tempo_cat = Discretizer.discretize_tempo(tactics.build_up_tempo)
        pace_cat = Discretizer.discretize_pace(opponent.key_player_pace)
        vuln_cat = Discretizer.discretize_pressing_vulnerability(opponent.pressing_vulnerability)

        # -------------------------------------------------------------
        # ATURAN 1: Gegenpressing vs Pressing Vulnerability Lawan
        # -------------------------------------------------------------
        if ppda_cat in ["EKSTREM_AGRESIF", "AGRESIF"] and vuln_cat == "HIGH_VULNERABLE":
            feedback_list.append(AssistantFeedback(
                type="STRENGTH",
                rule_id="DT_RULE_01",
                text=f"Intensitas Gegenpressing (PPDA {tactics.ppda_intensity:.1f}) sangat efektif menekan lini tengah {opponent.team_name} yang rentan kehilangan bola saat ditekan secara agresif."
            ))
        elif ppda_cat in ["EKSTREM_AGRESIF"] and vuln_cat == "RESISTANT":
            feedback_list.append(AssistantFeedback(
                type="WARNING",
                rule_id="DT_RULE_02",
                text=f"{opponent.team_name} memiliki resistensi tinggi terhadap pressing. Waspadai stamina pemain di 20 menit terakhir akibat komitmen pressing ekstrem yang dapat membuka celah sirkulasi lawan."
            ))
        elif ppda_cat == "PASIF":
            feedback_list.append(AssistantFeedback(
                type="WARNING",
                rule_id="DT_RULE_03",
                text="Pendekatan pressing pasif (PPDA > 11.5) bertolak belakang dengan filosofi Hansi Flick dan memberi keleluasaan bagi gelandang lawan untuk mengatur ritme laga."
            ))

        # -------------------------------------------------------------
        # ATURAN 2: Garis Pertahanan Tinggi (High Line) vs Kecepatan Lawan (TC-01 & TC-02)
        # -------------------------------------------------------------
        if line_cat == "EKSTREM_TINGGI":
            if pace_cat in ["EXTREME", "HIGH"] and ppda_cat not in ["EKSTREM_AGRESIF"]:
                feedback_list.append(AssistantFeedback(
                    type="WARNING",
                    rule_id="DT_RULE_12",
                    text=f"Garis pertahanan level {tactics.defensive_line_height:.1f} memiliki resiko terbuka terhadap kecepatan {opponent.key_player_name} (Pace: {opponent.key_player_pace}). Tanpa pressing ketat di lini depan, lawan leluasa melepas umpan terobosan diagonal."
                ))
            elif pace_cat in ["EXTREME", "HIGH"] and ppda_cat == "EKSTREM_AGRESIF":
                feedback_list.append(AssistantFeedback(
                    type="RECOMMENDATION",
                    rule_id="DT_RULE_13",
                    text=f"Garis tinggi sangat padat dan aktif. Dukungan pressing ekstrem berhasil membatasi sudut operan terobosan ke {opponent.key_player_name}. Pastikan koordinasi jebakan offside tetap sinkron."
                ))
            else:
                feedback_list.append(AssistantFeedback(
                    type="STRENGTH",
                    rule_id="DT_RULE_14",
                    text="Garis pertahanan sangat tinggi sukses memampatkan ruang lapangan (space compression), mengurung pemain lawan sepenuhnya di sepertiga pertahanan mereka."
                ))
        elif line_cat == "RENDAH_DALAM":
            feedback_list.append(AssistantFeedback(
                type="WARNING",
                rule_id="DT_RULE_15",
                text="Garis pertahanan terlalu rendah merusak jarak antar lini Barcelona. Blok rendah memperlebar jarak antara penyerang dan pemain bertahan saat transisi positif."
            ))

        # -------------------------------------------------------------
        # ATURAN 3: Keseimbangan Double Pivot & Sirkulasi Bola
        # -------------------------------------------------------------
        if team_aggregates.pivot_defensive_power >= 78.0 and team_aggregates.team_avg_passing >= 82.0:
            feedback_list.append(AssistantFeedback(
                type="STRENGTH",
                rule_id="DT_RULE_09",
                text="Keberadaan double pivot berkualitas (Pedri & Casadó) sukses mempertahankan stabilitas sirkulasi bola saat transisi negatif dan mengamankan zona 14."
            ))
        elif team_aggregates.pivot_defensive_power < 75.0:
            feedback_list.append(AssistantFeedback(
                type="RECOMMENDATION",
                rule_id="DT_RULE_10",
                text="Kerapatan defensif poros ganda (double pivot) masih kurang optimal. Pertimbangkan memperkuat perlindungan lini tengah untuk mengantisipasi serangan balik cepat."
            ))

        # -------------------------------------------------------------
        # ATURAN 4: Tempo Build-up vs Karakter Blok Lawan (TC-03 & TC-04)
        # -------------------------------------------------------------
        if opponent.defensive_strength >= 80 and tempo_cat == "POSSESSION_SABAR":
            feedback_list.append(AssistantFeedback(
                type="RECOMMENDATION",
                rule_id="DT_RULE_21",
                text=f"{opponent.team_name} menerapkan blok rendah sangat rapat. Disarankan meningkatkan tempo sirkulasi atau memaksimalkan pergerakan 'third-man run' di area half-space guna membongkar pertahanan berlapis."
            ))
        elif tempo_cat == "VERTIKAL_CEPAT" and opponent.counter_attack_threat >= 75:
            feedback_list.append(AssistantFeedback(
                type="RECOMMENDATION",
                rule_id="DT_RULE_22",
                text="Tempo vertikal cepat menghasilkan peluang langsung yang tinggi, namun beresiko memicu jual beli serangan terbuka. Kendalikan ritme laga pada saat sedang memimpin skor."
            ))

        # Batasi feedback agar tepat 3-4 butir paling bernilai tinggi
        return feedback_list[:4]

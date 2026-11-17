"""
MDLP & SADD Discretization Module
Mengimplementasikan diskretisasi berbasis entropi dan interval taktis
sesuai spesifikasi Section 6.2 Master Engineering Plan.
"""

class Discretizer:
    @staticmethod
    def discretize_ppda(val: float) -> str:
        """
        Diskretisasi intensitas Gegenpressing (PPDA):
        - 2.0 <= PPDA < 6.0: EKSTREM_AGRESIF
        - 6.0 <= PPDA < 8.5: AGRESIF
        - 8.5 <= PPDA < 11.5: MODERAT
        - PPDA >= 11.5: PASIF
        """
        if val < 6.0:
            return "EKSTREM_AGRESIF"
        elif val < 8.5:
            return "AGRESIF"
        elif val < 11.5:
            return "MODERAT"
        else:
            return "PASIF"

    @staticmethod
    def discretize_defensive_line(val: float) -> str:
        """
        Diskretisasi ketinggian garis pertahanan (Defensive Line Height):
        - 8.5 <= Line <= 10.0: EKSTREM_TINGGI
        - 6.5 <= Line < 8.5: TINGGI_STANDAR
        - 4.0 <= Line < 6.5: MEDIUM
        - Line < 4.0: RENDAH_DALAM
        """
        if val >= 8.5:
            return "EKSTREM_TINGGI"
        elif val >= 6.5:
            return "TINGGI_STANDAR"
        elif val >= 4.0:
            return "MEDIUM"
        else:
            return "RENDAH_DALAM"

    @staticmethod
    def discretize_tempo(val: float) -> str:
        """
        Diskretisasi tempo build-up:
        - val >= 7.5: VERTIKAL_CEPAT
        - 4.5 <= val < 7.5: FLUIDA_TRANSISI
        - val < 4.5: POSSESSION_SABAR
        """
        if val >= 7.5:
            return "VERTIKAL_CEPAT"
        elif val >= 4.5:
            return "FLUIDA_TRANSISI"
        else:
            return "POSSESSION_SABAR"

    @staticmethod
    def discretize_pace(val: int | float) -> str:
        """
        Diskretisasi kecepatan pemain kunci (Pace):
        - val >= 88: EXTREME
        - 75 <= val < 88: HIGH
        - val < 75: MODERATE
        """
        if val >= 88:
            return "EXTREME"
        elif val >= 75:
            return "HIGH"
        else:
            return "MODERATE"

    @staticmethod
    def discretize_pressing_vulnerability(val: int | float) -> str:
        """
        Diskretisasi kerentanan pressing lawan:
        - val >= 68: HIGH_VULNERABLE
        - 45 <= val < 68: MODERATE
        - val < 45: RESISTANT
        """
        if val >= 68:
            return "HIGH_VULNERABLE"
        elif val >= 45:
            return "MODERATE"
        else:
            return "RESISTANT"

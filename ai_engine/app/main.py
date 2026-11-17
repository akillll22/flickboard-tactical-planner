import time
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from .schemas.tactical import (
    SimulationRequest,
    SimulationResponse,
    OpponentAttributes,
    TeamAggregates,
    TacticalParameters,
)
from .services.naive_bayes_service import NaiveBayesService
from .services.decision_tree_service import DecisionTreeXAIEngine
from .services.projected_stats_service import ProjectedStatsService
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(
    title="Barça Tactical Planner (Flickboard) - AI Inference Service",
    description="Explainable AI & Naive Bayes Microservice for Hansi Flick Tactical Modeling",
    version="1.0.0"
)

# CORS setup for mobile and web communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inisialisasi Service ML (Singleton in memory)
nb_service = NaiveBayesService()
xai_engine = DecisionTreeXAIEngine()
stats_service = ProjectedStatsService()

# Database Master In-Memory
PLAYERS_DATA = [
    {"id": 13, "name": "Iñaki Peña", "shirt_number": 13, "position": "GK", "overall_rating": 82, "pace": 52, "passing": 81, "defending": 82},
    {"id": 25, "name": "Wojciech Szczęsny", "shirt_number": 25, "position": "GK", "overall_rating": 85, "pace": 48, "passing": 82, "defending": 86},
    {"id": 1, "name": "Marc-André ter Stegen", "shirt_number": 1, "position": "GK", "overall_rating": 89, "pace": 50, "passing": 88, "defending": 89},
    {"id": 2, "name": "Pau Cubarsí", "shirt_number": 2, "position": "CB", "overall_rating": 86, "pace": 76, "passing": 89, "defending": 86},
    {"id": 3, "name": "Alejandro Balde", "shirt_number": 3, "position": "LB", "overall_rating": 85, "pace": 94, "passing": 80, "defending": 79},
    {"id": 5, "name": "Íñigo Martínez", "shirt_number": 5, "position": "CB", "overall_rating": 85, "pace": 72, "passing": 84, "defending": 86},
    {"id": 23, "name": "Jules Koundé", "shirt_number": 23, "position": "RB", "overall_rating": 87, "pace": 85, "passing": 81, "defending": 87},
    {"id": 4, "name": "Ronald Araújo", "shirt_number": 4, "position": "CB", "overall_rating": 87, "pace": 83, "passing": 74, "defending": 88},
    {"id": 15, "name": "Andreas Christensen", "shirt_number": 15, "position": "CB", "overall_rating": 84, "pace": 71, "passing": 81, "defending": 85},
    {"id": 24, "name": "Eric García", "shirt_number": 24, "position": "CB", "overall_rating": 81, "pace": 73, "passing": 81, "defending": 80},
    {"id": 32, "name": "Héctor Fort", "shirt_number": 32, "position": "RB", "overall_rating": 78, "pace": 82, "passing": 76, "defending": 76},
    {"id": 35, "name": "Gerard Martín", "shirt_number": 35, "position": "LB", "overall_rating": 77, "pace": 80, "passing": 75, "defending": 76},
    {"id": 8, "name": "Pedri", "shirt_number": 8, "position": "CM", "overall_rating": 90, "pace": 82, "passing": 93, "defending": 78},
    {"id": 17, "name": "Marc Casadó", "shirt_number": 17, "position": "DM", "overall_rating": 85, "pace": 80, "passing": 87, "defending": 85},
    {"id": 20, "name": "Dani Olmo", "shirt_number": 20, "position": "AM", "overall_rating": 88, "pace": 84, "passing": 89, "defending": 64},
    {"id": 6, "name": "Gavi", "shirt_number": 6, "position": "CM", "overall_rating": 86, "pace": 80, "passing": 85, "defending": 83},
    {"id": 21, "name": "Frenkie de Jong", "shirt_number": 21, "position": "CM", "overall_rating": 88, "pace": 82, "passing": 91, "defending": 80},
    {"id": 16, "name": "Fermín López", "shirt_number": 16, "position": "AM", "overall_rating": 84, "pace": 84, "passing": 83, "defending": 70},
    {"id": 28, "name": "Marc Bernal", "shirt_number": 28, "position": "DM", "overall_rating": 80, "pace": 75, "passing": 84, "defending": 81},
    {"id": 14, "name": "Pablo Torre", "shirt_number": 14, "position": "AM", "overall_rating": 79, "pace": 77, "passing": 82, "defending": 56},
    {"id": 11, "name": "Raphinha", "shirt_number": 11, "position": "LW", "overall_rating": 89, "pace": 92, "passing": 87, "defending": 64},
    {"id": 19, "name": "Lamine Yamal", "shirt_number": 19, "position": "RW", "overall_rating": 90, "pace": 93, "passing": 89, "defending": 54},
    {"id": 9, "name": "Robert Lewandowski", "shirt_number": 9, "position": "CF", "overall_rating": 90, "pace": 76, "passing": 82, "defending": 45},
    {"id": 7, "name": "Ferran Torres", "shirt_number": 7, "position": "LW", "overall_rating": 82, "pace": 84, "passing": 79, "defending": 46},
    {"id": 10, "name": "Ansu Fati", "shirt_number": 10, "position": "LW", "overall_rating": 80, "pace": 84, "passing": 78, "defending": 42},
    {"id": 18, "name": "Pau Víctor", "shirt_number": 18, "position": "CF", "overall_rating": 79, "pace": 82, "passing": 76, "defending": 44},
]

MATCHES_DATA = [
    {
        "id": 110,
        "opponent_id": 10,
        "match_date": "2026-11-22T14:00:00Z",
        "venue": "HOME (Spotify Camp Nou)",
        "competition": "La Liga EA Sports (Jornada 13)",
        "context_description": "Laga kandang di Spotify Camp Nou pasca jeda internasional menghadapi ketajaman Ayoze Pérez dan Villarreal.",
        "status": "UPCOMING",
        "opponent": {
            "id": 10,
            "team_name": "Villarreal CF",
            "attacking_strength": 86,
            "defensive_strength": 83,
            "pressing_vulnerability": 56,
            "counter_attack_threat": 90,
            "key_player_name": "Ayoze Pérez",
            "key_player_pace": 87,
            "scouting_notes": "Villarreal berbahaya melalui serangan balik cepat dan efektivitas finishing Ayoze Pérez. Menjaga kerapatan garis tengah Casadó-Pedri kunci memutus suplai bola."
        }
    },
    {
        "id": 111,
        "opponent_id": 11,
        "match_date": "2026-11-25T18:45:00Z",
        "venue": "AWAY (Baku Olympic Stadium)",
        "competition": "UEFA Champions League (Matchday 5)",
        "context_description": "Laga tandang Eropa fase liga ke Baku menghadapi Sabah FK untuk mengamankan tiket 8 besar.",
        "status": "UPCOMING",
        "opponent": {
            "id": 11,
            "team_name": "Sabah FK",
            "attacking_strength": 76,
            "defensive_strength": 78,
            "pressing_vulnerability": 68,
            "counter_attack_threat": 79,
            "key_player_name": "Joy-Lance Mickels",
            "key_player_pace": 85,
            "scouting_notes": "Laga tandang Liga Champions di Baku. Lawan cenderung menumpuk pemain di kotak penalti. Dibutuhkan sirkulasi cepat dan tusukan Lamine Yamal dari sayap."
        }
    },
    {
        "id": 112,
        "opponent_id": 12,
        "match_date": "2026-11-29T16:15:00Z",
        "venue": "AWAY (ABANCA-Riazor)",
        "competition": "La Liga EA Sports (Jornada 14)",
        "context_description": "Duel sengit di Galicia menghadapi Deportivo de La Coruña yang mengandalkan determinasi tinggi di kandang.",
        "status": "UPCOMING",
        "opponent": {
            "id": 12,
            "team_name": "Deportivo La Coruña",
            "attacking_strength": 80,
            "defensive_strength": 81,
            "pressing_vulnerability": 62,
            "counter_attack_threat": 84,
            "key_player_name": "Lucas Pérez",
            "key_player_pace": 82,
            "scouting_notes": "Duel klasik di Riazor. Pertahanan Deportivo disiplin namun rentan saat Gegenpress agresif (PPDA < 6.0) diterapkan di sepertiga akhir."
        }
    },
    {
        "id": 101,
        "opponent_id": 1,
        "match_date": "2026-12-05T21:00:00Z",
        "venue": "AWAY (Santiago Bernabéu)",
        "competition": "La Liga EA Sports (El Clásico)",
        "context_description": "Duel El Clásico penentu puncak klasemen di Santiago Bernabéu menghadapi Kylian Mbappé dan Vinícius Jr.",
        "status": "UPCOMING",
        "opponent": {
            "id": 1,
            "team_name": "Real Madrid",
            "attacking_strength": 93,
            "defensive_strength": 87,
            "pressing_vulnerability": 40,
            "counter_attack_threat": 96,
            "key_player_name": "Kylian Mbappé",
            "key_player_pace": 97,
            "scouting_notes": "Sangat mematikan dalam transisi balik vertikal via Kylian Mbappé & Vinícius Jr. Jebakan offside lini tinggi Barca harus terkoordinasi milidetik dengan intensitas Gegenpress Casadó & Pedri."
        }
    },
    {
        "id": 104,
        "opponent_id": 4,
        "match_date": "2026-12-12T20:00:00Z",
        "venue": "HOME (Spotify Camp Nou)",
        "competition": "La Liga EA Sports (Super Big Match)",
        "context_description": "Menjamu Atlético Madrid asuhan Diego Simeone di Spotify Camp Nou setelah kemenangan 2-1 di Metropolitano.",
        "status": "UPCOMING",
        "opponent": {
            "id": 4,
            "team_name": "Atlético Madrid",
            "attacking_strength": 87,
            "defensive_strength": 91,
            "pressing_vulnerability": 36,
            "counter_attack_threat": 90,
            "key_player_name": "Julián Álvarez",
            "key_player_pace": 89,
            "scouting_notes": "Formasi pertahanan kompak Diego Simeone. Barca baru saja mengalahkan mereka 2-1 via brace Fermín López."
        }
    }
]

@app.get("/health", tags=["System"])
def health_check():
    return {
        "status": "online",
        "service": "barca-ai-engine",
        "engine_version": "1.0.0",
        "tactical_model": "Hansi Flick Fluid 4-2-3-1 / 3-2-4-1"
    }

@app.get("/api/v1/players/barca", tags=["Master Data"])
def get_barca_players():
    return {
        "status": "success",
        "data": PLAYERS_DATA
    }

@app.get("/api/v1/matches/upcoming", tags=["Master Data"])
def get_upcoming_matches():
    return {
        "status": "success",
        "data": MATCHES_DATA
    }

class RunSimulationPayload(BaseModel):
    match_id: int
    formation_used: str = "4-2-3-1"
    starting_xi: List[int]
    tactical_parameters: TacticalParameters

@app.post("/api/v1/simulations/run", response_model=SimulationResponse, tags=["Tactical Simulation"])
def run_simulation_api(payload: RunSimulationPayload):
    # Cari lawan berdasarkan match_id
    match_found = next((m for m in MATCHES_DATA if m["id"] == payload.match_id), MATCHES_DATA[0])
    opp_dict = match_found["opponent"]
    opponent = OpponentAttributes(
        id=opp_dict["id"],
        team_name=opp_dict["team_name"],
        attacking_strength=opp_dict["attacking_strength"],
        defensive_strength=opp_dict["defensive_strength"],
        pressing_vulnerability=opp_dict["pressing_vulnerability"],
        counter_attack_threat=opp_dict["counter_attack_threat"],
        key_player_name=opp_dict["key_player_name"],
        key_player_pace=opp_dict["key_player_pace"],
    )

    # Hitung team aggregates dari starting_xi
    selected_players = [p for p in PLAYERS_DATA if p["id"] in payload.starting_xi]
    if not selected_players:
        selected_players = PLAYERS_DATA[:11]

    team_aggregates = TeamAggregates(
        team_avg_pace=round(sum(p["pace"] for p in selected_players) / len(selected_players), 1),
        team_avg_passing=round(sum(p["passing"] for p in selected_players) / len(selected_players), 1),
        team_avg_defending=round(sum(p["defending"] for p in selected_players) / len(selected_players), 1),
        defense_avg_pace=round(sum(p["pace"] for p in selected_players if p["position"] in ["CB", "LB", "RB"]) / max(1, len([p for p in selected_players if p["position"] in ["CB", "LB", "RB"]])), 1),
        pivot_defensive_power=round(sum(p["defending"] for p in selected_players if p["position"] in ["DM", "CM"]) / max(1, len([p for p in selected_players if p["position"] in ["DM", "CM"]])), 1),
    )

    probabilities = nb_service.compute_probabilities(
        tactics=payload.tactical_parameters,
        opponent=opponent,
        team_aggregates=team_aggregates
    )

    projected_stats, tactical_grade = stats_service.calculate_stats(
        tactics=payload.tactical_parameters,
        opponent=opponent,
        team_aggregates=team_aggregates,
        win_prob=probabilities.win,
        loss_prob=probabilities.loss
    )

    feedback_items = xai_engine.generate_feedback(
        tactics=payload.tactical_parameters,
        opponent=opponent,
        team_aggregates=team_aggregates
    )

    return SimulationResponse(
        status="success (live_ai_engine)",
        match_id=payload.match_id,
        probabilities=probabilities,
        tactical_grade=tactical_grade,
        projected_stats=projected_stats,
        assistant_feedback=feedback_items,
        simulation_id=None
    )

@app.post("/api/v1/predict", response_model=SimulationResponse, tags=["Tactical Simulation"])
def run_tactical_simulation(payload: SimulationRequest):
    """
    Eksekusi inferensi simulasi taktis:
    1. Menghitung probabilitas posterior (Menang, Seri, Kalah) via Naive Bayes MAP.
    2. Menghasilkan proyeksi statistik laga (Penguasaan Bola, xG Barca, xG Lawan, Jebakan Offside).
    3. Mengekstraksi lintasan aturan Decision Tree menjadi umpan balik natural Explainable AI (XAI).
    """
    start_time = time.time()

    # Siapkan fallback atribut jika tidak disertakan dalam payload
    opponent = payload.opponent or OpponentAttributes()
    team_aggregates = payload.team_aggregates or TeamAggregates()

    # 1. Probabilitas Hasil Laga via Naive Bayes MAP Rule
    probabilities = nb_service.compute_probabilities(
        tactics=payload.tactical_parameters,
        opponent=opponent,
        team_aggregates=team_aggregates
    )

    # 2. Statistik Proyeksi & Grade Taktis
    projected_stats, tactical_grade = stats_service.calculate_stats(
        tactics=payload.tactical_parameters,
        opponent=opponent,
        team_aggregates=team_aggregates,
        win_prob=probabilities.win,
        loss_prob=probabilities.loss
    )

    # 3. Umpan Balik Taktis Alami via Traversal Pohon Keputusan (XAI)
    feedback_items = xai_engine.generate_feedback(
        tactics=payload.tactical_parameters,
        opponent=opponent,
        team_aggregates=team_aggregates
    )

    execution_time_ms = round((time.time() - start_time) * 1000, 2)

    return SimulationResponse(
        status="success",
        match_id=payload.match_id,
        probabilities=probabilities,
        tactical_grade=tactical_grade,
        projected_stats=projected_stats,
        assistant_feedback=feedback_items,
        simulation_id=None
    )

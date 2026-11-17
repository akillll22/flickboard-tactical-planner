# DOKUMEN RENCANA PENGEMBANGAN SISTEM (MASTER ENGINEERING PLAN)
# BARÇA TACTICAL PLANNER (FLICKBOARD)
### *Aplikasi Asisten Pelatih Virtual Berbasis Mobile dengan Integrasi Sports Analytics & Explainable AI (XAI)*

---

| **Atribut Dokumen** | **Keterangan** |
| :--- | :--- |
| **Judul Proyek** | Barça Tactical Planner (Flickboard) |
| **Kode Dokumen** | BTP-MEP-2026-V1.0 |
| **Versi Dokumen** | 1.0 (Comprehensive Release) |
| **Tanggal Terbit** | Oktober 2026 |
| **Status Dokumen** | Approved Master Engineering Specification |
| **Platform Target** | Mobile (iOS & Android via Flutter) |
| **Arsitektur Sistem** | 3-Tier Distributed Microservices (Flutter + Laravel + FastAPI) |
| **Basis Dokumen** | Sintesis Blueprint Aplikasi & Analisis Jurnal Taktik Sepak Bola |

---

## 1. PENDAHULUAN & SINTESIS ANALISIS DOKUMEN

### 1.1 Latar Belakang & Visi Produk
Revolusi industri sepak bola modern telah mengubah peran intuisi subjektif pelatih menjadi pendekatan analitik berbasis data ilmiah (*data-driven tactical management*). Di bawah kepemimpinan pelatih kepala Hansi Flick pada musim 2024/2025, FC Barcelona mengalami transformasi struktural yang signifikan: perpaduan antara filosofi tradisional penguasaan bola (*Juego de Posición*) dengan intensitas vertikal Jerman (*Gegenpressing*, jebakan *offside* agresif melalui garis pertahanan sangat tinggi, dan sirkulasi bola cepat).

Aplikasi **Barça Tactical Planner (Flickboard)** dirancang sebagai **Digital Assistant Coach (Asisten Pelatih Virtual)** berbasis mobile yang memungkinkan pengguna—baik analis tim, staf kepelatihan, maupun pengguna umum pecinta taktik—berperan sebagai staf analis taktik di *Ciutat Esportiva Joan Gamper*. Aplikasi ini memfasilitasi pengguna untuk:
1. Meneliti kekuatan dan kerentanan taktis lawan (*Opponent Scouting*).
2. Merumuskan susunan pemain (*Starting XI*) secara interaktif (*drag & drop*).
3. Mengatur variabel instruksi taktik khas Hansi Flick (intensitas *Gegenpressing*/PPDA, ketinggian garis pertahanan *High Line*, dan tempo *build-up*).
4. Menjalankan simulasi pertandingan (*Match Simulation Engine*) yang didukung oleh pemodelan matematis berbasis data spasio-temporal dan algoritma *Machine Learning*.
5. Memperoleh laporan evaluasi komprehensif (*Post-Match Tactical Report*) dengan penjelasan taktis transparan yang dapat dipertanggungjawabkan (*Explainable AI*), bukan sekadar tebakan skor acak (*score guessing*).

### 1.2 Sintesis Hasil Analisis Kedua Dokumen Masukan
Pengembangan sistem ini mengintegrasikan dua pilar dokumen acuan utama secara komplementer:

| Aspek Analisis | Masukan Dokumen 1: *Blueprint Aplikasi (Flickboard.pdf)* | Masukan Dokumen 2: *Analisis Jurnal Taktik Sepak Bola (.docx)* | Sintesis & Penerapan pada Rencana Pengembangan |
| :--- | :--- | :--- | :--- |
| **Fokus & Domain** | Rancang bangun fungsional, antarmuka pengguna (UI/UX), arsitektur komponen aplikasi, dan skema database dasar. | Tinjauan teoretis sains olahraga, metrik pelacakan spasio-temporal (SPADL, CPBD, NPBD), dan formulasi matematis AI. | Menggabungkan keunggulan interaktivitas antarmuka visual mobile dengan kedalaman komputasi ilmiah sports analytics. |
| **Paradigma Taktik Hansi Flick** | Konsep dasar: formasi 4-2-3-1, slider *Gegenpressing* (PPDA), *Defensive Line Height*, dan *Build-up Tempo*. | Transisi formasi fluida (4-2-3-1 ke 3-2-4-1 fase *in-possession*), aturan 6 detik, metrik PPDA < 8.0, OPPDA, serta evolusi reduksi jebakan offside sebesar 65% karena eksploitasi *third-man runs*. | Menambahkan logika transisi dinamis formasi dan dinamika non-linear antara kecepatan lawan (*pace*) vs garis pertahanan tinggi pada model prediksi. |
| **Mesin Simulasi & AI** | Disebutkan menggunakan pendekatan *Decision Tree* / Sistem Berbasis Aturan (Laravel + Python API). | Formulasi formal *Decision Tree* (Entropy & Information Gain C4.5/CART) untuk XAI, serta integrasi *Naive Bayes (MAP Rule)* dan diskretisasi MDLP/SADD. | Mengembangkan arsitektur AI hibrida: Naive Bayes untuk inferensi probabilitas posterior instan (Win/Draw/Loss), dan Decision Tree untuk ekstraksi aturan logika IF-THEN deterministik ke dalam narasi asisten pelatih. |
| **Arsitektur Teknis** | Frontend: Flutter; Backend: Laravel REST API & Data Broker; Engine: Python/FastAPI terpisah. | Microservices 3-lapisan, optimasi latensi protokol HTTP RESTful, skema DDL relasional, dan kebutuhan *continuous learning pipeline*. | Meresmikan topologi 3-Tier Microservices: Klien Flutter (BLoC/Clean Architecture) <-> Laravel Data Broker API Gateway <-> Python FastAPI ML Inference Engine. |
| **Manajemen Resiko & Data** | Penyimpanan riwayat simulasi (*simulations table*) untuk dimuat ulang tanpa kalkulasi ulang. | Identifikasi *class imbalance* (tingginya rasio kemenangan Barca era Flick), bahaya *overfitting* pohon keputusan, dan kebutuhan *tree pruning*. | Menerapkan *caching* cerdas di level database, teknik penyeimbangan kelas (SMOTE/Class Weights), regularisasi pohon keputusan (*max_depth*, *min_samples_leaf*), dan pipeline retraining berkala. |

### 1.3 Tujuan Pengembangan Aplikasi
1. **Mengembangkan Antarmuka Mobile Interaktif**: Menyediakan papan taktik digital (*Tactical Board*) yang responsif dengan dukungan *drag & drop* formasi, manipulasi parameter gaya bermain, dan visualisasi grafik performa (Radar Chart & Donut Chart).
2. **Membangun Mesin Simulasi yang Transparan (Explainable AI)**: Menyediakan mekanisme simulasi yang mampu membedah kausalitas keputusan taktis menjadi saran natural bahasa manusia, menghilangkan efek "kotak hitam" (*black box*) dalam machine learning olahraga.
3. **Menyediakan Performa Tinggi dan Latensi Rendah**: Memastikan inferensi simulasi berlangsung di bawah 500 milidetik dengan arsitektur backend asinkron, didukung *caching* riwayat eksperimen.
4. **Menciptakan Pengalaman Pengguna yang Imersif**: Menghadirkan alur peran (*role-play*) sebagai analis taktik resmi di *Ciutat Esportiva*, meningkatkan keterlibatan emosional pengguna melalui visual bertema modern Blaugrana.

---

## 2. DEKONSTRUKSI PARADIGMA TAKTIK HANSI FLICK KE PARAMETER SISTEM

Untuk membangun sistem simulasi yang memiliki validitas analitik tinggi, filosofi taktis Hansi Flick didekonstruksi ke dalam variabel komputasi berikut:

```
[Filosofi Taktis Hansi Flick]
       │
       ├──► 1. Struktur Formasi Fluida (Nominal: 4-2-3-1 ──► Fase Build-Up: 3-2-4-1)
       │       └── Variabel: formation_used, player_roles, central_density, width_stretch
       │
       ├──► 2. Counter-Pressing / Gegenpressing (Aturan 6 Detik & PPDA Agresif)
       │       └── Variabel: ppda_intensity (Target: 2.0 - 8.0), recovery_time_window, OPPDA
       │
       ├──► 3. Garis Pertahanan Ekstrem (High Defensive Line & Adaptive Offside Trap)
       │       └── Variabel: defensive_line_height (1 - 10), offside_trap_risk, opponent_pace_gap
       │
       └──► 4. Transisi Vertikal & Build-up Cepat
               └── Variabel: tempo_value (Vertical/Direct vs Controlled Possession), passing_speed
```

### 2.1 Struktur Formasi Fluida (4-2-3-1 ke 3-2-4-1)
- **Fase Bertahan/Statis (4-2-3-1)**: Mengandalkan dua gelandang bertahan (*double pivot*, misal Marc Casadó/Pedri/Frenkie de Jong) untuk melindungi ruang transisi dan memberikan kestabilan sentral.
- **Fase Penguasaan Bola/Build-Up (3-2-4-1)**: Salah satu bek sayap maju ke lini tengah atau inverted, gelandang serang dan pemain sayap (Lamine Yamal, Raphinha) melebar ekstrem untuk meregangkan pertahanan musuh, sementara Robert Lewandowski menempati titik fokal sentral.
- **Representasi Sistem**: Sistem mencatat slot posisi pemain dan mengevaluasi kecocokan atribut individu (misal: *passing*, *pace*, *defending*) terhadap peran spesifik di lapangan.

### 2.2 Metrik Tekanan Pertahanan: Gegenpressing dan Analisis PPDA
- **Definisi PPDA (*Passes Per Defensive Action*)**:
  $$\text{PPDA} = \frac{\text{Jumlah Operan Lawan di 60\% Area Pertahanan Sendiri}}{\text{Jumlah Aksi Defensif (Tackle, Intersepsi, Pelanggaran, Challenge)}}$$
- **Aturan Enam Detik**: Perebutan bola seketika dalam kurun waktu 6 detik pasca kehilangan bola di sepertiga akhir lawan.
- **Signifikansi Komputasi**: Nilai PPDA rendah (< 8.0) menandakan pressing sangat agresif. Jika lawan memiliki kerentanan tinggi terhadap pressing (*pressing_vulnerability* tinggi), probabilitas *turnover* positif meningkat drastis.

### 2.3 Garis Pertahanan Tinggi & Jebakan Offside Non-Linear
- **Karakteristik**: Menempatkan garis pertahanan pada ketinggian ekstrem (rata-rata 50–55 meter dari gawang sendiri) untuk memampatkan ruang vertikal (*space compression*).
- **Evolusi Taktis Adaptif**: Awal musim menghasilkan 6–7 jebakan offside per laga. Ketika musuh mulai mengeksploitasi dengan *diagonal long balls* dan *third-man runs*, intensitas jebakan offside diturunkan 65% (menjadi ~2.2 kali per laga), namun garis pertahanan tinggi tetap dipertahankan demi menjaga keutuhan struktur Gegenpressing.
- **Interaksi Non-Linear pada AI**: Jika pengguna memilih `defensive_line_height` ekstrem tinggi (skor 9–10) menghadapi lawan dengan atribut `counter_attack_threat` dan penyerang sayap `pace` tinggi (> 88, misal Mbappé atau Vinícius Jr.), sistem mengevaluasi risiko kebobolan melalui pohon keputusan.

### 2.4 Matriks Parameter Pemain dan Lawan
1. **Fitur Tim Lawan (`opponents`)**:
   - `attacking_strength` (1–100): Daya gedor ofensif lawan.
   - `defensive_strength` (1–100): Kerapatan pertahanan lawan.
   - `pressing_vulnerability` (1–100): Tingkat kecenderungan lawan kehilangan bola saat ditekan.
   - `counter_attack_threat` (1–100): Kecepatan dan efektivitas serangan balik cepat.
   - `key_player_pace` (1–100): Kecepatan tertinggi pemain kunci lawan.
2. **Fitur Pemain Barcelona (`barca_players`)**:
   - `overall_rating` (1–100), `pace` (1–100), `passing` (1–100), `defending` (1–100).
   - Agregasi Starting XI menghasilkan nilai agregat: `team_avg_pace`, `team_avg_passing`, `defense_avg_pace`, `pivot_defensive_power`.

---

## 3. SPESIFIKASI KEBUTUHAN PERANGKAT LUNAK (SRS)

### 3.1 Kebutuhan Fungsional (Functional Requirements)

| Kode Kebutuhan | Nama Fitur / Modul | Deskripsi Alur & Spesifikasi Teknis | Kriteria Keberhasilan (Acceptance Criteria) |
| :--- | :--- | :--- | :--- |
| **FR-01** | Autentikasi & Onboarding Analis | Sistem menyediakan registrasi dan login analis menggunakan Laravel Sanctum/JWT. Pengguna baru disambut dengan antarmuka tematik sebagai *Analis Taktik Baru di Ciutat Esportiva*. | Token sesi terbit valid; pengguna tersimpan di tabel `users`; orientasi onboarding selesai dalam < 3 layar. |
| **FR-02** | Match Dashboard | Menampilkan kartu pertandingan berikutnya (*Next Match Card*, misal vs Real Madrid / Bayern Munchen), jadwal laga, venue, ringkasan kondisi kebugaran skuad, dan tombol akses cepat ke ruang analisis. | Data pertandingan diambil dari endpoint `/api/v1/matches/upcoming`; visualisasi kartu responsif dan dinamis. |
| **FR-03** | Opponent Scouting Room | Menampilkan analisis profil tim lawan: Radar Chart 5-poros (*Attacking*, *Defending*, *Counter Threat*, *Pressing Vulnerability*, *Pace Threat*), kartu profil pemain kunci, serta catatan kelemahan taktis lawan. | Render Radar Chart menggunakan pustaka Flutter fl_chart; data metrik lawan dimuat akurat dari tabel `opponents`. |
| **FR-04** | Interactive Tactical Board (Drag & Drop) | Lapangan hijau virtual dengan slot posisi sesuai formasi (default 4-2-3-1 dengan opsi transisi 3-2-4-1). Pengguna dapat menarik (*drag*) pemain dari daftar bench/cadangan ke dalam posisi starter 11 pemain. | Mendukung mekanisme *drag-and-drop* lancar; validasi minimal & maksimal tepat 11 pemain; visualisasi foto & rating pemain. |
| **FR-05** | Tactical Instructions Panel | Panel kontrol berisi 3 slider taktis Hansi Flick: <br>1. *Gegenpressing Intensity* (Target PPDA: 2.0 s/d 15.0). <br>2. *Defensive Line Height* (Level 1 s/d 10: Rendah hingga Ekstrem Tinggi). <br>3. *Build-up Tempo* (Nilai 1 s/d 10: Penguasaan Sabar s/d Vertikal Cepat). | Perubahan nilai slider mengubah label semantik secara seketika (*real-time reactive*); nilai tersimpan pada state controller. |
| **FR-06** | Match Simulation Engine & UX Loader | Pengguna menekan tombol "Simulasikan Pertandingan". Sistem menampilkan overlay animasi loading modern yang memberikan impresi sistem sedang "memproses jutaan titik data spasio-temporal dan matriks taktis". | Animasi berjalan minimal 1.5 detik demi aspek psikologis pengguna; request dikirim ke backend secara asinkron. |
| **FR-07** | Post-Match Tactical Report | Menampilkan dashboard hasil simulasi akhir: <br>1. Donut Chart persentase probabilitas hasil (Menang, Seri, Kalah). <br>2. Radar Chart / Badge Nilai Taktik (Grade S, A, B, C, D). <br>3. Metrik prediksi penguasaan bola (*possession*) & estimasi xG. | Donut chart menampilkan total 100% probabilitas; Grade taktis terkalkulasi proporsional; grafik interaktif. |
| **FR-08** | Explainable AI Feedback Engine | Menampilkan 3-5 butir umpan balik deskriptif dari "Asisten Pelatih Virtual". Dihasilkan melalui traversal pohon keputusan (*Decision Tree Rules*) yang diterjemahkan ke dalam bahasa narasi taktis profesional. | Menampilkan alasan logis di balik angka probabilitas; menyebutkan nama pemain kunci lawan atau konsekuensi instruksi slider. |
| **FR-09** | Simulation History & Caching | Menyimpan seluruh konfigurasi taktik dan payload hasil simulasi ke dalam tabel `simulations`. Pengguna dapat membuka kembali riwayat eksperimen tanpa perlu melakukan komputasi ulang. | Konfigurasi yang identik dapat memanfaatkan caching; pengguna dapat menghapus atau membandingkan 2 riwayat simulasi. |

### 3.2 Kebutuhan Non-Fungsional (Non-Functional Requirements)

1. **Performa & Latensi (NFR-01)**:
   - Waktu respons API backend (Laravel ke FastAPI hingga kembali ke Flutter) tidak boleh melebihi **500 milidetik** pada beban kerja standar.
   - Antarmuka pengguna Flutter harus berjalan stabil pada frame rate **60 FPS** tanpa *jank* saat melakukan operasi drag-and-drop.
2. **Skalabilitas & Modularitas (NFR-02)**:
   - Arsitektur berbasis layanan mikro memungkinkan modul inferensi Python FastAPI di-deploy secara kontainerisasi (Docker) dan diskalakan secara independen (*horizontal scaling*).
3. **Keamanan Sistem (NFR-03)**:
   - Komunikasi data wajib menggunakan protokol terenkripsi HTTPS/TLS.
   - Autentikasi API menggunakan bearer token (Laravel Sanctum). Seluruh payload JSON divalidasi dengan skema ketat (*input sanitization*).
4. **Estetika & Pengalaman Visual (NFR-04)**:
   - Mengusung tema visual modern premium: *Blaugrana Dark Theme* (Dark Navy `#0A0E17`, Deep Blue `#004D98`, Garnet `#A50044`, Gold Accent `#EDBB00`), Glassmorphism cards, dan tipografi modern (Google Fonts Inter / Outfit).
5. **Kompatibilitas Platform (NFR-05)**:
   - Mendukung sistem operasi Android minimal versi 8.0 (API Level 26) dan iOS versi 14.0 ke atas dengan desain tata letak responsif untuk berbagai resolusi layar ponsel pintar.

---

## 4. ARSITEKTUR SISTEM & TOPOLOGI TEKNIS (SYSTEM ARCHITECTURE)

Sistem dibangun menggunakan pendekatan **3-Tier Distributed Microservices** untuk memisahkan secara tegas antara lapisan presentasi visual, lapisan tata kelola data relasional, dan lapisan komputasi analitik cerdas.

```
┌─────────────────────────────────────────────────────────────┐
│                 LAPISAN 1: CLIENT FRONTEND                  │
│                     (Flutter Mobile App)                    │
│  - Match Dashboard       - Tactical Board (Drag & Drop)     │
│  - Opponent Scouting     - Tactical Sliders (PPDA, Line)    │
│  - State Management: BLoC / Cubit                           │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTPS / JSON REST API
                               ▼
┌─────────────────────────────────────────────────────────────┐
│             LAPISAN 2: DATA BROKER & API GATEWAY            │
│                       (Laravel 11 PHP)                      │
│  - Authentication (Sanctum)  - Master Data Management       │
│  - Payload Validation & Auth - History & Result Caching     │
│  - Relational Database: MySQL 8.0                           │
└──────────────────────────────┬──────────────────────────────┘
                               │ Internal HTTP REST (FastAPI)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│             LAPISAN 3: MESIN INFERENSI CERDAS (AI)          │
│                (Python FastAPI + Scikit-Learn)              │
│  - MDLP / SADD Discretization Engine                        │
│  - Naive Bayes Classifier (Probabilitas Hasil Cepat)        │
│  - Decision Tree Rules Extractor (Explainable AI Engine)    │
└─────────────────────────────────────────────────────────────┘
```

### 4.1 Rincian Tanggung Jawab Komponen
1. **Frontend (Flutter)**:
   - Mengelola tata letak UI, menangkap interaksi gestur *drag & drop*, dan mengikat data (*reactive binding*).
   - Memformat parameter pengguna ke dalam struktur data JSON untuk dikirim ke endpoint Laravel.
2. **Backend API & Data Broker (Laravel 11 + MySQL)**:
   - Berperan sebagai pintu gerbang utama (*API Gateway*) dan *Data Broker*.
   - Melakukan otentikasi pengguna, mengambil metadata profil pemain Barcelona dan data tim musuh dari basis data MySQL.
   - Menggabungkan data taktik input pengguna dengan data atribut pemain/lawan, lalu memicu panggilan asinkron ke server Python.
   - Menyimpan seluruh payload hasil simulasi ke dalam tabel `simulations` sebagai mekanisme riwayat dan *caching*.
3. **ML Inference Engine (Python FastAPI)**:
   - Menjalankan model terlatih *Naive Bayes* dan *Decision Tree*.
   - Melakukan diskretisasi nilai kontinu menggunakan *Minimum Description Length Principle* (MDLP).
   - Mengekstraksi lintasan cabang pohon keputusan aktif menjadi array teks aturan taktis (*Explainable AI*).

### 4.2 Spesifikasi Payload Komunikasi Data (JSON Schema)

#### Payload Permintaan: Flutter ➔ Laravel ➔ FastAPI (`POST /api/v1/simulations/run`)
```json
{
  "user_id": 1,
  "match_id": 102,
  "opponent_id": 5,
  "formation_used": "4-2-3-1",
  "starting_xi": [1, 23, 2, 5, 3, 8, 17, 19, 11, 20, 9],
  "tactical_parameters": {
    "ppda_intensity": 6.2,
    "defensive_line_height": 8.5,
    "build_up_tempo": 7.0
  }
}
```

#### Payload Tanggapan: FastAPI ➔ Laravel ➔ Flutter (`200 OK`)
```json
{
  "status": "success",
  "match_id": 102,
  "probabilities": {
    "win": 0.68,
    "draw": 0.19,
    "loss": 0.13
  },
  "tactical_grade": "A+",
  "projected_stats": {
    "possession_pct": 64.5,
    "expected_goals_barca": 2.45,
    "expected_goals_opponent": 0.85,
    "offside_traps_projected": 3.8
  },
  "assistant_feedback": [
    {
      "type": "STRENGTH",
      "rule_id": "DT_RULE_04",
      "text": "Intensitas Gegenpressing (PPDA 6.2) sangat efektif menekan lini tengah lawan yang memiliki kelemahan pressing tinggi."
    },
    {
      "type": "WARNING",
      "rule_id": "DT_RULE_12",
      "text": "Garis pertahanan level 8.5 memiliki resiko terbuka terhadap kecepatan Kylian Mbappé. Pastikan Pau Cubarsí siap mengantisipasi umpan terobosan diagonal."
    },
    {
      "type": "RECOMMENDATION",
      "rule_id": "DT_RULE_09",
      "text": "Kehadiran Pedri dan Marc Casadó sebagai double pivot sukses mempertahankan stabilitas sirkulasi bola saat transisi negatif."
    }
  ],
  "simulation_id": 4821
}
```

---

## 5. PERANCANGAN BASIS DATA RELASIONAL (DATABASE DESIGN)

### 5.1 Skema Tabel Relasional MySQL

```
┌─────────────────┐       ┌─────────────────┐       ┌────────────────────────┐
│      users      │       │     matches     │       │       opponents        │
├─────────────────┤       ├─────────────────┤       ├────────────────────────┤
│ id (PK)         │◄──┐   │ id (PK)         │◄──┐   │ id (PK)                │
│ name            │   │   │ opponent_id(FK) ├───┼──►│ team_name              │
│ email           │   │   │ match_date      │   │   │ logo_url               │
│ password        │   │   │ venue           │   │   │ attacking_strength     │
│ role            │   │   │ context_desc    │   │   │ defensive_strength     │
│ created_at      │   │   │ status          │   │   │ pressing_vulnerability │
└─────────────────┘   │   └─────────────────┘   │   │ counter_attack_threat  │
                      │                         │   │ key_player_name        │
                      │   ┌─────────────────┐   │   │ key_player_pace        │
                      │   │  barca_players  │   │   └────────────────────────┘
                      │   ├─────────────────┤   │
                      │   │ id (PK)         │   │
                      │   │ name            │   │
                      │   │ position        │   │
                      │   │ overall_rating  │   │
                      │   │ pace, passing   │   │
                      │   │ defending       │   │
                      │   │ photo_url       │   │
                      │   └─────────────────┘   │
                      │                         │
                      │   ┌─────────────────────┴────────────┐
                      │   │           simulations            │
                      │   ├──────────────────────────────────┤
                      └───┤ user_id (FK)                     │
                          │ match_id (FK)                    │
                          │ formation_used                   │
                          │ starting_xi_json                 │
                          │ ppda_intensity                   │
                          │ defensive_line_height            │
                          │ tempo_value                      │
                          │ win_probability                  │
                          │ draw_probability                 │
                          │ loss_probability                 │
                          │ tactical_grade                   │
                          │ simulation_result_json (Cache)   │
                          │ created_at                       │
                          └──────────────────────────────────┘
```

### 5.2 Kamus Data & DDL SQL Terperinci

```sql
-- 1. Tabel users
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'tactical_analyst',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Tabel opponents
CREATE TABLE opponents (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(150) NOT NULL,
    logo_url VARCHAR(255) NULL,
    attacking_strength INT NOT NULL CHECK (attacking_strength BETWEEN 1 AND 100),
    defensive_strength INT NOT NULL CHECK (defensive_strength BETWEEN 1 AND 100),
    pressing_vulnerability INT NOT NULL CHECK (pressing_vulnerability BETWEEN 1 AND 100),
    counter_attack_threat INT NOT NULL CHECK (counter_attack_threat BETWEEN 1 AND 100),
    key_player_name VARCHAR(150) NOT NULL,
    key_player_pace INT NOT NULL CHECK (key_player_pace BETWEEN 1 AND 100),
    scouting_notes TEXT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Tabel barca_players
CREATE TABLE barca_players (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    shirt_number INT NOT NULL,
    position VARCHAR(10) NOT NULL, -- GK, CB, LB, RB, DM, CM, AM, RW, LW, CF
    overall_rating INT NOT NULL CHECK (overall_rating BETWEEN 1 AND 100),
    pace INT NOT NULL CHECK (pace BETWEEN 1 AND 100),
    passing INT NOT NULL CHECK (passing BETWEEN 1 AND 100),
    defending INT NOT NULL CHECK (defending BETWEEN 1 AND 100),
    photo_url VARCHAR(255) NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Tabel matches
CREATE TABLE matches (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    opponent_id BIGINT UNSIGNED NOT NULL,
    match_date DATETIME NOT NULL,
    venue ENUM('HOME', 'AWAY', 'NEUTRAL') DEFAULT 'HOME',
    competition VARCHAR(100) DEFAULT 'La Liga EA Sports',
    context_description TEXT NOT NULL,
    status ENUM('UPCOMING', 'SIMULATED', 'ARCHIVED') DEFAULT 'UPCOMING',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (opponent_id) REFERENCES opponents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Tabel simulations (Hasil Eksperimen & Cache)
CREATE TABLE simulations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    match_id BIGINT UNSIGNED NOT NULL,
    formation_used VARCHAR(20) NOT NULL DEFAULT '4-2-3-1',
    starting_xi_json JSON NOT NULL,
    ppda_intensity DECIMAL(4, 2) NOT NULL,
    defensive_line_height DECIMAL(3, 1) NOT NULL,
    tempo_value DECIMAL(3, 1) NOT NULL DEFAULT 5.0,
    win_probability DECIMAL(5, 4) NOT NULL,
    draw_probability DECIMAL(5, 4) NOT NULL,
    loss_probability DECIMAL(5, 4) NOT NULL,
    tactical_grade VARCHAR(5) NOT NULL,
    simulation_result_json JSON NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_match (user_id, match_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 6. SPESIFIKASI DAN FORMULASI MATEMATIS MESIN KECERDASAN BUATAN (AI ENGINE)

### 6.1 Teori Probabilistik & Naive Bayes Classifier (MAP Rule)
Dalam sistem Flickboard, algoritma **Naive Bayes** dimanfaatkan untuk menghitung estimasi probabilitas posterior secara seketika (*real-time probabilistic inference*) ketika pengguna menggeser slider atau mengubah susunan pemain.

Diberikan vektor fitur taktis observasi:
$$X = \langle x_1, x_2, \dots, x_n \rangle$$
di mana variabel mewakili:
- $x_1$: Kategori PPDA (misal: *Ekstrem*, *Agresif*, *Moderat*)
- $x_2$: Kategori Ketinggian Garis Pertahanan (*High*, *Medium*, *Low*)
- $x_3$: Kategori Kecepatan Pemain Kunci Lawan (*Fast*, *Moderate*)
- $x_4$: Kategori Kerentanan Pressing Lawan (*Vulnerable*, *Resistant*)
- $x_5$: Rata-rata Kualitas Skuad Starting XI (*High*, *Medium*)

Probabilitas posterior untuk hasil pertandingan $C_k \in \{\text{Menang}, \text{Seri}, \text{Kalah}\}$ dihitung melalui Teorema Bayes:
$$P(C_k \mid X) = \frac{P(C_k) \cdot \prod_{i=1}^n P(x_i \mid C_k)}{P(X)}$$

Karena penyebut $P(X)$ adalah konstan normalisasi yang identik untuk seluruh kelas, keputusan klasifikasi hasil akhir dan kalkulasi proporsi probabilitas dieksekusi dengan aturan **Maximum A Posteriori (MAP)**:
$$\hat{C} = \arg\max_{C_k} \left[ P(C_k) \prod_{i=1}^n P(x_i \mid C_k) \right]$$

### 6.2 Diskretisasi MDLP (Minimum Description Length Principle) & SADD
Parameter sepak bola seperti nilai PPDA (misal 6.42), jarak garis pertahanan (meter), dan skor *pace* merupakan data kontinu. Algoritma **MDLP** (Fayyad & Irani) digunakan untuk mempartisi data kontinu menjadi interval diskrit berbasis entropi tanpa menghilangkan batas kritis taktis.

Untuk mengatasi potensi masalah *early stopping* pada sampel pertandingan spesifik, sistem mengadopsi varian **SADD** (*Semi-supervised Adaptive Discriminative Discretization*), sehingga interval fitur dipetakan secara stabil:

| Variabel Kontinu | Rentang Nilai Numerik | Label Diskretisasi Taktis | Keterangan Efek Taktis |
| :--- | :--- | :--- | :--- |
| **PPDA Intensity** | $2.0 \le \text{PPDA} < 6.0$ | `EKSTREM_AGRESIF` | Gegenpressing intensitas tinggi, intervensi < 6 operan. |
| | $6.0 \le \text{PPDA} < 8.5$ | `AGRESIF` | Standar pressing Hansi Flick (challenge intensity tinggi). |
| | $8.5 \le \text{PPDA} < 11.5$ | `MODERAT` | Pressing zonal di sepertiga tengah. |
| | $\text{PPDA} \ge 11.5$ | `PASIF` | Mid-to-low block, menunggu kesalahan lawan. |
| **Defensive Line** | $8.5 \le \text{Line} \le 10.0$ | `EKSTREM_TINGGI` | Kompresi vertikal total; resiko umpan lambung diagonal. |
| | $6.5 \le \text{Line} < 8.5$ | `TINGGI_STANDAR` | Garis aktif Barcelona; jebakan offside terkoordinasi. |
| | $4.0 \le \text{Line} < 6.5$ | `MEDIUM` | Mengurangi ruang di belakang bek. |
| | $\text{Line} < 4.0$ | `RENDAH_DALAM` | Pertahanan rapat di area penalti sendiri. |

### 6.3 Algoritma Decision Tree sebagai Engine Explainable AI (XAI)
Untuk menghasilkan umpan balik taktis yang dapat dijelaskan kepada staf pelatih, sistem menggunakan **Decision Tree** (C4.5 / CART).

1. **Pengukuran Shannon Entropy**:
   $$H(S) = - \sum_{k=1}^m p_k \log_2(p_k)$$
   di mana $p_k$ adalah rasio kelas hasil ke-$k$ dalam himpunan data $S$.

2. **Perhitungan Information Gain (IG)**:
   $$IG(S, A) = H(S) - \sum_{v \in \text{Values}(A)} \frac{|S_v|}{|S|} H(S_v)$$
   Fitur dengan Information Gain tertinggi dipilih sebagai simpul pemisah (*splitting node*).

3. **Pemangkasan Pohon (Tree Pruning & Regularisasi)**:
   Untuk mencegah *overfitting* terhadap anomali pertandingan tertentu, ditetapkan pembatasan parameter:
   - `max_depth = 5`
   - `min_samples_split = 10`
   - `min_samples_leaf = 5`

4. **Ekstraksi Aturan IF-THEN Menjadi Narasi Taktis Natural**:
   Setiap lintasan dari *Root Node* ke *Leaf Node* diekstrak menjadi aturan proposisional, lalu diterjemahkan oleh *Template Generator Engine*:

```
Lintasan Pohon:
IF (opponent_pace == "HIGH") AND (defensive_line == "EKSTREM_TINGGI") AND (pressing_intensity != "EKSTREM_AGRESIF")
THEN Output_Class = "VULNERABLE_TO_COUNTER" (Risk: HIGH)

Translasi Bahasa Alami:
"Peringatan Taktis: Mempertahankan garis pertahanan sangat tinggi tanpa didukung pressing ekstrem di lini depan memberikan waktu bagi lawan untuk melepaskan umpan terobosan ke penyerang cepat mereka. Disarankan menaikkan intensitas Gegenpressing atau menurunkan sedikit garis pertahanan."
```

### 6.4 Penanganan Isu Empiris Olahraga
1. **Mitigasi Class Imbalance**: FC Barcelona di bawah Hansi Flick mencatatkan persentase kemenangan historis yang sangat dominan (> 75%). Hal ini dapat menyebabkan model bias memprediksi kemenangan secara naif. Solusinya, dilakukan *Synthetic Minority Over-sampling Technique* (SMOTE) dan penyesuaian bobot kelas (*balanced class weights*) pada fungsi objektif model.
2. **Continuous Learning Pipeline**: Setiap kali pertandingan baru selesai, log kejadian (*event log* SPADL) diimpor ke sistem secara mingguan untuk menyegarkan tabel kontinjensi Naive Bayes dan memperbarui pemisahan Decision Tree, menjamin model tidak usang terhadap pergeseran taktik lawan.

---

## 7. DESAIN ANTARMUKA & PANDUAN PENGALAMAN PENGGUNA (UI/UX)

### 7.1 Filosofi Visual & Design System
Antarmuka Flickboard dirancang dengan estetika **Modern Dark Blaugrana**, merefleksikan identitas klub Catalan yang dipadukan dengan kecanggihan ruang analis teknologi tinggi.

| Token Desain | Nilai Heksadesimal / Spesifikasi | Implementasi Penggunaan |
| :--- | :--- | :--- |
| **Primary Navy** | `#004D98` | Header bar, tombol utama aksi, aksen grafik radar. |
| **Secondary Garnet** | `#A50044` | Indikator peringatan taktis, badge risiko, aksen border aktif. |
| **Accent Gold** | `#EDBB00` | Rating pemain, lencana nilai S/A, bintang penanda kunci. |
| **Dark Background** | `#0A0E17` | Latar belakang kanvas aplikasi (*Dark Mode OLED*). |
| **Card Surface** | `#141C2B` (Glassmorphism 15% opacity blur) | Panel kartu pertandingan, wadah papan taktik. |
| **Typography** | `Inter` (Body) & `Outfit` (Headings & Numerik) | Tipografi bersih, modern, dan sangat mudah dibaca. |

### 7.2 Alur Perjalanan Pengguna (6-Step User Journey)
```
[1. Login / Onboarding]
   └── Sambutan hangat: "Selamat datang Analis Taktik di Ciutat Esportiva"
            │
            ▼
[2. Match Briefing]
   └── Meninjau laga berikutnya: FC Barcelona vs Real Madrid / Bayern Munchen
            │
            ▼
[3. Opponent Scouting Room]
   └── Menganalisis Radar Chart kekuatan, pemain kunci, dan kerentanan lawan
            │
            ▼
[4. Tactical Setup (Tactical Board & Sliders)]
   └── Drag & Drop Starting XI + Atur Slider (PPDA, High Line, Tempo)
            │
            ▼
[5. Eksekusi Simulasi (Simulation Engine)]
   └── Animasi modern: Sistem memproses triliunan data dan kalkulasi pohon keputusan
            │
            ▼
[6. Review Laporan Taktis (Post-Match Report)]
   └── Donut Chart Probabilitas + Radar Grade Taktik + Umpan Balik Asisten Pelatih (XAI)
```

---

## 8. PETA JALAN PENGEMBANGAN (ROADMAP & WBS)

Pengembangan direncanakan berlangsung selama **12 Minggu (6 Sprint)** dengan siklus *Agile Scrum* 2-mingguan:

```
Minggu   :  1   2   3   4   5   6   7   8   9  10  11  12
Fase 1   : [======] (Inisiasi, Data & Setup Arsitektur)
Fase 2   :         [======] (AI Engine & FastAPI Service)
Fase 3   :                 [======] (Laravel API Gateway & MySQL)
Fase 4   :                         [==========] (Flutter Frontend & Drag-Drop)
Fase 5   :                                     [======] (Integrasi End-to-End & Caching)
Fase 6   :                                             [======] (QA, UAT & Deployment)
```

### 8.1 Work Breakdown Structure (WBS) Rinci

#### Sprint 1 (Minggu 1–2): Inisiasi, Data Scraping & Setup Fondasi
- Inisiasi repositori monorepo/multi-repo (Flutter, Laravel, FastAPI).
- Pengumpulan dan pembersihan dataset historis pertandingan La Liga & Liga Champions era Hansi Flick.
- Konversi log pertandingan ke format fitur terstruktur (PPDA, garis pertahanan, atribut pemain).
- Perancangan DDL basis data MySQL dan setup container Docker lokal.

#### Sprint 2 (Minggu 3–4): Pengembangan Mesin Inferensi AI (Python FastAPI)
- Implementasi algoritma diskretisasi kontinu MDLP dan adaptasi SADD.
- Pelatihan model Naive Bayes untuk probabilitas hasil pertandingan (*Win/Draw/Loss*).
- Pelatihan model Decision Tree dan ekstraksi modul aturan IF-THEN deterministik.
- Pembuatan REST API endpoint FastAPI (`POST /ml/predict`) dengan validasi Pydantic.
- Pengujian unit model ML dengan metrik validasi silang (*cross-validation* F1-Score).

#### Sprint 3 (Minggu 5–6): Backend Data Broker & Database API (Laravel 11)
- Setup project Laravel 11 dan konfigurasi otentikasi Sanctum.
- Implementasi migrasi basis data, seeder skuad pemain Barcelona, dan data klub lawan.
- Pembuatan API CRUD untuk data pemain, data lawan, jadwal pertandingan, dan riwayat simulasi.
- Pembangunan *Data Broker Service*: penggabungan parameter input mobile dengan atribut database, lalu meneruskan ke FastAPI secara asinkron (menggunakan Guzzle/HTTP Client).
- Implementasi logika caching riwayat simulasi.

#### Sprint 4 (Minggu 7–8): Pengembangan Frontend Mobile (Flutter) - Core & Tactical Board
- Setup arsitektur BLoC/Clean Architecture di Flutter.
- Implementasi sistem desain tematik (warna Blaugrana, tipografi, tema gelap).
- Pembuatan *Match Dashboard* dan modul *Opponent Scouting Room* (integrasi library `fl_chart`).
- Pembuatan *Interactive Tactical Board*: lapangan kanvas hijau dengan mekanisme *Drag-and-Drop* pemain dari bench ke starting XI.
- Pembuatan *Tactical Instructions Panel* dengan slider reaktif untuk PPDA, Garis Pertahanan, dan Tempo.

#### Sprint 5 (Minggu 9–10): Reporting, Integrasi End-to-End & UX Polish
- Pembuatan modul *Match Simulation Engine*: overlay animasi pemrosesan kalkulasi data.
- Pembuatan halaman *Post-Match Tactical Report*: Donut Chart probabilitas, badge nilai taktis (S, A, B, C, D), dan daftar kartu umpan balik asisten pelatih (*Explainable AI*).
- Integrasi penuh Flutter ➔ Laravel ➔ FastAPI ➔ Database MySQL.
- Penanganan skenario offline/error (jika server AI timeout, sediakan fallback rule).

#### Sprint 6 (Minggu 11–12): Pengujian Menyeluruh (QA), UAT & Rilis
- Pengujian performa beban (*Stress Testing*) dan pengujian latensi API.
- Pelaksanaan *User Acceptance Testing* (UAT) menggunakan simulasi skenario pertandingan riil (misal vs Real Madrid, Bayern Munchen, Atletico Madrid).
- Perbaikan bug dan optimasi ukuran APK/IPA.
- Deployment backend ke server staging/cloud (VPS / Docker Container / AWS EC2).
- Finalisasi dokumentasi pengguna dan serah terima rilis.

---

## 9. RENCANA PENGUJIAN & JAMINAN KUALITAS (TESTING & QA)

### 9.1 Matriks Skenario Pengujian Validasi Taktis (UAT Scenarios)

| ID Uji | Skenario Pertandingan | Input Konfigurasi Taktis Pengguna | Hasil Simulasi yang Diharapkan (Expected Result) |
| :--- | :--- | :--- | :--- |
| **TC-01** | **El Clásico: vs Real Madrid** <br>(Lawan punya sayap sangat cepat: Vinícius Jr., Mbappé). | Pengguna mengatur `Defensive Line` = 9.5 (Ekstrem Tinggi) dan `PPDA` = 12.0 (Pasif). | Model AI mendeteksi kerentanan fatal. Probabilitas kalah tinggi (> 60%). Umpan balik XAI memperingatkan: *"Garis pertahanan sangat tinggi tanpa pressing agresif di lini tengah membiarkan penyerang sayap lawan mengeksploitasi ruang kosong di belakang bek."* |
| **TC-02** | **El Clásico: vs Real Madrid** <br>(Koreksi Taktis Adaptif). | Pengguna menurunkan `Defensive Line` ke 6.5 (Medium-Tinggi), menaikkan `PPDA` ke 4.5 (Ekstrem Agresif), dan memasang Pedri & Casadó sebagai double pivot. | Probabilitas menang melonjak (> 65%). Umpan balik XAI mengapresiasi: *"Pressing agresif berhasil mematikan transisi tengah Madrid, sementara penurunan garis pertahanan sukses meredam kecepatan eksplosif sayap lawan."* |
| **TC-03** | **Duel Tekanan: vs Bayern Munchen** <br>(Lawan punya kemampuan pressing seimbang). | Pengguna mengatur `PPDA` = 5.0, `Defensive Line` = 7.5, dan `Tempo` = 8.5 (Cepat Vertikal). | Pertandingan diproyeksikan sengit dengan xG tinggi kedua tim. Nilai taktik Grade A. Asisten pelatih memberikan saran duel lini tengah. |
| **TC-04** | **Blok Rendah: vs Getafe CF** <br>(Lawan bermain bertahan pasif dengan blok sangat dalam). | Pengguna mengatur `Tempo` = 3.5 (Penguasaan Lambat) dan formasi melebar dengan Lamine Yamal & Raphinha. | Dominasi penguasaan bola diproyeksikan > 72%. Umpan balik menyarankan percepatan tempo sirkulasi atau overload di area *half-space* untuk membongkar pertahanan berlapis. |

### 9.2 Metrik Kualitas Teknis
- **Akurasi Model Machine Learning**: Target F1-Score pada data pengujian minimal **85%**.
- **Latensi API End-to-End**: Panggilan simulasi harus merespons dalam waktu **< 500 ms**.
- **Toleransi Kesalahan**: Jika layanan Python FastAPI tidak dapat dijangkau, Laravel secara otomatis menjalankan *Fallback Rule Matrix* lokal agar aplikasi mobile tidak mengalami *crash*.

---

## 10. MATRIKS STACK TEKNOLOGI & ALOKASI SUMBER DAYA

### 10.1 Tech Stack Matrix
| Komponen Sistem | Teknologi Terpilih | Versi | Alasan Pemilihan & Kegunaan |
| :--- | :--- | :--- | :--- |
| **Mobile Client** | Flutter (Dart) | 3.24+ | Performa native, *cross-platform* (Android & iOS), ekosistem widget drag-and-drop dan charting yang kaya. |
| **State Management** | Flutter BLoC / Cubit | 8.1+ | Arsitektur state terprediksi, memisahkan logika bisnis dari UI visual secara bersih. |
| **Mobile Charting** | `fl_chart` | 0.68+ | Visualisasi interaktif untuk Radar Chart, Donut Chart, dan Bar Chart dengan animasi 60 FPS. |
| **Backend API Gateway** | Laravel (PHP) | 11.x | Ekosistem matang, ORM Eloquent tangguh, keamanan terintegrasi, manajemen relasi data dan auth mudah. |
| **API Authentication** | Laravel Sanctum | 4.x | Token autentikasi berbasis bearer yang ringan dan aman untuk aplikasi mobile. |
| **Database Server** | MySQL | 8.0+ | Basis data relasional standar industri, performa query indeks tinggi, mendukung tipe data JSON bawaan. |
| **AI Inference Service** | Python (FastAPI) | 0.115+ | Performa mikro-layanan asinkron super cepat, integrasi langsung ke scikit-learn dan ekosistem Python ML. |
| **Machine Learning Lib** | Scikit-Learn & NumPy | 1.5+ | Algoritma *DecisionTreeClassifier*, *MultinomialNB*, metrik evaluasi, dan pipeline diskretisasi data. |
| **Kontainerisasi** | Docker & Docker Compose | 24+ | Standarisasi lingkungan pengujian, staging, dan kemudahan deployment cloud. |

### 10.2 Kebutuhan Tim Pengembang (Resource Allocation)
1. **1x Mobile Lead Engineer (Flutter)**: Bertanggung jawab atas Tactical Board Drag & Drop, state management BLoC, animasi, dan integrasi API mobile.
2. **1x Backend Engineer (Laravel/MySQL)**: Bertanggung jawab atas skema database, API autentikasi, manajemen data lawan/pemain, dan data broker gateway.
3. **1x AI / Data Science Specialist (Python)**: Bertanggung jawab atas pipeline diskretisasi MDLP, pelatihan model Naive Bayes & Decision Tree, serta mesin ekstraksi aturan Explainable AI.
4. **1x UI/UX Designer**: Bertanggung jawab atas desain antarmuka tema Blaugrana modern, interaksi drag-and-drop, dan aset visual kartu pemain.
5. **1x QA & Sports Analytics Consultant**: Bertanggung jawab atas pengujian skenario fungsional dan validitas logika sepak bola asisten pelatih virtual.

---

## 11. KESIMPULAN & REKOMENDASI EKSEKUSI

Dokumen Rencana Pengembangan Aplikasi (*Master Engineering Plan*) ini secara komprehensif berhasil menjembatani visi desain antarmuka dari **Blueprint Aplikasi: Barça Tactical Planner (Flickboard)** dengan landasan ilmiah sains olahraga dan kecerdasan buatan dari **Analisis Jurnal Taktik Sepak Bola**.

Dengan memadukan:
1. **Keunggulan Visual & Interaktivitas Mobile** (Papan Taktik *Drag & Drop*, Kontrol Slider Taktis Hansi Flick, dan Dasbor Hasil Laga Interaktif),
2. **Ketangguhan Arsitektur Microservices 3-Tier** (Flutter, Laravel 11, dan Python FastAPI), serta
3. **Inovasi Explainable AI (XAI)** melalui sinergi *Decision Tree Rule Traversal* dan *Naive Bayes MAP Probabilistic Inference*,

Aplikasi **Barça Tactical Planner (Flickboard)** siap ditransformasikan dari cetak biru konseptual menjadi produk perangkat lunak nyata yang inovatif, berkinerja tinggi, dan memberikan nilai analitik yang otentik bagi penggemar dan praktisi taktik sepak bola modern.

---
*Dokumen ini merupakan spesifikasi acuan resmi untuk seluruh tahapan rekayasa perangkat lunak.*

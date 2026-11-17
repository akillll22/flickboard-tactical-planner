# DOKUMEN RENCANA PENGEMBANGAN SISTEM & DAFTAR TUGAS (DEVELOPMENT PLAN & TASK LIST)
# BARÇA TACTICAL PLANNER (FLICKBOARD)
### *Aplikasi Asisten Pelatih Virtual Berbasis Mobile dengan Integrasi Sports Analytics & Explainable AI (XAI)*

---

| **Atribut Dokumen** | **Keterangan** |
| :--- | :--- |
| **Judul Proyek** | Barça Tactical Planner (Flickboard) |
| **Kode Dokumen** | BTP-DEVPLAN-2026-V1.0 |
| **Versi Dokumen** | 1.0 (Ready for Execution) |
| **Dokumen Acuan** | [Rencana_Pengembangan_Aplikasi_Barca_Tactical_Planner.md](file:///c:/Users/Lenovo/Documents/Mobile%20Programing/Fc%20Barcelona/Blueprint/Rencana_Pengembangan_Aplikasi_Barca_Tactical_Planner.md) |
| **Metodologi** | Agile Scrum (6 Sprint @ 2 Minggu = 12 Minggu Total) |
| **Arsitektur Sistem** | 3-Tier Distributed Microservices (Flutter + Laravel 11 + FastAPI) |
| **Tanggal Efektif** | Oktober 2026 |

---

## 1. RINGKASAN EKSEKUTIF & STRATEGI IMPLEMENTASI

### 1.1 Tujuan Dokumen
Dokumen ini mengonversi spesifikasi konseptual dan arsitektur teknis dari Dokumen *Master Engineering Plan* ke dalam panduan eksekusi rekayasa perangkat lunak yang terstruktur, modular, dan dapat dilacak (*traceable*). Dokumen ini berfungsi sebagai:
1. **Panduan Operasional Tim Pengembang** (*Engineering Operations Manual*).
2. **Rincian Sprint & Backlog Tugas** (*Work Breakdown Structure & Sprint Backlog*).
3. **Matriks Ketertelusuran Fitur** (*Requirement Traceability Matrix*) untuk menjamin pemenuhan FR-01 s/d FR-09 dan NFR-01 s/d NFR-05.
4. **Instrumen Manajemen Mutu & Risiko** (*Quality Assurance & Risk Control Gates*).

### 1.2 Struktur Repositori Terpadu (Monorepo Workspace)
Untuk menyederhanakan orkestrasi 3 lapisan teknologi, proyek dikembangkan menggunakan struktur direktori monorepo modular:

```
barca-tactical-planner/
├── docker/                             # Konfigurasi container development & staging
│   ├── docker-compose.yml              # Orkestrasi MySQL, Laravel, dan FastAPI
│   ├── laravel.Dockerfile
│   └── fastapi.Dockerfile
├── mobile/                             # [Lapisan 1] Flutter Mobile Application
│   ├── lib/
│   │   ├── core/                       # Theme, Constants, Network, Utilities
│   │   ├── data/                       # Models, Repositories, Data Sources
│   │   ├── logic/                      # BLoC / Cubit State Management
│   │   └── presentation/               # Screens, Widgets, Tactical Board Canvas
│   ├── test/                           # Unit & Widget Testing
│   └── pubspec.yaml
├── backend/                            # [Lapisan 2] Laravel 11 API Gateway & Data Broker
│   ├── app/
│   │   ├── Http/Controllers/Api/v1/   # Auth, Match, Opponent, Player, Simulation
│   │   ├── Services/                   # DataBrokerService, HeuristicFallbackService
│   │   └── Models/                     # User, Opponent, BarcaPlayer, Match, Simulation
│   ├── database/                       # Migrations & Comprehensive Seeders
│   ├── routes/api.php
│   └── tests/                          # Feature & Unit Tests
├── ai_engine/                          # [Lapisan 3] Python FastAPI ML Inference Microservice
│   ├── app/
│   │   ├── api/                        # Route /predict & health checks
│   │   ├── core/                       # MDLP Discretizer, Config
│   │   ├── models/                     # Scikit-learn Trained Models (.joblib)
│   │   ├── schemas/                    # Pydantic Request & Response Schemas
│   │   └── services/                   # NaiveBayesService, DecisionTreeRuleExtractor
│   ├── training/                       # Scripts pelatihan model, SMOTE, validasi
│   ├── data/                           # Dataset taktis & SPADL event logs
│   ├── requirements.txt
│   └── tests/                          # Pytest for inference & rule generation
└── docs/                               # Master Engineering Plan & Technical Specs
```

### 1.3 Alur Kerja & Cabang Git (Git Branching Strategy)
- `main` : Cabang produksi stabil; hanya menerima *Merge Request* (MR) yang telah lolos UAT dan QA otomatis.
- `staging` : Cabang integrasi bersama antar layanan mikro untuk pengujian Sprint Review.
- `feature/BTP-XXX-<nama-fitur>` : Cabang fitur individual yang dibuat dari `staging`.
- Setiap PR/MR wajib memenuhi *Code Review Approval* minimal 1 peer reviewer dan lulus uji *Continuous Integration* (CI).

---

## 2. ROADMAP PENGEMBANGAN 12 MINGGU (SPRINT MILESTONES)

```
===================================================================================================
TIMELINE : 12 MINGGU (6 SPRINTS @ 2 MINGGU)
===================================================================================================
Sprint 1 (W1-2)  : Inisiasi, Data Engineering, Docker & Fondasi Database
                   [Milestone 1: Multi-Container Ready & Verified Tactical Dataset]
Sprint 2 (W3-4)  : Mesin Inferensi AI (MDLP, Naive Bayes, Decision Tree XAI, FastAPI)
                   [Milestone 2: Independent AI Service Responding < 200ms]
Sprint 3 (W5-6)  : Laravel 11 API Gateway, Data Broker & Caching Layer
                   [Milestone 3: Complete Backend API & Resilient Microservice Gateway]
Sprint 4 (W7-8)  : Flutter Mobile: Theme Blaugrana, Interactive Tactical Board (Drag-Drop)
                   [Milestone 4: Responsive Tactical Board & Reactive Sliders at 60 FPS]
Sprint 5 (W9-10) : Simulasi UX, Post-Match Report Dashboard, XAI Cards & E2E Integration
                   [Milestone 5: Functional End-to-End Simulation Pipeline]
Sprint 6 (W11-12): Pengujian Skenario Taktis (UAT), Optimasi Latensi, Hardening & Release
                   [Milestone 6: Production Staging Release & Verified UAT Cases TC-01 to TC-04]
===================================================================================================
```

---

## 3. RINCIAN SPRINT-BY-SPRINT & WORK BREAKDOWN STRUCTURE (WBS)

### SPRINT 1 (MINGGU 1–2): INISIASI, DATA ENGINEERING & FONDASI ARSITEKTUR
**Sprint Goal**: Menyiapkan seluruh fondasi lingkungan pengembangan lokal, skema basis data relasional, pengumpulan dataset taktis, dan konfigurasi Docker multi-container.

#### Deliverables & Definition of Done (DoD):
- [x] Docker Compose berjalan mulus menjalankan container MySQL 8, Laravel 11, dan FastAPI.
- [x] Migrasi dan seeder basis data MySQL berhasil dieksekusi tanpa error.
- [x] Dataset taktis historis/sintesis Barcelona era Hansi Flick tervalidasi dan siap untuk training model.
- [x] Repositori Git monorepo terkonfigurasi dengan linter, CI dasar, dan branch protection.

#### Rincian Tugas Sprint 1:
| Kode Tugas | Kategori | Deskripsi Tugas | Estimasi (SP) | PIC / Role | Kriteria Penerimaan (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **TSK-101** | DevOps | Konfigurasi Docker Compose untuk MySQL 8, PHP 8.3/Laravel 11, dan Python 3.11/FastAPI. | 3 | DevOps | Semua container saling berkomunikasi melalui bridge network internal; healthcheck status hijau. |
| **TSK-102** | Backend | Inisiasi project Laravel 11, konfigurasi environment `.env`, koneksi database, dan error logging. | 2 | Backend Dev | `php artisan migrate` berjalan lancar ke database MySQL di container Docker. |
| **TSK-103** | Backend | Implementasi migration skema DDL: `users`, `opponents`, `barca_players`, `matches`, `simulations`. | 3 | Backend Dev | Seluruh constraint PK, FK, INDEX (`idx_user_match`), dan tipe JSON terpasang sesuai Section 5 MEP. |
| **TSK-104** | Backend | Pembuatan Database Seeder untuk 25 pemain Barcelona 2024/2025 dan minimal 10 tim lawan La Liga/UCL. | 3 | Backend Dev | Data pemain memiliki atribut lengkap (`overall_rating`, `pace`, `passing`, `defending`, foto); data lawan memuat atribut scouting akurat. |
| **TSK-105** | AI/Data | Desain skema dataset taktis pelatihan model berbasis parameter Flick (PPDA, High Line, Opponent Pace, dll). | 5 | Data Scientist | Dataset tabular berisikan minimal 2.000 record skenario pertandingan (riil + augmented) dengan label hasil (*Win, Draw, Loss*). |
| **TSK-106** | AI/Data | Analisis korelasi fitur dan eksplorasi data (*EDA*) untuk mengatasi ketidakseimbangan kelas (*class imbalance*). | 3 | Data Scientist | Laporan EDA mengidentifikasi rasio kelas, strategi SMOTE, dan batas ambang fitur taktis. |
| **TSK-107** | Mobile | Inisiasi Flutter 3.24+ project, penataan direktori Clean Architecture, setup linter (`analysis_options.yaml`). | 2 | Mobile Dev | Project Flutter berhasil dikompilasi pada emulator Android & iOS tanpa peringatan linter. |

---

### SPRINT 2 (MINGGU 3–4): PENGEMBANGAN MESIN INFERENSI AI (PYTHON FASTAPI)
**Sprint Goal**: Membangun microservice cerdas berbasis Python FastAPI yang mengimplementasikan diskretisasi MDLP/SADD, Naive Bayes MAP classifier, Decision Tree XAI rule traversal, dan endpoint inferensi.

#### Deliverables & Definition of Done (DoD):
- [x] Modul diskretisasi kontinu-ke-diskrit MDLP/SADD berfungsi stabil.
- [x] Model Naive Bayes terlatih menghasilkan probabilitas posterior (Win, Draw, Loss) dengan F1-Score > 85%.
- [x] Model Decision Tree menghasilkan aturan IF-THEN taktis yang diterjemahkan menjadi narasi berbahasa manusia.
- [x] Endpoint `POST /api/v1/predict` FastAPI merespons < 200 ms dengan format JSON tervalidasi Pydantic.

#### Rincian Tugas Sprint 2:
| Kode Tugas | Kategori | Deskripsi Tugas | Estimasi (SP) | PIC / Role | Kriteria Penerimaan (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **TSK-201** | AI Engine | Implementasi algoritma diskretisasi MDLP (Fayyad & Irani) dan adaptasi SADD untuk fitur numerik kontinu. | 5 | Data Scientist | Fitur PPDA, Line Height, dan Opponent Pace terbagi ke dalam bin diskrit semantik sesuai Section 6.2 MEP. |
| **TSK-202** | AI Engine | Training dan tuning model Naive Bayes Classifier dengan penanganan class imbalance (SMOTE / Class Weights). | 5 | Data Scientist | Model mencapai Cross-Validation F1-Score ≥ 85%; menghasilkan probabilitas posterior valid (total = 1.0). |
| **TSK-203** | AI Engine | Training Decision Tree Classifier (CART) dengan regularisasi `max_depth=5`, `min_samples_leaf=5`. | 5 | Data Scientist | Model pohon keputusan tidak overfitting; visualisasi graphviz pohon keputusan dapat diurai menjadi aturan logis. |
| **TSK-204** | AI Engine | Pembangunan modul *Decision Tree Rule Extractor* & *Template Generator Engine* (Explainable AI Engine). | 5 | Data Scientist | Menghasilkan 3-5 feedback teks terstruktur (STRENGTH, WARNING, RECOMMENDATION) berdasarkan lintasan simpul pohon aktif. |
| **TSK-205** | AI Engine | Pembangunan modul kalkulasi *Projected Stats* (Penguasaan Bola, xG Barca, xG Lawan, Jebakan Offside). | 3 | Data Scientist | Formula matematis menghasilkan estimasi statistik yang selaras dengan profil parameter taktis. |
| **TSK-206** | AI Engine | Setup REST API FastAPI, skema Pydantic (`PredictionRequest`, `PredictionResponse`), endpoint `/api/v1/predict`. | 3 | AI Engineer | Endpoint menerima payload sesuai kontrak Section 4.2 MEP dan merespons dalam < 200 ms. |
| **TSK-207** | AI Engine | Unit test & integrasi Pytest untuk seluruh skenario validasi data ekstrim (edge cases). | 3 | AI Engineer | Cakupan test coverage > 85%; endpoint menangani parameter input tidak lazim secara anggun (*graceful*). |

---

### SPRINT 3 (MINGGU 5–6): BACKEND API GATEWAY, DATA BROKER & CACHING (LARAVEL 11)
**Sprint Goal**: Membangun sistem backend Laravel 11 sebagai API Gateway, manajemen autentikasi Sanctum, master data provider, orkestrasi integrasi ke FastAPI (*Data Broker*), serta caching hasil simulasi.

#### Deliverables & Definition of Done (DoD):
- [x] Autentikasi berbasis token Laravel Sanctum berfungsi penuh (FR-01).
- [x] Endpoint RESTful untuk lawan, pemain, dan pertandingan selesai dan teruji.
- [x] Service *Data Broker* menggabungkan data mobile + atribut database, memanggil FastAPI, dan mengembalikan hasil.
- [x] Mekanisme *caching* dan penyimpanan riwayat simulasi pada tabel `simulations` berfungsi (FR-09).
- [x] *Heuristic Fallback Engine* aktif jika layanan FastAPI mengalami timeout/down.

#### Rincian Tugas Sprint 3:
| Kode Tugas | Kategori | Deskripsi Tugas | Estimasi (SP) | PIC / Role | Kriteria Penerimaan (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **TSK-301** | Backend | Implementasi API Autentikasi Analis (Register, Login, Me, Logout) menggunakan Laravel Sanctum (FR-01). | 3 | Backend Dev | Registrasi dan login menghasilkan bearer token valid; proteksi route via middleware `auth:sanctum`. |
| **TSK-302** | Backend | Implementasi API Match & Opponent (`GET /matches/upcoming`, `GET /opponents/{id}`) (FR-02, FR-03). | 3 | Backend Dev | Mengembalikan metadata jadwal pertandingan, venue, profil lawan, radar 5-poros, dan catatan scouting. |
| **TSK-303** | Backend | Implementasi API Squad Players (`GET /players/barca`) dengan filter posisi dan status aktif. | 2 | Backend Dev | Mengembalikan seluruh skuad dengan atribut taktis lengkap (`pace`, `passing`, `defending`, rating, foto). |
| **TSK-304** | Backend | Pembangunan `DataBrokerService`: agregasi Starting XI, komputasi rata-rata atribut tim, dan formatting payload AI. | 5 | Backend Dev | Service menghitung `team_avg_pace`, `defense_avg_pace`, dan memvalidasi kelengkapan 11 pemain starter. |
| **TSK-305** | Backend | Integrasi HTTP Client asinkron ke FastAPI (`POST /api/v1/simulations/run`) (FR-06). | 4 | Backend Dev | Payload diteruskan ke FastAPI; respons AI diterima dan di-mapping ke struktur standar klien mobile. |
| **TSK-306** | Backend | Implementasi Caching & Histori Simulasi: pencatatan ke tabel `simulations` dan endpoint riwayat (FR-09). | 3 | Backend Dev | Konfigurasi identik langsung menyajikan hasil ter-cache; endpoint `GET /simulations/history` dan `GET /simulations/{id}` tersedia. |
| **TSK-307** | Backend | Implementasi `HeuristicFallbackService` (Matriks Aturan Lokal jika FastAPI timeout / offline). | 3 | Backend Dev | Jika koneksi ke FastAPI gagal setelah timeout 2 detik, sistem mengembalikan estimasi heuristik tanpa melempar error 500. |
| **TSK-308** | Backend | Feature & Integration Testing menggunakan PHPUnit / Pest untuk semua endpoint v1. | 3 | Backend Dev | Semua test suite hijau; waktu eksekusi endpoint end-to-end terukur < 350 ms. |

---

### SPRINT 4 (MINGGU 7–8): FRONTEND MOBILE (FLUTTER) – CORE & TACTICAL BOARD
**Sprint Goal**: Mengimplementasikan antarmuka mobile Flutter dengan Design System Blaugrana modern, Match Dashboard, Opponent Scouting Room (Radar Chart), Interactive Drag-and-Drop Tactical Board, dan Tactical Sliders Panel.

#### Deliverables & Definition of Done (DoD):
- [x] Sistem tema Blaugrana Dark Theme, tipografi Google Fonts (Inter & Outfit), dan glassmorphism cards siap.
- [x] Match Dashboard & Opponent Scouting Room dengan visualisasi Radar Chart `fl_chart` selesai (FR-02, FR-03).
- [x] Papan taktik interaktif (*Tactical Board*) mendukung drag-and-drop starter 11 pemain dengan lancar (FR-04).
- [x] Panel slider taktis (PPDA, High Line, Tempo) reaktif dan terhubung ke state management BLoC (FR-05).
- [x] Performa antarmuka stabil pada frame rate 60 FPS tanpa *jank*.

#### Rincian Tugas Sprint 4:
| Kode Tugas | Kategori | Deskripsi Tugas | Estimasi (SP) | PIC / Role | Kriteria Penerimaan (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **TSK-401** | Mobile UI | Setup Design System & Theme: Dark Navy `#0A0E17`, Deep Blue `#004D98`, Garnet `#A50044`, Gold `#EDBB00`. | 3 | UI Designer / Mobile Dev | Konstanta warna, text style (Inter & Outfit), widget container glassmorphism terpusat di `core/theme`. |
| **TSK-402** | Mobile Logic | Setup BLoC/Cubit Architecture untuk Autentikasi, Match Setup, dan Tactical Board State. | 3 | Mobile Dev | Pemisahan tegas antara event, state, repository, dan presentasi UI. |
| **TSK-403** | Mobile Screen| Implementasi Layar Login, Register, dan Layar Onboarding Tematik "Analis Ciutat Esportiva" (FR-01). | 3 | Mobile Dev | Transisi onboarding < 3 layar; penyimpanan token autentikasi di Flutter Secure Storage. |
| **TSK-404** | Mobile Screen| Implementasi *Match Dashboard*: Next Match Card, info venue, status kebugaran skuad (FR-02). | 4 | Mobile Dev | Data pertandingan diambil dari API Laravel; card pertandingan memiliki styling modern premium. |
| **TSK-405** | Mobile Screen| Implementasi *Opponent Scouting Room*: Radar Chart 5-poros menggunakan `fl_chart`, Key Player Card (FR-03). | 4 | Mobile Dev | Radar chart merender 5 atribut lawan secara akurat; kartu profil pemain kunci menampilkan rating & pace. |
| **TSK-406** | Mobile Widget| Pembuatan Kanvas Lapangan Hijau Virtual (*Tactical Pitch Widget*) dengan koordinat formasi 4-2-3-1 & 3-2-4-1. | 4 | Mobile Dev | Lapangan terlukis proporsional dengan garis lapangan dan slot posisi pemain yang jelas. |
| **TSK-407** | Mobile Widget| Implementasi Mekanisme *Drag-and-Drop* Pemain dari Bottom Sheet Bench ke Slot Lapangan (FR-04). | 6 | Mobile Dev | Gesture drag-and-drop halus (60 FPS); validasi posisi; indikator visual slot aktif; batasan tepat 11 pemain. |
| **TSK-408** | Mobile Widget| Implementasi *Tactical Instructions Panel*: Slider PPDA (2.0–15.0), Line Height (1–10), Tempo (1–10) (FR-05). | 4 | Mobile Dev | Slider reaktif mengupdate label semantik seketika (e.g. "Gegenpressing Ekstrem", "Garis Ekstrem Tinggi"). |

---

### SPRINT 5 (MINGGU 9–10): SIMULATION UX, POST-MATCH REPORTING & E2E INTEGRATION
**Sprint Goal**: Membangun pengalaman eksekusi simulasi dengan animasi modern, tampilan Post-Match Tactical Report komprehensif (Donut Chart & Grade S/A/B/C/D), integrasi Explainable AI Feedback cards, riwayat simulasi, dan integrasi penuh end-to-end.

#### Deliverables & Definition of Done (DoD):
- [x] Overlay loader simulasi dengan animasi komputasi taktis berjalan minimal 1.5 detik (FR-06).
- [x] Halaman Post-Match Report menampilkan Donut Chart probabilitas (100%), Tactical Grade Badge, dan metrik prediksi (FR-07).
- [x] Kartu umpan balik Asisten Pelatih (XAI) menampilkan alasan logis (STRENGTH, WARNING, RECOMMENDATION) (FR-08).
- [x] Fitur riwayat simulasi dan komparasi taktik berfungsi penuh (FR-09).
- [x] Alur data Flutter ➔ Laravel ➔ FastAPI ➔ MySQL berjalan mulus secara end-to-end.

#### Rincian Tugas Sprint 5:
| Kode Tugas | Kategori | Deskripsi Tugas | Estimasi (SP) | PIC / Role | Kriteria Penerimaan (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **TSK-501** | Mobile UX | Pembuatan *Simulation Loader Modal*: animasi interaktif analisis spasio-temporal dan matriks taktis (FR-06). | 3 | Mobile Dev | Menampilkan animasi rotasi taktik dan teks progres dinamis minimal 1.5 detik sebelum membuka hasil. |
| **TSK-502** | Mobile Screen| Implementasi *Post-Match Tactical Report*: Donut Chart probabilitas menang/seri/kalah dengan `fl_chart` (FR-07). | 4 | Mobile Dev | Donut chart menampilkan proporsi warna Blaugrana (Menang), Abu (Seri), Merah (Kalah); animasi transisi halus. |
| **TSK-503** | Mobile Screen| Implementasi Badge Nilai Taktik (Grade S, A, B, C, D) dan Grid Statistik Proyeksi (xG, Penguasaan Bola, Offside). | 3 | Mobile Dev | Visualisasi badge bernuansa gold/garnet; angka statistik proyeksi ditampilkan dengan tipografi Outfit yang kontras. |
| **TSK-504** | Mobile Screen| Implementasi Komponen Kartu *Explainable AI (XAI) Feedback Engine* (FR-08). | 4 | Mobile Dev | Kartu menampilkan badge tipe (Kekuatan, Peringatan, Rekomendasi), nama pemain kunci lawan, dan solusi taktis. |
| **TSK-505** | Mobile Screen| Implementasi Layar *Simulation History* & Komparasi Taktik (FR-09). | 4 | Mobile Dev | Pengguna dapat melihat daftar simulasi lampau, memuat ulang konfigurasi ke papan taktik, atau membandingkan 2 hasil. |
| **TSK-506** | Integrasi | Integrasi API Penuh: Pengiriman payload taktik dari Flutter ke Laravel dan binding respons hasil simulasi. | 5 | Fullstack / Lead | Alur end-to-end berjalan tanpa hambatan; serialisasi dan deserialisasi JSON sukses di semua skenario formasi. |
| **TSK-507** | Resilience | Penanganan Error Jaringan, Timeout, dan Notifikasi Fallback pada Klien Mobile. | 3 | Mobile Dev | Snackbar / dialog informatif muncul saat koneksi bermasalah; data fallback tersaji secara elegan tanpa aplikasi crash. |

---

### SPRINT 6 (MINGGU 11–12): TESTING MENYELURUH (QA), UAT TAKTIS, OPTIMASI & RILIS
**Sprint Goal**: Menjalankan pengujian fungsional dan taktis mendalam (UAT TC-01 s/d TC-04), pengujian performa & latensi, pengoptimalan ukuran build, serta deployment lingkungan staging/cloud.

#### Deliverables & Definition of Done (DoD):
- [x] Keempat skenario uji taktis spesifik (TC-01 s/d TC-04) tervalidasi dengan output AI yang tepat secara sepak bola.
- [x] Latensi respons end-to-end terbukti < 500 ms; aplikasi mobile berjalan mulus 60 FPS.
- [x] Seluruh bug kritis (P0 & P1) terselesaikan (Zero Critical Bugs).
- [x] Backend ter-deploy pada environment staging (Docker / Cloud VPS).
- [x] Paket rilis aplikasi mobile (APK Android & IPA iOS) siap didistribusikan.

#### Rincian Tugas Sprint 6:
| Kode Tugas | Kategori | Deskripsi Tugas | Estimasi (SP) | PIC / Role | Kriteria Penerimaan (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **TSK-601** | QA / UAT | Eksekusi Skenario UAT TC-01: El Clásico vs Real Madrid (High Line 9.5, PPDA 12.0 Pasif). | 3 | QA & Analyst | Probabilitas kalah > 60%; AI memberi peringatan eksploitasi ruang kosong di belakang bek oleh Mbappe/Vini Jr. |
| **TSK-602** | QA / UAT | Eksekusi Skenario UAT TC-02: El Clásico vs Real Madrid - Koreksi Taktis (Line 6.5, PPDA 4.5 Agresif, Double Pivot).| 3 | QA & Analyst | Probabilitas menang melonjak > 65%; XAI mengapresiasi redaman serangan balik dan kestabilan lini tengah. |
| **TSK-603** | QA / UAT | Eksekusi Skenario UAT TC-03 & TC-04: vs Bayern Munchen (Duel Pressing) & vs Getafe CF (Low Block). | 4 | QA & Analyst | TC-03 menghasilkan Grade A dengan xG tinggi; TC-04 menghasilkan penguasaan bola > 72% dengan saran variasi serangan. |
| **TSK-604** | Performa | Audit Performa UI Flutter (Flutter DevTools Profiling): memori, frame rendering, dan optimasi widget rebuild. | 3 | Mobile Dev | Frame rendering stabil pada 60 FPS; tidak ditemukan memory leak pada operasional drag-and-drop berulang. |
| **TSK-605** | Performa | Load Testing & Benchmark Latensi API (Apache JMeter / k6): simulasi 50 concurrent simulation requests. | 3 | Backend / DevOps | P95 latency respons API end-to-end tercatat < 500 ms; CPU dan konsumsi memori server stabil. |
| **TSK-606** | Keamanan | Audit Keamanan Sistem: Sanitasi input, validasi bearer token, proteksi SQL Injection, rate limiting API. | 2 | Backend Dev | Pengujian penetrasi dasar lulus; rate limiting mencegah brute force login dan abuse endpoint simulasi. |
| **TSK-607** | DevOps | Deployment Backend & FastAPI ke Cloud Server Staging (Docker Compose + Nginx Reverse Proxy + SSL). | 4 | DevOps | Layanan staging live dan dapat diakses publik via HTTPS; database MySQL terpasang backup otomatis. |
| **TSK-608** | Release | Build Final Production Artifacts: Android APK/AAB dan iOS TestFlight IPA, serta penyusunan User Release Notes. | 3 | Mobile Lead | Build release ditandatangani secara aman; dokumen panduan instalasi dan release notes lengkap. |

---

## 4. MATRIKS KETERTELUSURAN KEBUTUHAN (REQUIREMENT TRACEABILITY MATRIX)

Tabel berikut memetakan setiap Kebutuhan Fungsional (FR) dan Non-Fungsional (NFR) dari dokumen MEP ke nomor tugas spesifik:

| Kode Kebutuhan | Nama Kebutuhan | Sprint | Kode Tugas Terkait | Status Validasi |
| :--- | :--- | :---: | :--- | :--- |
| **FR-01** | Autentikasi & Onboarding Analis | Sprint 3 & 4 | TSK-103, TSK-301, TSK-403 | Terpetakan |
| **FR-02** | Match Dashboard | Sprint 3 & 4 | TSK-104, TSK-302, TSK-404 | Terpetakan |
| **FR-03** | Opponent Scouting Room | Sprint 3 & 4 | TSK-104, TSK-302, TSK-405 | Terpetakan |
| **FR-04** | Interactive Tactical Board (Drag & Drop) | Sprint 4 | TSK-402, TSK-406, TSK-407 | Terpetakan |
| **FR-05** | Tactical Instructions Panel (Sliders) | Sprint 4 | TSK-402, TSK-408 | Terpetakan |
| **FR-06** | Match Simulation Engine & UX Loader | Sprint 2, 3, 5 | TSK-206, TSK-305, TSK-501, TSK-506 | Terpetakan |
| **FR-07** | Post-Match Tactical Report | Sprint 2, 5 | TSK-202, TSK-205, TSK-502, TSK-503 | Terpetakan |
| **FR-08** | Explainable AI (XAI) Feedback Engine | Sprint 2, 5 | TSK-203, TSK-204, TSK-504 | Terpetakan |
| **FR-09** | Simulation History & Caching | Sprint 3 & 5 | TSK-103, TSK-306, TSK-505 | Terpetakan |
| **NFR-01** | Performa & Latensi (< 500ms, 60 FPS) | Sprint 4 & 6 | TSK-407, TSK-604, TSK-605 | Terpetakan |
| **NFR-02** | Skalabilitas & Kontainerisasi Microservices | Sprint 1 & 6 | TSK-101, TSK-607 | Terpetakan |
| **NFR-03** | Keamanan Data & Autentikasi TLS | Sprint 3 & 6 | TSK-301, TSK-606, TSK-607 | Terpetakan |
| **NFR-04** | Estetika Visual Blaugrana & Modern UX | Sprint 4 & 5 | TSK-401, TSK-501, TSK-502, TSK-504 | Terpetakan |
| **NFR-05** | Kompatibilitas Mobile (Android 8+ & iOS 14+) | Sprint 1 & 6 | TSK-107, TSK-608 | Terpetakan |

---

## 5. STRUKTUR TIM, PERAN & MATRIKS RACI (RESPONSIBILITY ASSIGNMENT)

### 5.1 Alokasi Peran Tim
1. **Lead Mobile Engineer (Flutter)**: Menangani kanvas Tactical Board, drag-and-drop, state BLoC, charting, dan rendering 60 FPS.
2. **Backend & Gateway Engineer (Laravel 11)**: Menangani database MySQL, autentikasi Sanctum, REST API, orkestrasi Data Broker, dan caching.
3. **AI / Data Science Specialist (Python)**: Menangani pembersihan dataset, diskretisasi MDLP/SADD, model Naive Bayes, Decision Tree XAI, dan microservice FastAPI.
4. **UI/UX Designer**: Menangani sistem desain Blaugrana, aset visual, palet warna, tipografi, dan flow interaksi drag-and-drop.
5. **QA & Tactical Domain Analyst**: Menangani skenario pengujian, validasi logika taktik sepak bola Hansi Flick, load testing, dan UAT.
6. **DevOps Engineer**: Menangani kontainerisasi Docker, pipeline CI/CD, manajemen lingkungan staging, dan monitoring performa.

### 5.2 Matriks RACI (*Responsible, Accountable, Consulted, Informed*)
| Modul / Domain Pekerjaan | Mobile Lead | Backend Dev | AI Specialist | UI/UX Designer | QA & Analyst | DevOps |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| Arsitektur Docker & CI/CD | I | C | C | I | I | **A / R** |
| Database Schema & Seeder | I | **A / R** | C | I | C | C |
| Model ML & Endpoint FastAPI | I | C | **A / R** | I | C | C |
| Data Broker & API Gateway | C | **A / R** | C | I | I | I |
| UI/UX Blaugrana Design System | R | I | I | **A / R** | C | I |
| Tactical Board Drag-and-Drop | **A / R** | I | I | C | C | I |
| Explainable AI Text Generation | C | C | **A / R** | I | C | I |
| Post-Match Report Dashboard | **A / R** | C | C | C | C | I |
| UAT Tactical Validation Scenarios | C | C | C | I | **A / R** | I |
| Production Release & Deployment | R | R | R | I | C | **A / R** |

*Keterangan: **R** = Responsible (Pelaksana), **A** = Accountable (Penanggung Jawab), **C** = Consulted (Konsultan), **I** = Informed (Penerima Informasi)*

---

## 6. MANAJEMEN RISIKO TEKNIS & RENCANA KONTINJENSI (CONTINGENCY PLAN)

| No | Risiko Teknis | Dampak | Probabilitas | Rencana Mitigasi & Kontinjensi |
| :-: | :--- | :---: | :---: | :--- |
| **1** | **Latensi Eksekusi AI > 500 ms** akibat kalkulasi pohon keputusan dan diskretisasi kompleks. | Tinggi | Sedang | - Model ML di-load ke dalam memori saat FastAPI startup (*singleton worker*).<br>- Terapkan caching hasil simulasi pada level database MySQL untuk konfigurasi parameter yang pernah dihitung.<br>- Optimasi payload JSON seminimal mungkin. |
| **2** | **Jank / Frame Drop pada Tactical Board** saat pemain di-drag pada perangkat Android spesifikasi rendah. | Tinggi | Sedang | - Gunakan `RepaintBoundary` pada kanvas lapangan.<br>- Hindari rebuild widget seluruh tree; isolasi state perubahan posisi hanya pada widget pin pemain menggunakan `BlocBuilder` dengan filter `buildWhen`. |
| **3** | **Bias Prediksi Kemenangan (Class Imbalance)** karena persentase kemenangan Barcelona era Flick sangat dominan (> 75%). | Tinggi | Tinggi | - Terapkan teknik *Synthetic Minority Over-sampling Technique* (SMOTE) pada dataset latih.<br>- Gunakan pembobotan kelas (*balanced class weights*) pada Decision Tree dan Naive Bayes.<br>- Verifikasi kurva presisi-recall secara reguler. |
| **4** | **Layanan FastAPI Mengalami Gangguan (Downtime)** sehingga menghalangi proses simulasi di aplikasi mobile. | Kritis | Rendah | - Laravel mengimplementasikan `HeuristicFallbackService` otomatis.<br>- Jika request ke FastAPI melebihi timeout 2.000 ms, sistem beralih mengeksekusi sistem berbasis aturan deterministik lokal di Laravel tanpa memunculkan error fatal pada pengguna. |
| **5** | **Overfitting Pohon Keputusan (Decision Tree)** menghasilkan umpan balik XAI yang terlalu spesifik atau tidak masuk akal secara taktik. | Sedang | Sedang | - Terapkan pemangkasan ketat (*tree pruning*): `max_depth = 5`, `min_samples_split = 10`, `min_samples_leaf = 5`.<br>- Lakukan review aturan bersama konsultan analis taktik sepak bola sebelum model di-freeze. |

---

## 7. DEFINITION OF DONE (DOD) & STANDAR KUALITAS KODE

Sebuah tugas (Task) atau User Story dinyatakan **Selesai (Done)** jika memenuhi kriteria wajib berikut:
1. **Penyelesaian Kode**: Kode selesai ditulis, bersih, dan mematuhi konvensi bahasa (PSR-12 untuk Laravel, Effective Dart untuk Flutter, PEP-8 untuk Python).
2. **Pengujian Otomatis (Unit/Feature Testing)**:
   - Backend & AI Engine memiliki cakupan pengujian unit/fitur minimal 80%.
   - Klien mobile memiliki unit test untuk logika BLoC/Cubit dan repository.
3. **Peer Review**: Minimal 1 Senior Engineer telah menyetujui Pull/Merge Request.
4. **Validasi Kebutuhan**: Seluruh *Acceptance Criteria* yang tercantum pada kartu tugas terpenuhi dan telah diverifikasi oleh tim QA.
5. **Integrasi Bebas Regresi**: Branch fitur berhasil di-merge ke branch `staging` tanpa menyebabkan kegagalan build pada pipeline CI/CD.
6. **Dokumentasi Terkini**: Endpoint baru tercatat dalam dokumentasi OpenAPI/Postman collection dan komentar kode penting diperbarui.

---

## 8. PANDUAN EKSEKUSI LANGKAH PERTAMA (IMMEDIATE NEXT STEPS)

Untuk segera memulai Sprint 1, tim diinstruksikan menjalankan langkah-langkah prioritas berikut:

1. **Langkah 1 (Hari 1)**: Inisiasi struktur monorepo dan konfigurasi file `docker/docker-compose.yml` untuk lingkungan MySQL 8, Laravel 11, dan Python 3.11.
2. **Langkah 2 (Hari 2–3)**: Eksekusi migrasi tabel basis data relasional pada Laravel 11 dan buat Database Seeder untuk skuad pemain FC Barcelona serta lawan-lawan utama.
3. **Langkah 3 (Hari 4–5)**: Finalisasi dataset skenario taktis pelatihan model AI pada direktori `ai_engine/data/` dan siapkan skrip evaluasi awal diskretisasi MDLP.
4. **Langkah 4 (Hari 6–7)**: Inisiasi project Flutter pada direktori `mobile/`, pasang pustaka inti (`flutter_bloc`, `fl_chart`, `google_fonts`, `dio`), dan verifikasi integrasi build awal.

---
*Dokumen ini merupakan rencana operasional dan daftar tugas resmi untuk memandu rekayasa sistem Barça Tactical Planner (Flickboard) menuju rilis tepat waktu, berkinerja tinggi, dan terverifikasi secara ilmiah.*

# 🎙️ PANDUAN & SCRIPT PRESENTASI UTS PEMROGRAMAN MOBILE
**Proyek:** FLICKBOARD - FC Barcelona Tactical Planner & Match Simulation Engine  
**Waktu Presentasi Ideal:** 7 – 10 Menit (Presentasi + Demo + Q&A)

---

## 🎯 DAFTAR SLIDE & PANDUAN BICARA (SPEAKING SCRIPT)

### Slide 1: Judul & Pembuka (Opening)
* **Visual:** Judul besar *FLICKBOARD: FC Barcelona Tactical Planner*, nama mata kuliah, platform Flutter.
* **Apa yang Anda Ucapkan:**
  > *"Selamat pagi/siang Bapak/Ibu dosen pengampu dan rekan-rekan sekalian. Pada kesempatan UTS Pemrograman Mobile hari ini, saya akan mempresentasikan aplikasi yang telah saya kembangkan berjudul **Flickboard: FC Barcelona Tactical Planner & Match Simulation Engine**. Aplikasi ini dibangun menggunakan framework **Flutter & Dart** dengan arsitektur **BLoC State Management** dan integrasi data live dari **AllSportsAPI**."*

---

### Slide 2: Latar Belakang & Masalah (Problem Statement)
* **Visual:** Tiga kartu tantangan: Taktik Modern Hansi Flick, Kelemahan Aplikasi Konvensional, dan Solusi Flickboard.
* **Apa yang Anda Ucapkan:**
  > *"Latar belakang proyek ini terinspirasi dari tren taktik sepak bola modern, khususnya sistem pelatih Hansi Flick di FC Barcelona yang menerapkan garis pertahanan sangat tinggi (High Defensive Line) dan Gegenpressing intens. Masalahnya, papan taktik konvensional di mobile saat ini mayoritas hanya berupa gambar statis tanpa data pemain asli dan tidak terhubung dengan jadwal kompetisi riil. Flickboard hadir sebagai solusi: papan taktik interaktif berbasis Drag-and-Drop yang terhubung secara live ke API sepak bola serta dilengkapi mesin simulasi taktis untuk mengukur risiko dan potensi kemenangan tim."*

---

### Slide 3: Arsitektur Sistem & Tech Stack (Teknis)
* **Visual:** 4 Pilar Arsitektur: Frontend Flutter, BLoC/Cubit, Data Layer REST API, dan In-Memory Caching.
* **Apa yang Anda Ucapkan:**
  > *"Dari sisi teknis, aplikasi ini dirancang dengan prinsip **Clean Architecture**:*
  > *1. **Frontend:** Menggunakan Flutter 3 yang berjalan mulus secara cross-platform di Android maupun Web (Google Chrome) dengan tema visual khas FC Barcelona.*
  > *2. **State Management:** Memanfaatkan paket `flutter_bloc` dengan `TacticalBoardCubit` untuk memisahkan logika penataan formasi dan `SimulationCubit` untuk komputasi simulasi.*
  > *3. **Networking & Data:** `TacticalRepository` mengonsumsi REST API dari AllSportsAPI untuk menarik skuad dan jadwal.*
  > *4. **Caching & Resiliency:** Dilengkapi sistem In-Memory Cache berdurasi 6 jam untuk mencegah terbuangnya kuota API, serta memiliki fallback offline agar aplikasi tetap berjalan 100% tanpa internet."*

---

### Slide 4: Fitur 1 - Papan Taktik Interaktif (Tactical Pitch)
* **Visual:** Lapangan hijau CustomPainter, formasi 4-2-3-1 dan 3-2-4-1, mekanisme Drag & Drop.
* **Apa yang Anda Ucapkan:**
  > *"Fitur utama aplikasi adalah **Papan Taktik Lapangan Hijau Interaktif**. Di sini kami menggunakan `CustomPainter` untuk menggambar garis lapangan presisi. Ke-11 pemain starting XI otomatis terpasang sesuai posisinya masing-masing. Pengguna dapat melakukan rotasi taktik dengan mudah: men-drag pemain di lapangan untuk saling bertukar posisi (SWAP), atau menarik pemain dari bangku cadangan (*Bench*). Kami juga menyediakan sakelar formasi instan antara 4-2-3-1 standar dan 3-2-4-1 pada fase transisi menyerang."*

---

### Slide 5: Fitur 2 - Integrasi Live AllSportsAPI & Smart Cache
* **Visual:** Koneksi data tim 97, jadwal La Liga & UCL 2026/2027, proteksi kuota API.
* **Apa yang Anda Ucapkan:**
  > *"Keunggulan berikutnya adalah konektivitas data riil. Flickboard terhubung langsung ke **AllSportsAPI** untuk FC Barcelona (Team ID: 97), menyinkronkan 35 pemain terkini (seperti Lamine Yamal, Raphinha, Pedri, Joan Garcia, hingga Gabriel Jesus) dan jadwal pertandingan resmi musim ini menghadapi lawan-lawan tangguh seperti Villarreal, Sabah FC di Liga Champions, hingga Manchester City. Untuk menjaga performa dan kuota API, kami menyematkan sistem **Smart In-Memory Caching** sehingga navigasi dan simulasi taktis tidak membebani server eksternal berulang kali."*

---

### Slide 6: Fitur 3 - Simulation Engine Hansi Flick
* **Visual:** 3 Slider Instruksi (PPDA, Defensive Line, Tempo) dan Laporan Hasil Simulasi.
* **Apa yang Anda Ucapkan:**
  > *"Flickboard bukan sekadar papan visual, melainkan juga simulator. Pengguna dapat mengatur tiga parameter taktis kunci:*
  > *1. **PPDA**: Intensitas Gegenpressing merebut bola kembali.*
  > *2. **Garis Pertahanan (1-10)**: Mengontrol jebakan offside (Offside Trap).*
  > *3. **Tempo Build-Up**: Kecepatan aliran bola.*
  > *Ketika tombol simulasi ditekan, engine kami menghitung probabilitas Win/Draw/Loss, proyeksi xG (Expected Goals), persentase penguasaan bola, serta memberikan evaluasi Grade taktik dan peringatan risiko serangan balik lawan."*

---

### Slide 7: Alur Demo Penggunaan Aplikasi (Workflow)
* **Visual:** 4 langkah: Pilih Lawan -> Atur Formasi & Pemain -> Atur Slider Taktik -> Jalankan & Baca Hasil Simulasi.
* **Apa yang Anda Ucapkan:**
  > *"Berikut adalah skenario demo yang akan saya tunjukkan secara langsung di layar..." (Lanjutkan ke live demo).*

---

### Slide 8: Tantangan Pengembangan & Solusi Teknis
* **Visual:** Responsivitas layar, handling drag-and-drop Web vs Mobile, penanganan limit kuota API.
* **Apa yang Anda Ucapkan:**
  > *"Selama proses pengembangan, terdapat tiga tantangan teknis menarik yang berhasil kami selesaikan:*
  > *Pertama, penyesuaian gesture Drag-and-Drop: di web kami gunakan `Draggable` instan dengan mouse grab, sedangkan di mobile menggunakan `LongPressDraggable` agar tidak bentrok dengan scroll.*
  > *Kedua, responsivitas layar desktop Chrome vs HP: kami menerapkan `ConstrainedBox` dan memindahkan kontrol tombol ke `bottomNavigationBar` agar pas dan tidak ada komponen yang tumpang tindih.*
  > *Ketiga, perlindungan kuota API dengan caching pintar 6 jam dan fallback offline 35 pemain."*

---

### Slide 9: Kesimpulan & Sesi Tanya Jawab (Closing)
* **Visual:** Ringkasan capaian, apresiasi, dan pembukaan sesi Q&A.
* **Apa yang Anda Ucapkan:**
  > *"Kesimpulannya, Flickboard berhasil mengimplementasikan standar pemrograman mobile modern: arsitektur BLoC yang bersih, UX interaktif responsif, manajemen jaringan yang andal, dan logika kalkulasi yang solutif. Terima kasih atas perhatian Bapak/Ibu dosen dan rekan-rekan. Sekarang saya persilakan jika ada pertanyaan. Visca el Barça!"*

---

## 💻 TIPS DEMO APLIKASI DI KELAS

1. **Jalankan Aplikasi Sebelum Giliran Anda:**
   Buka terminal di folder proyek:
   ```bash
   cd mobile
   flutter run -d chrome
   ```
   Pastikan tab Chrome `localhost` sudah terbuka dan siap di layar proyektor.
2. **Langkah Demo yang Mengesankan:**
   - **Tunjukkan Home Dashboard:** Tunjukkan carousel pertandingan (geser lawan tanding dari Villarreal ke Manchester City / Aston Villa).
   - **Buka Papan Taktik:** Tunjukkan formasi 4-2-3-1 dengan 11 pemain Blaugrana terpasang rapi.
   - **Demonstrasikan Drag-and-Drop:**
     - Geser pemain Lamine Yamal (#10) ke posisi Raphinha (#11) -> jelaskan bahwa sistem melakukan **Swap Posisi otomatis**.
     - Tarik pemain dari bangku cadangan (misal Dani Olmo diganti Fermin atau Jesus diganti Adeyemi) -> jelaskan substitusi pemain.
   - **Tunjukkan Sakelar Formasi:** Ubah dari `4-2-3-1` ke `3-2-4-1 (Fase In-Possession)` di dropdown pojok kanan atas.
   - **Geser Slider Taktik:** Naikkan Garis Pertahanan ke `8.5` dan turunkan PPDA ke `5.0`.
   - **Klik 'SIMULASIKAN PERTANDINGAN':** Tunjukkan animasi loader telemetry modern hingga laporan probabilitas (Win Rate, xG, dan analisis Jebakan Offside) muncul di layar!

---

## ❓ PERSIAPAN TANYA JAWAB DENGAN DOSEN (FAQ UTS)

**Q1: Mengapa memilih BLoC / Cubit daripada setState biasa atau Provider?**
> *A: "Karena BLoC memisahkan logika bisnis (business logic) sepenuhnya dari tampilan UI. Dengan Cubit, perubahan state pemain dan simulasi bersifat terprediksi (predictable), mudah diuji, dan kode UI tetap bersih serta efisien tanpa rebuild widget yang tidak perlu."*

**Q2: Bagaimana aplikasi menangani jika koneksi internet terputus atau API limit?**
> *A: "Kami menerapkan prinsip offline-first dan smart caching. Data dari AllSportsAPI disimpan di memory cache selama 6 jam. Jika jaringan terputus atau server mengembalikan error 429 (rate limit), repository secara cerdas mengalihkan sumber data ke fallback lokal 35 pemain terverifikasi, sehingga aplikasi tidak pernah crash atau blank."*

**Q3: Bagaimana cara membuat Drag-and-Drop berjalan mulus di browser dan Android sekaligus?**
> *A: "Kami memanfaatkan konstanta `kIsWeb` dari Flutter foundation. Jika dijalankan di browser web, sistem memakai `Draggable` dengan mouse cursor grab agar responsif seketika. Sedangkan jika di Android, sistem memakai `LongPressDraggable` dengan haptic feedback 180ms agar pengguna bisa membedakan antara gesture scroll layar dan gesture memindahkan pemain."*

# BAB I: PENDAHULUAN

## 1.1 Deskripsi Aplikasi
TugasKu adalah sebuah aplikasi manajemen tugas dan jadwal pelajaran berbasis _mobile_ yang dirancang khusus untuk pelajar dan mahasiswa. Aplikasi ini bertujuan untuk membantu pengguna dalam mencatat, melacak, dan mengelola tugas akademik serta mata pelajaran mereka dengan lebih terorganisir. Desain antarmuka (UI/UX) pada aplikasi ini dibuat modern, intuitif, dan responsif agar memudahkan pengguna berinteraksi dengan fitur-fitur yang disediakan, seperti pengingat tenggat waktu tugas (deadline) dan ringkasan penyelesaian tugas.

## 1.2 Batasan Proyek
Proyek ini berfokus secara eksklusif pada pengembangan **User Interface (UI)** dan **User Experience (UX)**. Oleh karena itu, interaksi data yang dinamis dan penghubungan dengan _database backend_ (seperti MySQL atau Firebase) belum diimplementasikan pada tahap ini. Data yang ditampilkan di dalam aplikasi, seperti daftar tugas, profil pengguna, dan daftar mata pelajaran, menggunakan data statis (_mock data_ / _dummy data_) yang disematkan langsung di dalam kode.

## 1.3 Kebutuhan Sistem
Untuk menjalankan dan mengembangkan proyek aplikasi TugasKu ini, diperlukan spesifikasi sistem dan perangkat lunak sebagai berikut:
- **Perangkat Keras:** Laptop/PC dengan RAM minimal 8GB (direkomendasikan 16GB) dan prosesor setara Intel Core i5 / AMD Ryzen 5 ke atas.
- **Perangkat Lunak:**
  - Flutter SDK (versi terbaru stabil)
  - Dart SDK (sudah termasuk dalam Flutter SDK)
  - IDE (Integrated Development Environment) seperti **VS Code** atau **Android Studio**
  - Android Emulator atau perangkat Android fisik untuk pengujian

---

# BAB II: PERANCANGAN DESAIN (UI/UX DESIGN ANALYSIS)

Sebelum tahap implementasi kode, perancangan antarmuka visual dirumuskan untuk menjaga konsistensi tampilan dan pengalaman pengguna.

## 2.1 Gaya Desain (Design System)
Desain aplikasi TugasKu mengadopsi gaya modern dengan sentuhan minimalis dan _glassmorphism_.
- **Warna Utama (Primary Color):** Menggunakan warna biru cerah (`#3B82F6`) yang merepresentasikan produktivitas dan kepercayaan, serta warna sekunder ungu lembut (`#8B5CF6`).
- **Warna Latar dan Teks:** Menggunakan paduan warna netral (_Slate_) untuk latar belakang (`#F1F5F9`) dan teks gelap (`#0F172A`) guna menjaga tingkat keterbacaan (readability) yang tinggi.
- **Tipografi (Font):** Menggunakan font **Google Fonts**, yaitu **Inter** untuk teks paragraf/deskripsi karena tingkat keterbacaannya yang baik, dan **Outfit** untuk judul (_heading_) agar terlihat modern.
- **Ikonografi:** Menggunakan _Cupertino Icons_ dan ikon bawaan _Material Design_ untuk menunjukkan status dan navigasi dengan jelas.

## 2.2 Alur Pengguna (User Flow / Wireframe)
Alur penggunaan aplikasi dirancang sederhana dan _to-the-point_:
1. **Buka Aplikasi ➔ Splash Screen ➔ Onboarding:** Pengguna disambut dan diberi pengenalan singkat tentang aplikasi.
2. **Onboarding ➔ Login / Register:** Pengguna diarahkan untuk masuk atau membuat akun (saat ini simulasi UI).
3. **Login ➔ Halaman Utama (Dashboard):** Pengguna melihat ringkasan tugas, grafik perkembangan, dan jadwal mata pelajaran hari ini.
4. **Halaman Utama ➔ Detail Tugas / Tambah Tugas:** Dari _dashboard_, pengguna dapat mengetuk tugas tertentu untuk melihat detailnya, atau menekan tombol tambah untuk membuat tugas baru.
5. **Navigasi Bawah (Bottom Nav Bar):** Memudahkan perpindahan antara _Dashboard_, _Daftar Semua Tugas_, _Mata Pelajaran_, dan _Profil Pengguna_.

---

# BAB III: TAHAP PEMBUATAN APLIKASI (KODE UI FLUTTER)

Bab ini akan memaparkan bagaimana susunan widget pada Flutter dibangun untuk merealisasikan desain UI tanpa dukungan database sungguhan.

## 3.1 Setup Awal Proyek
### 3.1.1 Membuat Proyek
Proyek aplikasi dibuat menggunakan command line (CLI) Flutter dengan menjalankan perintah:
```bash
flutter create tugasku_flutter
```
Setelah pembuatan proyek selesai, dilakukan pembersihan struktur _folder_ bawaan pada `lib` untuk disusun ulang secara modular (seperti pembagian folder `screens`, `widgets`, `theme`, `utils`, dan `data`).

### 3.1.2 Konfigurasi pubspec.yaml
Untuk menggunakan font khusus dan aset gambar, file `pubspec.yaml` dimodifikasi dengan mendaftarkan dependensi pihak ketiga dan folder lokasi _assets_.
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  intl: ^0.19.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

## 3.2 Implementasi Data Statis (Mock Data)
Karena ketiadaan _database_, data-data palsu (_mock data_) disediakan dalam file `lib/data/dummy_data.dart`. Variabel berupa `List` statis dibuat untuk menggantikan respons dari API, contohnya untuk data mata pelajaran dan daftar tugas harian.
```dart
// Contoh Mock Data di dummy_data.dart
static final List<TaskModel> todayTasks = [
  TaskModel(
    id: 't1',
    title: 'Desain UI/UX Mobile App',
    subject: 'Interaksi Manusia dan Komputer',
    deadline: DateTime.now().add(const Duration(hours: 5)),
    priority: 'Tinggi',
    status: 'Belum',
  ),
  // ... data lainnya
];
```

## 3.3 Pengodean Halaman Antarmuka (Screens & Custom Widgets)
Aplikasi ini dipecah ke dalam beberapa halaman dan _custom widget_ independen agar mudah diatur (_maintainable_).

### 3.3.1 Halaman Login & Register (login_screen.dart & register_screen.dart)
Halaman autentikasi dibangun menggunakan _input field_ kustom. Penggunaan widget `TextFormField` dibungkus dengan dekorasi untuk input email dan _password_, serta `ElevatedButton` kustom bernama `PrimaryButton` untuk tombol masuk/daftar. Halaman ini mensimulasikan proses login dengan menampilkan animasi perputaran (loading) sementara sebelum berpindah ke menu utama.

### 3.3.2 Halaman Utama & Dashboard (dashboard_screen.dart)
Halaman ini adalah pusat aplikasi yang memuat _Summary Card_ untuk status tugas dan daftar tugas terdekat. Daftar tugas disusun menggunakan `ListView.builder` agar memori perangkat tidak terbebani jika jumlah tugas bertambah. Komponen tugas dipisah dalam widget tersendiri yaitu `TaskCard` yang menampilkan ikon, nama tugas, mata pelajaran, serta status.

### 3.3.3 Halaman Detail Tugas & Mata Pelajaran (task_detail_screen.dart)
Saat sebuah kartu tugas ditekan, sistem menavigasikan ke `task_detail_screen.dart`. Halaman ini berisi susunan teks (menggunakan `Column` dan `Row`) yang menjelaskan tenggat waktu tugas, instruksi, dan spesifikasi tambahan. Terdapat pula tombol aksi simulasi seperti "Tandai Selesai" atau "Kumpulkan Tugas" yang akan memunculkan sebuah interaksi _bottom sheet_ (`submission_list_sheet.dart`).

### 3.3.4 Tampilan Simulasi Diskusi & Bantuan (Mock UI)
Di dalam aplikasi juga dirancang sebuah simulasi area diskusi dengan dosen/AI pada file `discussion_sheet.dart`. Halaman ini sepenuhnya menampilkan UI statis berupa balon chat _(chat bubbles)_, seolah-olah pengguna dapat bertanya mengenai instruksi tugas secara _real-time_, yang bertujuan untuk mempresentasikan kemungkinan fitur masa depan agar aplikasi terlihat lebih kaya.

## 3.4 Sistem Navigasi Antar Halaman (Routing)
Perpindahan antar halaman utama sebagian besar dikendalikan melalui `BottomNavigationBar` (menggunakan `IndexedStack` pada `main_screen.dart`). Sedangkan untuk perpindahan tumpukan layar (seperti dari Dashboard ke Detail Tugas), navigasi diimplementasikan menggunakan:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const TaskDetailScreen(taskId: 't1')),
);
```
Untuk mengembalikan layar, digunakan fungsi standar `Navigator.pop(context);`.

---

# BAB IV: PENGUJIAN TAMPILAN DAN PENUTUP

## 4.1 Pengujian Responsivitas Layanan (UI Testing)
Tampilan antarmuka telah melalui pengujian visual menggunakan emulator Android (Pixel) dan perangkat _mobile_ sungguhan. Penggunaan widget responsif seperti `Expanded`, `Flexible`, `ListView`, dan `SafeArea` memastikan bahwa desain aplikasi tidak mengalami masalah _overflow_ (pecah atau melewati batas layar) baik pada _smartphone_ berukuran kecil maupun layar menengah, serta kompatibel ketika fitur _keyboard_ virtual terbuka (terutama saat login).

## 4.2 Rencana Pengembangan Selanjutnya (Future Roadmap)
Untuk mengubah purwarupa (UI/UX statis) ini menjadi aplikasi fungsional penuh, berikut adalah rencana pengembangan ke depannya:
1. **Integrasi Backend dan Database:** Menghubungkan aplikasi ke layanan seperti **Firebase** atau **API REST dengan database MySQL** untuk menyimpan data profil pengguna, daftar tugas, dan jadwal pelajaran secara permanen.
2. **Autentikasi Nyata (Real Auth):** Menerapkan login dengan verifikasi email/password maupun integrasi Google Sign-In, menggantikan tombol login statis yang ada saat ini.
3. **Notifikasi dan Pengingat Otomatis:** Mengimplementasikan _Local Push Notifications_ agar pengguna mendapat peringatan (alarm) beberapa jam sebelum tenggat waktu (deadline) tugas berakhir.
4. **Integrasi Chatbot AI:** Mengintegrasikan _API OpenAI (ChatGPT)_ ke dalam halaman diskusi tugas untuk memberikan fitur tanya jawab interaktif sebagai asisten belajar siswa.

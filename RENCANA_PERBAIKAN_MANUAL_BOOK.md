# Rencana Perbaikan manual_book.docx — TugasKu Flutter

> **Tujuan:** Menyinkronkan seluruh konten `manual_book.docx` agar 100% sesuai dengan source code aktual di project.
> **Target file yang diubah:** File-file `.md` di folder `manual_book/` yang menjadi sumber konten docx.
> **File yang TIDAK diubah:** Path file `manual_book.docx` (tetap di root project).

---

## Informasi Penting untuk AI Agent

### Struktur Proyek
```
tugasku_flutter/
├── lib/                           ← Source code aktual
│   ├── main.dart
│   ├── data/dummy_data.dart
│   ├── models/task_model.dart
│   ├── utils/app_colors.dart
│   ├── utils/status_helpers.dart
│   ├── theme/theme_manager.dart
│   ├── widgets/*.dart
│   └── screens/**/*.dart
```

### Aturan Utama
1. **JANGAN mengubah source code di `lib/`** — yang diperbaiki hanya file `.md` di `manual_book/`
2. **Terminologi yang BENAR:** Guru, Siswa, Mata Pelajaran (bukan Dosen, Mahasiswa, Mata Kuliah)
3. **Kode di manual book harus 100% sama** dengan kode aktual di `lib/`
4. **Screenshot** akan dimasukkan manual oleh user — biarkan placeholder `*(Tempatkan screenshot...)*` apa adanya
5. **Cover page dan daftar isi** tidak perlu ditambahkan

---

## PERBAIKAN 1: Terminologi Narasi (Semua File .md)

### Deskripsi
Seluruh teks narasi/deskriptif (bukan kode) di semua 5 file `.md` harus mengganti:
- **Dosen** → **Guru**
- **Mahasiswa** → **Siswa**
- **Mata Kuliah** → **Mata Pelajaran** (khusus narasi, bukan di dalam kode yang memang sudah benar)

### File yang Terdampak

#### `Part_1_Pondasi_dan_Widget.md`
- Tidak ada perubahan terminologi (tidak mengandung Dosen/Mahasiswa)

#### `Part_2_Autentikasi.md`
- Periksa teks narasi, ubah jika ada referensi ke "Dosen" atau "Mahasiswa"

#### `Part_3_Navigasi_dan_Tugas.md`
- Periksa teks narasi, ubah jika ada referensi ke "Dosen" atau "Mahasiswa"

#### `Part_4_Detail_dan_Mata_Kuliah.md`
- Baris 3: `pembuatan halaman detail tugas kuliah, formulir tambah/edit tugas (khusus guru)` ← Sudah benar menggunakan "guru"
- Baris 9: Periksa deskripsi bab, ubah "dosen" jika ada
- Cek semua baris narasi untuk kata "Dosen" / "Mahasiswa" / "Mata Kuliah"

#### `Part_5_Riwayat_dan_Pengaturan.md`
- Baris 9: `selesai oleh sistem atau guru` ← Sudah benar
- Periksa seluruh narasi

### Cara Eksekusi
```bash
# Cari semua kemunculan di narasi (bukan di blok kode)
grep -n "Dosen\|Mahasiswa\|Mata Kuliah" manual_book/*.md
# Lalu ganti satu per satu, HANYA yang di narasi (bukan di blok kode dart)
```

> **CATATAN:** Hati-hati jangan mengubah yang di dalam blok kode ``` dart ```. Beberapa kode di DOCX sudah menggunakan terminologi campuran — yang di dalam kode ikuti saja apa yang ada di file aktual.

---

## PERBAIKAN 2: Sinkronisasi Kode — Part 1 (Pondasi & Widget)

**File:** `manual_book/Part_1_Pondasi_dan_Widget.md`

### 2.1 Bab 1: pubspec.yaml
**Status:** ⚠️ Perlu update versi dependency
- DOCX: `google_fonts: ^6.2.0`
- Aktual: `google_fonts: ^6.2.1`
- Aktual juga punya: `cupertino_icons: ^1.0.8`

**Aksi:** Update blok kode yaml agar sesuai dengan `pubspec.yaml` aktual. Ganti:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.0
  intl: ^0.19.0
```
Menjadi:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  intl: ^0.19.0
```

Dan ganti bagian assets dari:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/logo.png
```
Menjadi:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

---

### 2.2 Bab 2: app_colors.dart
**Status:** ❌ KRITIS — DOCX tidak punya dark mode support

**Aksi:** Ganti SELURUH blok kode `app_colors.dart` dengan kode aktual dari `lib/utils/app_colors.dart`.

---

### 2.3 Bab 3: theme_manager.dart
**Status:** ❌ KRITIS — DOCX tidak punya toggle method

**Aksi:** Ganti blok kode `theme_manager.dart` dengan kode aktual dari `lib/theme/theme_manager.dart`.

---

### 2.4 Bab 3: main.dart
**Status:** ❌ KRITIS — DOCX tidak punya ValueListenableBuilder

**Aksi:** Ganti blok kode `main.dart` dengan kode aktual dari `lib/main.dart`.

---

### 2.5 Bab 4.2: custom_text_field.dart
**Status:** ❌ KRITIS — Kode di DOCX jauh berbeda dengan aktual

**Aksi:** Ganti SELURUH blok kode `custom_text_field.dart` dengan kode aktual dari `lib/widgets/custom_text_field.dart` (salin seluruh isi file).

---

### 2.6 Bab 4.3: primary_button.dart
**Status:** ❌ KRITIS — DOCX punya StatelessWidget sederhana, aktual punya StatefulWidget + animasi

**Aksi:** Ganti SELURUH blok kode `primary_button.dart` dengan kode aktual dari `lib/widgets/primary_button.dart` (salin seluruh isi file).

---

### 2.7 Bab 4.6: task_card.dart
**Status:** ❌ KRITIS — Kode di DOCX menggunakan parameter String terpisah, aktual menggunakan `TaskModel`

**Aksi:** Ganti SELURUH blok kode `task_card.dart` dengan kode aktual dari `lib/widgets/task_card.dart` (salin seluruh isi file).

---

## PERBAIKAN 3: Sinkronisasi Kode — Part 2 (Autentikasi)

**File:** `manual_book/Part_2_Autentikasi.md`

### 3.1 Bab 5: splash_screen.dart
**Aksi:** Ganti SELURUH blok kode dengan kode aktual dari `lib/screens/splash/splash_screen.dart` (salin seluruh isi file).

---

### 3.2 Bab 6: onboarding_screen.dart
**Aksi:** Ganti SELURUH blok kode dengan kode aktual dari `lib/screens/onboarding/onboarding_screen.dart` (salin seluruh isi file).

---

### 3.3 Bab 7: login_screen.dart
**Aksi:** Ganti SELURUH blok kode login_screen.dart di .md dengan kode aktual dari `lib/screens/login/login_screen.dart` (salin seluruh isi file).

---

### 3.4 Bab 8: register_screen.dart
**Aksi:** Ganti dengan kode aktual dari `lib/screens/register/register_screen.dart`.

---

### 3.5 Bab 9: forgot_password_screen.dart
**Aksi:** Ganti dengan kode aktual dari `lib/screens/forgot_password/forgot_password_screen.dart`.

---

## PERBAIKAN 4: Sinkronisasi Kode — Part 3 (Navigasi & Tugas)

**File:** `manual_book/Part_3_Navigasi_dan_Tugas.md`

### 4.1 Bab 10: main_screen.dart
**Aksi:** Ganti SELURUH blok kode main_screen.dart di .md dengan kode aktual dari `lib/screens/main/main_screen.dart` (salin seluruh isi file).

---

### 4.2 Bab 11: dashboard_screen.dart
**Aksi:** Ganti SELURUH blok kode dashboard_screen.dart di .md dengan kode aktual dari `lib/screens/dashboard/dashboard_screen.dart` (salin seluruh isi file).

---

### 4.3 Bab 12: notification_screen.dart
**Aksi:** Ganti SELURUH blok kode notification_screen.dart di .md dengan kode aktual dari `lib/screens/notification/notification_screen.dart` (salin seluruh isi file).

---

### 4.4 Bab 13: task_list_screen.dart
**Aksi:** Ganti SELURUH blok kode task_list_screen.dart di .md dengan kode aktual dari `lib/screens/task_list/task_list_screen.dart` (salin seluruh isi file).

---

## PERBAIKAN 5: Sinkronisasi Kode — Part 4 (Detail & Mata Pelajaran)

**File:** `manual_book/Part_4_Detail_dan_Mata_Kuliah.md`

### 5.1 Semua blok kode di Part 4
Untuk setiap bab berikut, **bandingkan** kode di .md dengan file aktual dan **ganti jika berbeda**:

| Bab | File MD | File Aktual |
|-----|---------|-------------|
| 14.1 | task_detail_screen.dart di .md | `lib/screens/task_detail/task_detail_screen.dart` |
| 14.2 | task_form_screen.dart di .md | `lib/screens/task_form/task_form_screen.dart` |
| 14.3 | discussion_sheet.dart di .md | `lib/widgets/discussion_sheet.dart` |
| 14.4 | submission_list_sheet.dart di .md | `lib/widgets/submission_list_sheet.dart` |
| 15.1 | subject_screen.dart di .md | `lib/screens/subject/subject_screen.dart` |
| 15.2 | subject_detail_screen.dart di .md | `lib/screens/subject_detail/subject_detail_screen.dart` |
| 15.3 | subject_form_screen.dart di .md | `lib/screens/subject_form/subject_form_screen.dart` |

### 5.2 Typo: "Locations" → "Lokasi"
Di Part_4, referensi ke `subject_detail_screen.dart` menggunakan "Locations" bukan "Lokasi". Perbaiki:
```diff
- Locations: lib/screens/subject_detail/subject_detail_screen.dart
+ Lokasi: lib/screens/subject_detail/subject_detail_screen.dart
```

---

## PERBAIKAN 6: Sinkronisasi Kode — Part 5 (Riwayat & Pengaturan)

**File:** `manual_book/Part_5_Riwayat_dan_Pengaturan.md`

### 6.1 Semua blok kode di Part 5
Untuk setiap bab berikut, **ganti jika berbeda** dengan file aktual:

| Bab | File MD | File Aktual |
|-----|---------|-------------|
| 16 | history_screen.dart di .md | `lib/screens/history/history_screen.dart` |
| 17.1 | profile_screen.dart di .md | `lib/screens/profile/profile_screen.dart` |
| 17.2 | edit_profile_screen.dart di .md | `lib/screens/edit_profile/edit_profile_screen.dart` |
| 18 | settings_screen.dart di .md | `lib/screens/settings/settings_screen.dart` |

---

## PERBAIKAN 7: Tambah Bab Baru — File yang Belum Terdokumentasikan

### 7.1 Tambahkan di Part 1 (setelah Bab 2, sebelum Bab 3)

#### Bab Baru: Data Model (`task_model.dart`)

Tambahkan bab baru dengan format yang sama seperti bab lain:

```markdown
## Bab X: Model Data Aplikasi

Class-class model yang mendefinisikan struktur data tugas, komentar, dan mata pelajaran untuk seluruh aplikasi.

### 1. Penjelasan Komponen
Berisi tiga class utama: `CommentModel` untuk data komentar diskusi, `TaskModel` untuk data tugas lengkap beserta status dan deadline, dan `SubjectModel` untuk data mata pelajaran.

### 2. Lokasi File
- **Nama File:** `task_model.dart`
- **Lokasi:** `lib/models/task_model.dart`

### 3. Kode Sumber
```
*(Diikuti kode aktual dari `lib/models/task_model.dart`)*

---

#### Bab Baru: Data Dummy (`dummy_data.dart`)

```markdown
## Bab X: Data Dummy Aplikasi

File ini menyediakan data contoh (dummy) yang digunakan sebagai pengganti database untuk simulasi seluruh tampilan aplikasi.

### 1. Penjelasan Komponen
Berisi daftar mata pelajaran (`dummySubjects`), daftar tugas (`dummyTasks`) dengan berbagai status dan prioritas, profil pengguna siswa dan guru (`dummyStudentProfile`, `dummyTeacherProfile`), serta daftar siswa dummy (`dummyStudents`).

### 2. Lokasi File
- **Nama File:** `dummy_data.dart`
- **Lokasi:** `lib/data/dummy_data.dart`

### 3. Kode Sumber
```
*(Diikuti kode aktual dari `lib/data/dummy_data.dart`)*

---

#### Bab Baru: Helper Status & Prioritas (`status_helpers.dart`)

```markdown
## Bab X: Helper Warna Status & Prioritas

Class utilitas yang menyediakan fungsi-fungsi helper untuk menentukan warna berdasarkan status tugas, tingkat prioritas, serta pengecekan keterlambatan deadline.

### 1. Penjelasan Komponen
Berisi method statis untuk mendapatkan warna prioritas (`getPriorityColor`), warna status (`getStatusColor`), label status yang ditampilkan berdasarkan role (`getDisplayStatus`), dan fungsi cek keterlambatan (`isLate`).

### 2. Lokasi File
- **Nama File:** `status_helpers.dart`
- **Lokasi:** `lib/utils/status_helpers.dart`

### 3. Kode Sumber
```
*(Diikuti kode aktual dari `lib/utils/status_helpers.dart`)*

---

## Checklist Verifikasi Akhir

Setelah semua perbaikan selesai, verifikasi:
- [ ] Semua terminologi narasi konsisten: Guru, Siswa, Mata Pelajaran
- [ ] Typo "Locations" diperbaiki menjadi "Lokasi"
- [ ] Screenshot placeholder tetap ada
- [ ] Semua blok kode di 5 file Markdown sudah tersinkronisasi dengan file di `lib/`
- [ ] Ada bab baru untuk `task_model.dart`, `dummy_data.dart`, `status_helpers.dart` di Part 1

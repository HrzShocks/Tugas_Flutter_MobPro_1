# Dummy Data

Gunakan data berikut sebagai acuan untuk membuat file `dummy_data.dart`.

## Dummy Tasks

### 1. Tugas Analisis Kebutuhan

- Subject: Analisis & Desain Sistem.
- Lecturer: Bu Rina.
- Description: Buat laporan analisis kebutuhan sistem menggunakan diagram UML.
- Given Date: 03 Juni 2026.
- Deadline: 05 Juni 2026.
- Status: Belum Dikerjakan.
- Priority: Tinggi.

### 2. Implementasi UI Mobile

- Subject: Pemrograman Mobile.
- Lecturer: Pak Andi.
- Description: Selesaikan slicing UI Dashboard sesuai referensi desain Figma.
- Given Date: 03 Juni 2026.
- Deadline: 07 Juni 2026.
- Status: Sedang Dikerjakan.
- Priority: Sedang.

### 3. Praktikum Komunikasi Data

- Subject: Komunikasi Data.
- Lecturer: Bu Sari.
- Description: Konfigurasi topologi jaringan kantor menggunakan Cisco Packet Tracer.
- Given Date: 02 Juni 2026.
- Deadline: 06 Juni 2026.
- Status: Selesai.
- Priority: Tinggi.

### 4. Problem Set Kalkulus

- Subject: Kalkulus Lanjut II.
- Lecturer: Pak Budi.
- Description: Kerjakan soal problem set bab Integral Lipat Dua.
- Given Date: 01 Juni 2026.
- Deadline: 04 Juni 2026.
- Status: Belum Dikerjakan.
- Priority: Sedang.

### 5. Essay Teknologi Masa Depan

- Subject: Bahasa Inggris Akademik.
- Lecturer: Miss Clara.
- Description: Tulis essay 500 kata mengenai dampak AI pada pengembangan perangkat lunak.
- Given Date: 03 Juni 2026.
- Deadline: 08 Juni 2026.
- Status: Selesai.
- Priority: Rendah.

## Dummy Subjects

1. Analisis & Desain Sistem - Bu Rina.
2. Pemrograman Mobile - Pak Andi.
3. Komunikasi Data - Bu Sari.
4. Kalkulus Lanjut II - Pak Budi.
5. Bahasa Inggris Akademik - Miss Clara.

## Dummy Users

1. **User Dosen:**
   - Nama: Bu Rina
   - Role: Dosen
   - NIDN: 198001012005012001
   - Username: rina_dosen
   - Password: password123

2. **User Mahasiswa:**
   - Nama: Haris
   - Role: Mahasiswa
   - NIM / Prodi: 0041234567 / Sistem Informasi
   - Username: haris_mahasiswa
   - Password: password123

## Contoh Dart Dummy Data

```dart
final List<Map<String, dynamic>> dummyTasks = [
  {
    'title': 'Tugas Analisis Kebutuhan',
    'subject': 'Analisis & Desain Sistem',
    'lecturer': 'Bu Rina',
    'description': 'Buat laporan analisis kebutuhan sistem menggunakan diagram UML.',
    'givenDate': '03 Juni 2026',
    'deadline': '05 Juni 2026',
    'status': 'Belum Dikerjakan',
    'priority': 'Tinggi',
  },
  {
    'title': 'Implementasi UI Mobile',
    'subject': 'Pemrograman Mobile',
    'lecturer': 'Pak Andi',
    'description': 'Selesaikan slicing UI Dashboard sesuai referensi desain Figma.',
    'givenDate': '03 Juni 2026',
    'deadline': '07 Juni 2026',
    'status': 'Sedang Dikerjakan',
    'priority': 'Sedang',
  },
  {
    'title': 'Praktikum Komunikasi Data',
    'subject': 'Komunikasi Data',
    'lecturer': 'Bu Sari',
    'description': 'Konfigurasi topologi jaringan kantor menggunakan Cisco Packet Tracer.',
    'givenDate': '02 Juni 2026',
    'deadline': '06 Juni 2026',
    'status': 'Selesai',
    'priority': 'Tinggi',
  },
];
```

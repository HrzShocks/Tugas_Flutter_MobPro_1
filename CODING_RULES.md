# Coding Rules

## Framework

Gunakan Flutter.

## Scope

- Fokus UI dan navigasi.
- Jangan gunakan database.
- Jangan gunakan Firebase.
- Jangan gunakan API.
- Jangan gunakan state management kompleks.
- Gunakan StatefulWidget atau StatelessWidget biasa.
- Data berasal dari file `dummy_data.dart`.

## Struktur Folder Wajib

```text
lib/
├── main.dart
├── data/
│   └── dummy_data.dart
├── models/
│   └── task_model.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── main_screen.dart
│   ├── dashboard_screen.dart
│   ├── task_list_screen.dart
│   ├── task_detail_screen.dart
│   ├── task_form_screen.dart
│   ├── subject_screen.dart
│   ├── history_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── task_card.dart
│   ├── summary_card.dart
│   └── custom_text_field.dart
└── utils/
    └── app_colors.dart
```

## UI Rules

- Gunakan desain clean dan modern.
- Gunakan warna utama biru.
- Gunakan background abu muda atau putih.
- Gunakan Card untuk item tugas.
- Gunakan BottomNavigationBar.
- Gunakan FloatingActionButton di Task List.
- Gunakan padding yang konsisten.
- Hindari UI yang terlalu ramai.
- Gunakan icon bawaan Flutter Material Icons.

## Navigation Rules

- Splash Screen menuju Login Screen.
- Login Screen menuju Main Screen.
- Main Screen menggunakan BottomNavigationBar.
- Task List dapat membuka Task Detail Screen.
- Task List dapat membuka Task Form Screen.

## Package yang Diizinkan

Boleh gunakan:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1
  intl: ^0.19.0
```

Jangan gunakan pada tahap Mobpro 1:

```yaml
sqflite
firebase_core
cloud_firestore
provider
riverpod
dio
http
```

## Catatan

Jangan menaruh semua kode di `main.dart`. Pisahkan screen, widget, model, dan data dummy sesuai struktur folder.

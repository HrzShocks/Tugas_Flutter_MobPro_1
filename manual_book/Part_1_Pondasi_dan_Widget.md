### Title: Manual Book Bagian 1: Pondasi & Widget Kustom

Bagian ini membahas langkah awal persiapan proyek Flutter, pembuatan sistem tema dan warna, serta pembuatan widget kustom dasar yang akan digunakan di seluruh halaman aplikasi TugasKu.

---

# Struktur Folder Proyek TugasKu

Berikut adalah struktur folder dan file aplikasi TugasKu untuk mempermudah navigasi:

```text
lib
├── data
│   └── dummy_data.dart
├── models
│   └── task_model.dart
├── screens
│   ├── dashboard
│   │   └── dashboard_screen.dart
│   ├── edit_profile
│   │   └── edit_profile_screen.dart
│   ├── forgot_password
│   │   └── forgot_password_screen.dart
│   ├── history
│   │   └── history_screen.dart
│   ├── login
│   │   └── login_screen.dart
│   ├── main
│   │   └── main_screen.dart
│   ├── notification
│   │   └── notification_screen.dart
│   ├── onboarding
│   │   └── onboarding_screen.dart
│   ├── profile
│   │   └── profile_screen.dart
│   ├── register
│   │   └── register_screen.dart
│   ├── settings
│   │   └── settings_screen.dart
│   ├── splash
│   │   └── splash_screen.dart
│   ├── subject
│   │   └── subject_screen.dart
│   ├── subject_detail
│   │   └── subject_detail_screen.dart
│   ├── subject_form
│   │   └── subject_form_screen.dart
│   ├── task_detail
│   │   └── task_detail_screen.dart
│   ├── task_form
│   │   └── task_form_screen.dart
│   └── task_list
│       └── task_list_screen.dart
├── theme
│   └── theme_manager.dart
├── utils
│   ├── app_colors.dart
│   └── status_helpers.dart
├── widgets
│   ├── custom_text_field.dart
│   ├── discussion_sheet.dart
│   ├── neo_card.dart
│   ├── primary_button.dart
│   ├── status_badge.dart
│   ├── submission_list_sheet.dart
│   ├── summary_card.dart
│   └── task_card.dart
└── main.dart
```

---

# Bab 1: Persiapan Proyek & Dependensi

Bab ini mendokumentasikan proses inisiasi proyek Flutter baru dan mendaftarkan dependensi pihak ketiga serta aset lokal yang diperlukan.

## 1. Desain Tampilan
*(Tempatkan screenshot terminal saat menjalankan command pembuatan proyek dan flutter pub get di sini)*

## 2. Lokasi File
Buat perubahan pada file berikut:
- **Nama File:** `pubspec.yaml`
- **Lokasi:** `tugasku_flutter/pubspec.yaml`

## 3. Kode Sumber (Konfigurasi Aset & Dependensi)
Tambahkan dependensi `google_fonts` dan `intl` di bawah `dependencies`, serta aktifkan aset gambar logo di bawah konfigurasi `flutter`:

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

---

# Bab 2: Sistem Warna Aplikasi (AppColors)

Class ini mendefinisikan seluruh variabel warna (Design Token) yang digunakan secara terpusat untuk menjaga konsistensi UI.

## 1. Penjelasan Komponen
Berisi definisi kode warna hex untuk warna primer (biru), sekunder (ungu), warna latar belakang, warna teks, prioritas tugas, dan status tugas.

## 2. Lokasi File
- **Nama File:** `app_colors.dart`
- **Lokasi:** `lib/utils/app_colors.dart`

## 3. Kode Sumber (AppColors)
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Vibrant Blue & Purple Gradient
  static Color primary = const Color(0xFF3B82F6); // Bright Blue
  static Color primaryDark = const Color(0xFF1D4ED8);
  static Color primaryLight = const Color(0xFFEFF6FF); // Very light blue
  static Color secondary = const Color(0xFF8B5CF6); // Soft Purple
  
  // Background & Surface
  static Color background = const Color(0xFFF1F5F9); // Very light greyish blue
  static Color surface = const Color(0xFFFFFFFF); // White
  static Color surfaceGlass = const Color(0xB3FFFFFF); // White with 70% opacity for glassmorphism
  
  // Text Colors
  static Color textPrimary = const Color(0xFF0F172A); // Slate 900
  static Color textSecondary = const Color(0xFF475569); // Slate 600
  static Color textLight = const Color(0xFF94A3B8); // Slate 400

  // Status Colors (Soft yet clear)
  static Color statusBelum = const Color(0xFFEF4444); // Soft Red
  static Color statusProses = const Color(0xFFF59E0B); // Soft Amber
  static Color statusSelesai = const Color(0xFF10B981); // Soft Emerald

  // Priority Colors
  static Color priorityTinggi = const Color(0xFFFCA5A5); // Lighter Red
  static Color prioritySedang = const Color(0xFFFCD34D); // Lighter Amber
  static Color priorityRendah = const Color(0xFF93C5FD); // Lighter Blue

  // UI Elements
  static Color border = const Color(0xFFE2E8F0); // Slate 200
  static Color divider = const Color(0xFFF1F5F9); // Slate 100
  static Color shadowColor = const Color(0x1A0F172A); // Subtle dark slate shadow

  static void setLightMode() {
    primaryLight = const Color(0xFFEFF6FF);
    background = const Color(0xFFF1F5F9);
    surface = const Color(0xFFFFFFFF);
    surfaceGlass = const Color(0xB3FFFFFF);
    textPrimary = const Color(0xFF0F172A);
    textSecondary = const Color(0xFF475569);
    textLight = const Color(0xFF94A3B8);
    border = const Color(0xFFE2E8F0);
    divider = const Color(0xFFF1F5F9);
    shadowColor = const Color(0x1A0F172A);
  }

  static void setDarkMode() {
    primaryLight = const Color(0xFF1E293B); // Dark slate
    background = const Color(0xFF0F172A); // Very dark slate
    surface = const Color(0xFF1E293B); // Dark surface
    surfaceGlass = const Color(0xB31E293B); 
    textPrimary = const Color(0xFFF8FAFC); // Very light slate
    textSecondary = const Color(0xFFCBD5E1); // Light slate
    textLight = const Color(0xFF64748B); // Slate
    border = const Color(0xFF334155); // Dark border
    divider = const Color(0xFF334155);
    shadowColor = const Color(0x66000000); // Darker shadow
  }
}
```

---

# Bab 3: Tema Aplikasi & Entry Point

Mengonfigurasi tema global aplikasi (font Google Fonts Inter dan Outfit) serta menjalankan halaman awal.

## 1. Penjelasan Komponen
Mengintegrasikan tema global untuk `ThemeData` Material 3, mengaktifkan kustomisasi default `AppBarTheme`, `BottomNavigationBarTheme`, dan mengarahkan halaman default awal (`home`) ke halaman SplashScreen.

## 2. Lokasi File
- **Nama File:** `theme_manager.dart` (Lokasi: `lib/theme/theme_manager.dart`)
- **Nama File:** `main.dart` (Lokasi: `lib/main.dart`)

## 3. Kode Sumber

**theme_manager.dart**
```dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ThemeManager {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  static void toggle() {
    isDarkMode.value = !isDarkMode.value;
    if (isDarkMode.value) {
      AppColors.setDarkMode();
    } else {
      AppColors.setLightMode();
    }
  }
}
```

**main.dart**
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash/splash_screen.dart';
import 'utils/app_colors.dart';
import 'theme/theme_manager.dart';

void main() {
  runApp(const TugasKuApp());
}

class TugasKuApp extends StatelessWidget {
  const TugasKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager.isDarkMode,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          title: 'TugasKu',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              error: AppColors.statusBelum,
            ),
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
              iconTheme: IconThemeData(
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textLight,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
```

---

# Bab 4: Widget Kustom — Komponen Dasar

Membuat komponen UI yang dapat digunakan kembali di berbagai halaman aplikasi.

## 4.1 NeoCard (Kartu Bayangan)

### 1. Desain Tampilan
*(Tempatkan screenshot potongan kartu NeoCard di sini)*

### 2. Lokasi File
- **Nama File:** `neo_card.dart`
- **Lokasi:** `lib/widgets/neo_card.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow:  [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primary.withValues(alpha: 0.05),
          highlightColor: AppColors.primary.withValues(alpha: 0.02),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
```

---

## 4.2 CustomTextField (Input Form)

### 1. Desain Tampilan
*(Tempatkan screenshot input field di sini)*

### 2. Lokasi File
- **Nama File:** `custom_text_field.dart`
- **Lokasi:** `lib/widgets/custom_text_field.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
          validator: validator,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textLight,
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.textSecondary, size: 20)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.statusBelum, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.statusBelum, width: 1.5),
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.statusBelum,
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 4.3 PrimaryButton (Tombol Utama)

### 1. Desain Tampilan
*(Tempatkan screenshot tombol PrimaryButton di sini)*

### 2. Lokasi File
- **Nama File:** `primary_button.dart`
- **Lokasi:** `lib/widgets/primary_button.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? AppColors.primary).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 4.4 StatusBadge (Label Status)

### 1. Desain Tampilan
*(Tempatkan screenshot label status di sini)*

### 2. Lokasi File
- **Nama File:** `status_badge.dart`
- **Lokasi:** `lib/widgets/status_badge.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 4.5 SummaryCard (Statistik Dashboard)

### 1. Desain Tampilan
*(Tempatkan screenshot kartu ringkasan statistik di sini)*

### 2. Lokasi File
- **Nama File:** `summary_card.dart`
- **Lokasi:** `lib/widgets/summary_card.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color iconBgColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 16),
            // Value
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            // Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4.6 TaskCard (Daftar Item Tugas)

### 1. Desain Tampilan
*(Tempatkan screenshot satu baris kartu TugasCard di sini)*

### 2. Lokasi File
- **Nama File:** `task_card.dart`
- **Lokasi:** `lib/widgets/task_card.dart`

### 3. Kode Tampilan (UI Murni - Tanpa Logika Model)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../utils/status_helpers.dart';
import '../screens/task_detail/task_detail_screen.dart';
import '../data/dummy_data.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final String role;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = StatusHelpers.getPriorityColor(task.priority);
    final statusColor = StatusHelpers.getStatusColor(task.status);
    final displayStatus = StatusHelpers.getDisplayStatus(role, task.status, task.grade);
    
    // Find subject code for Guru
    final subject = dummySubjects.where((s) => s.name == task.subject).firstOrNull;
    final className = subject?.className ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap ?? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task, role: role),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject & Priority Pills
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.subject,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.priority,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: priorityColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          task.title,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Teacher / Subject Subtitle
                        if (role != 'Guru')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Guru: ${task.teacher}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Kelas: $className',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        // Dates & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Deadline Text
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.deadline,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    displayStatus,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

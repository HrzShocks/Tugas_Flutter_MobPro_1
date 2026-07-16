### Title: Manual Book Bagian 5: Riwayat, Profil & Pengaturan

Bagian ini membahas pembuatan halaman riwayat tugas yang telah selesai dikerjakan, halaman profil pengguna lengkap dengan statistik penyelesaian tugas, halaman edit data profil, serta halaman pengaturan/konfigurasi aplikasi.

---

# Bab 16: Tampilan Riwayat Tugas

Halaman yang memuat daftar seluruh tugas yang statusnya telah ditandai selesai oleh sistem atau guru.

## 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Riwayat Tugas di sini)*

## 2. Lokasi File
- **Nama File:** `history_screen.dart`
- **Lokasi:** `lib/screens/history/history_screen.dart`

## 3. Kode Tampilan (UI Murni - Menggunakan Data Hardcoded)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/status_badge.dart';
import '../../data/dummy_data.dart';
import '../task_detail/task_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final String role;
  const HistoryScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isSiswa = role == 'Siswa';
    final currentTeacherName = dummyTeacherProfile.fullName;
    
    // Role based base tasks
    final baseTasks = isSiswa 
        ? dummyTasks.where((t) => t.className == 'X MIPA 1' || t.className == 'UMUM').toList()
        : dummyTasks.where((t) => t.teacher == currentTeacherName).toList();

    final historyTasks = baseTasks.where((t) => t.status == 'Selesai').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Tugas'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        itemCount: historyTasks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final task = historyTasks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(
                    task: task,
                    role: role,
                  ),
                ),
              );
            },
            child: NeoCard(
              padding: const EdgeInsets.all(20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    StatusBadge(
                      text: 'Selesai', 
                      color: AppColors.statusSelesai,
                      icon: Icons.check_circle_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.subject,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }
}
```

---

# Bab 17: Tampilan Profil & Edit Profil

Bagian ini membahas halaman ringkasan data diri pengguna serta formulir pengubahan informasi profil.

## 17.1 Halaman Profil

### 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Profil di sini)*

### 2. Lokasi File
- **Nama File:** `profile_screen.dart`
- **Lokasi:** `lib/screens/profile/profile_screen.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/primary_button.dart';
import '../../data/dummy_data.dart';
import '../login/login_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../../theme/theme_manager.dart';
import '../../utils/status_helpers.dart';

class ProfileScreen extends StatefulWidget {
  final String role;
  const ProfileScreen({super.key, required this.role});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isSiswa = widget.role == 'Siswa';
    final userProfile = isSiswa ? dummyStudentProfile : dummyTeacherProfile;
    final name = userProfile.name;
    final idInfo = userProfile.id;

    final currentTeacherName = dummyTeacherProfile.fullName;

    // Role based base tasks
    final baseTasks = isSiswa
        ? dummyTasks.where((t) => t.className == 'X MIPA 1' || t.className == 'UMUM').toList()
        : dummyTasks.where((t) => t.teacher == currentTeacherName).toList();

    // Calculate stats
    final totalTasks = baseTasks.length;
    final tepatWaktu = baseTasks.where((t) => t.status == 'Selesai').length;
    final terlambat = baseTasks.where((t) => 
      t.status == 'Selesai (Terlambat)' || 
      (t.status == 'Belum Dikerjakan' && StatusHelpers.isLate(t.deadline))
    ).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              // Navigate to EditProfileScreen and await result
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    profile: userProfile,
                    role: widget.role,
                  ),
                ),
              );
              // Refresh state after returning
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSiswa
                          ? Icons.face_rounded
                          : Icons.workspace_premium_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.role,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    idInfo,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile.university,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (userProfile.major != null && userProfile.major!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      userProfile.major!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Stats
            NeoCard(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total', '$totalTasks', AppColors.primary),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _buildStatItem(
                    'Tepat Waktu',
                    '$tepatWaktu',
                    AppColors.statusSelesai,
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _buildStatItem(
                    'Terlambat',
                    '$terlambat',
                    AppColors.statusBelum,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section: Tampilan
            _buildSectionTitle('Tampilan'),
            ValueListenableBuilder<bool>(
              valueListenable: ThemeManager.isDarkMode,
              builder: (context, isDarkMode, _) {
                return _buildSwitchTile(
                  title: 'Mode Gelap',
                  subtitle: 'Gunakan tema gelap',
                  icon: Icons.dark_mode_outlined,
                  value: isDarkMode,
                  onChanged: (val) {
                    ThemeManager.toggle();
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Section: Akun & Lainnya
            _buildSectionTitle('Lainnya'),
            _buildMenuTile(
              title: 'Bahasa',
              subtitle: 'Indonesia',
              icon: Icons.language_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saat ini hanya mendukung Bahasa Indonesia'),
                  ),
                );
              },
            ),
            _buildMenuTile(
              title: 'Bantuan',
              subtitle: 'Pusat bantuan & FAQ',
              icon: Icons.help_outline_rounded,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: Text(
                      'Pusat Bantuan',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jika Anda mengalami kendala, silakan hubungi layanan bantuan kami:',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.message_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'WhatsApp: 0812-3456-7890',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.email_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Email: support@bsi.ac.id',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Senin - Jumat (08:00 - 17:00)',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'TUTUP',
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildMenuTile(
              title: 'Tentang Aplikasi',
              subtitle: 'Versi 1.0.0',
              icon: Icons.info_outline_rounded,
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'TugasKu',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      '© 2026 SMA Negeri 1 Jakarta',
                );
              },
            ),

            const SizedBox(height: 32),
            PrimaryButton(
              text: 'KELUAR',
              color: Colors.redAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    title: Text(
                      'Konfirmasi',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    content: Text(
                      'Apakah Anda yakin ingin keluar dari aplikasi?',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'BATAL',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.statusBelum,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'KELUAR',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
```

---

## 17.2 Edit Profil

### 1. Desain Tampilan
*(Tempatkan screenshot halaman Edit Profil di sini)*

### 2. Lokasi File
- **Nama File:** `edit_profile_screen.dart`
- **Lokasi:** `lib/screens/edit_profile/edit_profile_screen.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final String role;

  const EditProfileScreen({super.key, required this.profile, required this.role});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _degreeController;
  late TextEditingController _idController;
  late TextEditingController _univController;
  late TextEditingController _majorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _degreeController = TextEditingController(text: widget.profile.degree ?? '');
    _idController = TextEditingController(text: widget.profile.id);
    _univController = TextEditingController(text: widget.profile.university);
    _majorController = TextEditingController(text: widget.profile.major ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _degreeController.dispose();
    _idController.dispose();
    _univController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Update the profile object
    widget.profile.name = _nameController.text.trim();
    widget.profile.degree = _degreeController.text.trim();
    widget.profile.id = _idController.text.trim();
    widget.profile.university = _univController.text.trim();
    widget.profile.major = _majorController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil berhasil diperbarui'),
        backgroundColor: AppColors.statusSelesai,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isSiswa = widget.role == 'Siswa';
    final idLabel = isSiswa ? 'NISN' : 'NIP';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        _nameController.text.isNotEmpty 
                            ? _nameController.text[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.outfit(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                      child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              hint: 'Masukkan nama Anda',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 20),
            if (!isSiswa) ...[
              CustomTextField(
                controller: _degreeController,
                label: 'Gelar Akademik (Opsional)',
                hint: 'Contoh: S.Kom., M.T.',
                icon: Icons.school_outlined,
              ),
              const SizedBox(height: 20),
            ],
            CustomTextField(
              controller: _idController,
              label: idLabel,
              hint: 'Masukkan $idLabel Anda',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _univController,
              label: 'Sekolah',
              hint: 'Masukkan nama sekolah',
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _majorController,
              label: 'Jurusan',
              hint: 'Masukkan jurusan Anda',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: 'SIMPAN PROFIL',
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

# Bab 18: Tampilan Pengaturan

Halaman pusat konfigurasi preferensi sistem aplikasi seperti pemilihan Dark Mode/Light Mode.

## 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Pengaturan di sini)*

## 2. Lokasi File
- **Nama File:** `settings_screen.dart`
- **Lokasi:** `lib/screens/settings/settings_screen.dart`

## 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../theme/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle('Tampilan'),
          ValueListenableBuilder<bool>(
            valueListenable: ThemeManager.isDarkMode,
            builder: (context, isDarkMode, _) {
              return _buildSwitchTile(
                title: 'Mode Gelap',
                subtitle: 'Gunakan tema gelap',
                icon: Icons.dark_mode_outlined,
                value: isDarkMode,
                onChanged: (val) {
                  ThemeManager.toggle();
                },
              );
            }
          ),
          const SizedBox(height: 24),
          

          
          _buildSectionTitle('Akun & Lainnya'),
          _buildListTile(
            title: 'Bahasa',
            subtitle: 'Indonesia',
            icon: Icons.language_rounded,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saat ini hanya mendukung Bahasa Indonesia')),
              );
            },
          ),
          _buildListTile(
            title: 'Bantuan',
            subtitle: 'Pusat bantuan & FAQ',
            icon: Icons.help_outline_rounded,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: Text('Pusat Bantuan', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  content: Text('Silakan hubungi admin sekolah Anda apabila mengalami kendala aplikasi.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('TUTUP', style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.bold)))
                  ],
                ),
              );
            },
          ),
          _buildListTile(
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            icon: Icons.info_outline_rounded,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'TugasKu',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 SMA Negeri 1 Jakarta',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textLight),
      ),
    );
  }
}
```

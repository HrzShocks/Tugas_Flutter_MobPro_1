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

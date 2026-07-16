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

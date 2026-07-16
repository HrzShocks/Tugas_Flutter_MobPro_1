import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  final String role;
  NotificationScreen({super.key, required this.role});

  final List<Map<String, dynamic>> dummySiswaNotifications = [
    {
      'title': 'Tenggat Waktu Mendekat!',
      'description': 'Tugas "Desain UI" dari mata pelajaran Fisika harus dikumpulkan besok.',
      'time': '2 jam yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Tugas Dinilai',
      'description': 'Tugas "Diagram UML" Anda telah dinilai oleh Bu Rina. Anda mendapat nilai 85.',
      'time': '5 jam yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Materi Baru Ditambahkan',
      'description': 'Pak Budi menambahkan materi baru untuk Kimia.',
      'time': '1 hari yang lalu',
      'isUnread': false,
    },
    {
      'title': 'Tugas Baru',
      'description': 'Tugas baru ditambahkan untuk mata pelajaran Biologi.',
      'time': '2 hari yang lalu',
      'isUnread': false,
    },
  ];

  final List<Map<String, dynamic>> dummyGuruNotifications = [
    {
      'title': 'Tugas Baru Terkumpul',
      'description': 'Budi Santoso baru saja mengumpulkan tugas "Desain UI" pada mata pelajaran Fisika.',
      'time': '10 menit yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Pertanyaan Siswa',
      'description': 'Siti Aminah bertanya mengenai materi Kimia bab 3.',
      'time': '1 jam yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Tenggat Waktu Berakhir',
      'description': 'Batas waktu pengumpulan tugas "Diagram UML" telah berakhir.',
      'time': '3 jam yang lalu',
      'isUnread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final notifications = role == 'Siswa' ? dummySiswaNotifications : dummyGuruNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final isUnread = notif['isUnread'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnread ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnread ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUnread ? AppColors.primary : AppColors.surface,
                    shape: BoxShape.circle,
                    border: isUnread ? null : Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: isUnread ? Colors.white : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'] as String,
                        style: GoogleFonts.inter(
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['description'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/task_card.dart';
import '../../data/dummy_data.dart';
import '../settings/settings_screen.dart';
import '../notification/notification_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isSiswa = role == 'Siswa';
    final userProfile = isSiswa ? dummyStudentProfile : dummyTeacherProfile;
    final name = userProfile.name;
    final currentTeacherName = dummyTeacherProfile.fullName;

    // Role based base tasks
    final baseTasks = isSiswa 
        ? dummyTasks.where((t) => t.className == 'X MIPA 1' || t.className == 'UMUM').toList()
        : dummyTasks.where((t) => t.teacher == currentTeacherName).toList();

    // Calculate stats
    final totalTasks = baseTasks.length;
    final selesaiTasks = baseTasks.where((t) => t.status == 'Selesai').length;
    final prosesTasks = baseTasks.where((t) => t.status == 'Sedang Dikerjakan' || t.status == 'Proses').length;
    final belumTasks = totalTasks - selesaiTasks - prosesTasks;

    // Priority logic
    final priorityTasks = baseTasks.where((t) => t.status != 'Selesai').toList();
    priorityTasks.sort((a, b) {
      int getPriorityWeight(String p) {
        if (p == 'Tinggi') return 3;
        if (p == 'Sedang') return 2;
        if (p == 'Rendah') return 1;
        return 0;
      }
      return getPriorityWeight(b.priority).compareTo(getPriorityWeight(a.priority));
    });

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $name 👋',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSiswa 
                        ? 'Siap menyelesaikan tugas hari ini?' 
                        : 'Siap memantau tugas siswa?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(role: role)));
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Summary Cards Responsive
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Tugas', 
                    '$totalTasks', 
                    Icons.assignment_rounded, 
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    isSiswa ? 'Belum Selesai' : 'Tugas Aktif', 
                    '${belumTasks + prosesTasks}', 
                    Icons.hourglass_empty_rounded, 
                    AppColors.statusProses,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    isSiswa ? 'Selesai' : 'Tugas Selesai', 
                    '$selesaiTasks', 
                    Icons.check_circle_rounded, 
                    AppColors.statusSelesai,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isSiswa ? 'Tugas Prioritas' : 'Tugas Berjalan',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Buka tab Daftar Tugas untuk melihat semua')),
                    );
                  },
                  child: Text(
                    'Lihat Semua',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task List Listview
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: priorityTasks.length > 3 ? 3 : priorityTasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return TaskCard(task: priorityTasks[index], role: role);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

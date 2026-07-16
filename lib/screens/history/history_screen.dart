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

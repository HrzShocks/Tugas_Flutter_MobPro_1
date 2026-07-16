import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

import '../../utils/status_helpers.dart';

import '../../models/task_model.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/discussion_sheet.dart';
import '../../widgets/submission_list_sheet.dart';
import '../task_form/task_form_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;
  final String role;
  
  const TaskDetailScreen({super.key, required this.task, required this.role});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  void _showSubmitDialog() {
    final linkController = TextEditingController(text: widget.task.submissionLink);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unggah Tugas',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan tautan (link) Google Drive atau GitHub tugas Anda.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: linkController,
                label: 'Tautan Tugas',
                hint: 'https://...',
                icon: Icons.link_rounded,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'KUMPULKAN TUGAS',
                onPressed: () {
                  if (linkController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tautan tugas tidak boleh kosong'),
                        backgroundColor: AppColors.statusBelum,
                      ),
                    );
                    return;
                  }
                  setState(() {
                    widget.task.status = 'Selesai';
                    widget.task.submissionLink = linkController.text.trim();
                    widget.task.submittedDate = 'Bulan Ini, 10:00 WIB'; // Simulasi waktu sekarang
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tugas berhasil dikumpulkan!'),
                      backgroundColor: AppColors.statusSelesai,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    Color statusColor = StatusHelpers.getStatusColor(widget.task.status);
    Color priorityColor = StatusHelpers.getPriorityColor(widget.task.priority);
    final isSiswa = widget.role == 'Siswa';
    final isDone = widget.task.status == 'Selesai';
    final displayStatus = StatusHelpers.getDisplayStatus(widget.role, widget.task.status, widget.task.grade);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(text: displayStatus, color: statusColor),
            const SizedBox(height: 16),
            Text(
              widget.task.title,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task.subject,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.person_outline_rounded, 'Guru', widget.task.teacher),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.divider, height: 1),
                  ),
                  _buildInfoRow(Icons.event_note_rounded, 'Diberikan', widget.task.givenDate),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.divider, height: 1),
                  ),
                  _buildInfoRow(Icons.event_available_rounded, 'Tenggat Waktu', widget.task.deadline),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.divider, height: 1),
                  ),
                  _buildInfoRow(Icons.flag_outlined, 'Prioritas', widget.task.priority, 
                    valueColor: priorityColor),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Text(
              'Deskripsi Tugas',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.task.description,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Discussion Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.forum_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ruang Diskusi',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.task.comments.isEmpty
                              ? 'Belum ada diskusi'
                              : '${widget.task.comments.length} Pesan diskusi',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => DiscussionSheet(
                          task: widget.task,
                          role: widget.role,
                        ),
                      ).then((_) {
                        // Refresh to show updated comment count
                        setState(() {});
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Buka'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            if (isSiswa) ...[
              if (!isDone)
                PrimaryButton(
                  text: 'UNGGAH TUGAS',
                  onPressed: _showSubmitDialog,
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.statusSelesai.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.statusSelesai.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppColors.statusSelesai, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'TUGAS SUDAH DIKUMPULKAN',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: AppColors.statusSelesai,
                            ),
                          ),
                        ],
                      ),
                      if (widget.task.submissionLink != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Tautan Tugas:',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.task.submissionLink!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        if (widget.task.submittedDate != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Waktu Pengumpulan:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.task.submittedDate!,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                      if (widget.task.grade == null) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showSubmitDialog,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'EDIT PENGUMPULAN',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                widget.task.grade!,
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nilai Akhir',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (widget.task.feedback != null && widget.task.feedback!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      '"${widget.task.feedback!}"',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskFormScreen(taskToEdit: widget.task),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'EDIT TUGAS',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: PrimaryButton(
                        text: 'LIHAT PENGUMPULAN',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => SubmissionListSheet(task: widget.task),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

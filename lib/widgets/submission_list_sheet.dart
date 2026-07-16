import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../models/task_model.dart';
import '../data/dummy_data.dart';
import '../utils/status_helpers.dart';
import 'custom_text_field.dart';
import 'primary_button.dart';

class StudentSubmission {
  final UserProfile student;
  String status;
  String? submissionLink;
  String? submittedDate;
  String? grade;

  StudentSubmission({
    required this.student,
    required this.status,
    this.submissionLink,
    this.submittedDate,
    this.grade,
  });
}

class SubmissionListSheet extends StatefulWidget {
  final TaskModel task;

  const SubmissionListSheet({super.key, required this.task});

  @override
  State<SubmissionListSheet> createState() => _SubmissionListSheetState();
}

class _SubmissionListSheetState extends State<SubmissionListSheet> {
  late List<StudentSubmission> _submissions;

  @override
  void initState() {
    super.initState();
    _initializeSubmissions();
  }

  void _initializeSubmissions() {
    _submissions = dummyStudents.map((student) {
      if (student.name == dummyStudentProfile.name) {
        // Haris's real data
        return StudentSubmission(
          student: student,
          status: widget.task.status,
          submissionLink: widget.task.submissionLink,
          submittedDate: widget.task.submittedDate,
          grade: widget.task.grade,
        );
      } else {
        // Dummy data for other students
        // Create a pseudo-random but deterministic status based on name length
        final isDone = student.name.length % 2 == 0;
        final isGraded = isDone && student.name.length % 3 == 0;
        
        String dummyStatus = 'Belum Dikerjakan';
        String? dummySubmittedDate;
        if (isDone) {
          final isTaskPastDeadline = StatusHelpers.isLate(widget.task.deadline);
          if (isTaskPastDeadline) {
            final lastDigitStr = student.id.substring(student.id.length - 1);
            final lastDigit = int.tryParse(lastDigitStr) ?? 0;
            final submittedLate = lastDigit % 2 == 0; 
            dummyStatus = submittedLate ? 'Selesai (Terlambat)' : 'Selesai';
            dummySubmittedDate = submittedLate ? '07 Juni 2026, 10:00 WIB' : '05 Juni 2026, 08:00 WIB';
          } else {
            dummyStatus = 'Selesai';
            dummySubmittedDate = '03 Juni 2026, 08:00 WIB';
          }
        }
        
        return StudentSubmission(
          student: student,
          status: dummyStatus,
          submissionLink: isDone ? 'https://google.com/drive/${student.name.replaceAll(' ', '').toLowerCase()}' : null,
          submittedDate: dummySubmittedDate,
          grade: isGraded ? '85' : null,
        );
      }
    }).toList();
  }

  void _showGradingDialog(StudentSubmission submission) {
    final gradeController = TextEditingController(text: submission.grade);
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beri Nilai: ${submission.student.name}',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              if (submission.submissionLink != null) ...[
                Text(
                  'Tautan Tugas:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  submission.submissionLink!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                controller: gradeController,
                label: 'Nilai (0-100)',
                hint: 'Contoh: 85',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: feedbackController,
                label: 'Umpan Balik (Opsional)',
                hint: 'Contoh: Pekerjaan sudah bagus',
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'SIMPAN NILAI',
                onPressed: () {
                  setState(() {
                    submission.grade = gradeController.text.trim();
                    if (submission.student.name == dummyStudentProfile.name) {
                      widget.task.grade = submission.grade;
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nilai berhasil disimpan'),
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
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.people_alt_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daftar Pengumpulan',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${_submissions.where((s) => s.status == 'Selesai').length} dari ${_submissions.length} siswa',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  itemCount: _submissions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final submission = _submissions[index];
                    final isDone = submission.status.contains('Selesai');
                    final isLate = submission.status == 'Selesai (Terlambat)';
                    
                    return InkWell(
                      onTap: isDone ? () => _showGradingDialog(submission) : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                submission.student.name[0],
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
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
                                    submission.student.name,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    submission.student.id,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (submission.submissionLink != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.link_rounded, size: 12, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            submission.submissionLink!,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              decoration: TextDecoration.underline,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (submission.submittedDate != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded, size: 12, color: AppColors.textSecondary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            submission.submittedDate!,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (isDone) ...[
                              if (submission.grade != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    submission.grade!,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.statusProses.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.statusProses.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    'Nilai',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.statusProses,
                                    ),
                                  ),
                                ),
                              if (isLate) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.statusBelum.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Terlambat',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.statusBelum,
                                    ),
                                  ),
                                ),
                              ],
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.statusBelum.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Belum',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.statusBelum,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

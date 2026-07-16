import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/custom_text_field.dart';
import '../../data/dummy_data.dart';
import '../../models/task_model.dart';
import '../subject_form/subject_form_screen.dart';
import '../subject_detail/subject_detail_screen.dart';

class SubjectScreen extends StatefulWidget {
  final String role;
  const SubjectScreen({super.key, required this.role});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final _joinCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = '';

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  void _showJoinClassDialog() {
    _joinCodeController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Gabung Kelas Baru',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Form(
            key: _formKey,
            child: CustomTextField(
              controller: _joinCodeController,
              label: 'Kode Kelas',
              hint: 'Contoh: x7qz9b',
              icon: Icons.vpn_key_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Kode kelas tidak boleh kosong';
                }
                return null;
              },
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
                if (_formKey.currentState!.validate()) {
                  final code = _joinCodeController.text.trim().toUpperCase();

                  // Check if already joined
                  final alreadyJoined = dummySubjects.any(
                    (s) => s.code.toUpperCase() == code,
                  );

                  if (alreadyJoined) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Anda sudah bergabung di kelas dengan kode "$code"',
                        ),
                        backgroundColor: AppColors.statusBelum,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                    return;
                  }

                  // Simulated class names mapping for some codes, otherwise generate dynamically
                  String subjectName = 'Mata Pelajaran Baru';
                  String teacherName = 'Guru Baru';

                  if (code == 'x7qz9b'.toUpperCase()) {
                    subjectName = 'Matematika';
                    teacherName = 'Fuad, S.Pd.';
                  } else if (code == 'm4k2lp'.toUpperCase()) {
                    subjectName = 'Fisika';
                    teacherName = 'Andi, S.Pd.';
                  } else if (code == 'z8xw1q'.toUpperCase()) {
                    subjectName = 'Biologi';
                    teacherName = 'Sari, S.Pd., M.Si.';
                  } else {
                    // Generate based on code
                    subjectName = 'Mata Pelajaran ($code)';
                    teacherName = 'Guru Pengampu';
                  }

                  setState(() {
                    dummySubjects.add(
                      SubjectModel(
                        name: subjectName,
                        teacher: teacherName,
                        code: code,
                        className: 'UMUM',
                        createdBy: teacherName,
                        major: 'Umum',
                      ),
                    );
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Berhasil bergabung ke kelas "$subjectName"',
                      ),
                      backgroundColor: AppColors.statusSelesai,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'GABUNG',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSiswa = widget.role == 'Siswa';
    final currentTeacherName = dummyTeacherProfile.fullName;

    // Filter subjects for Guru
    final displaySubjects = isSiswa
        ? dummySubjects
              .where((s) => s.className == 'X MIPA 1' || s.className == 'UMUM')
              .toList()
        : dummySubjects
              .where((s) => s.createdBy == currentTeacherName)
              .toList();

    final filteredSubjects = displaySubjects.where((s) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return s.name.toLowerCase().contains(query) ||
          s.code.toLowerCase().contains(query) ||
          s.className.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mata Pelajaran')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Above bottom nav
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (isSiswa) {
              _showJoinClassDialog();
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubjectFormScreen(),
                ),
              );
              setState(() {}); // Refresh list when returning from form
            }
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: Icon(
            isSiswa ? Icons.vpn_key_rounded : Icons.add_rounded,
            color: Colors.white,
          ),
          label: Text(
            isSiswa ? 'GABUNG KELAS' : 'TAMBAH MATA PELAJARAN',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: GoogleFonts.inter(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Cari mata pelajaran, kelas, kode...',
                  hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
                  border: InputBorder.none,
                  icon: Icon(Icons.search_rounded, color: AppColors.primary),
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredSubjects.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada mata pelajaran ditemukan',
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    itemCount: filteredSubjects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final subject = filteredSubjects[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectDetailScreen(
                                subject: subject,
                                role: widget.role,
                              ),
                            ),
                          );
                        },
                        child: NeoCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.class_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subject.name,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_rounded,
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isSiswa
                                              ? 'Guru: ${subject.teacher}'
                                              : '${dummyTasks.where((t) => t.subject == subject.name && t.className == subject.className).length} Tugas',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!isSiswa) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.vpn_key_rounded,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Kode Mapel: ${subject.code}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.meeting_room_rounded,
                                          size: 14,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Kelas: ${subject.className}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!isSiswa) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.school_rounded,
                                            size: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Jurusan: ${subject.major}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.border,
                              ),
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
  }
}

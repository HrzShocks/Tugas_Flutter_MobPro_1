### Title: Manual Book Bagian 4: Detail Tugas & Mata Pelajaran

Bagian ini membahas pembuatan halaman detail tugas kuliah, formulir tambah/edit tugas (khusus guru), komponen diskusi chat, daftar pengumpulan tugas siswa, serta halaman terkait mata pelajaran (daftar, detail kelas, dan form tambah mapel).

---

# Bab 14: Tampilan Detail Tugas & Form Tugas

Bagian ini memuat detail informasi satu tugas, form input pembuatan tugas baru, ruang diskusi chat (bottom sheet), dan daftar status pengumpulan tugas siswa (khusus guru).

## 14.1 Detail Tugas

### 1. Desain Tampilan
*(Tempatkan screenshot penuh Detail Tugas (Guru dan Siswa) di sini)*

### 2. Lokasi File
- **Nama File:** `task_detail_screen.dart`
- **Lokasi:** `lib/screens/task_detail/task_detail_screen.dart`

### 3. Kode Tampilan (UI Murni - Tanpa Logika State)
```dart
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
```

---

## 14.2 Form Tambah Tugas (Guru)

### 1. Desain Tampilan
*(Tempatkan screenshot halaman Form Tambah/Edit Tugas di sini)*

### 2. Lokasi File
- **Nama File:** `task_form_screen.dart`
- **Lokasi:** `lib/screens/task_form/task_form_screen.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../data/dummy_data.dart';
import '../../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? taskToEdit;

  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();

  String? _selectedSubjectCode;
  String _selectedPriority = 'Tinggi';

  final List<String> _priorityList = ['Tinggi', 'Sedang', 'Rendah'];

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _deadlineController.text = widget.taskToEdit!.deadline;
      try {
        final subjectObj = dummySubjects.firstWhere(
          (s) => s.name == widget.taskToEdit!.subject && s.className == widget.taskToEdit!.className,
        );
        _selectedSubjectCode = subjectObj.code;
      } catch (e) {
        _selectedSubjectCode = null;
      }
      _selectedPriority = widget.taskToEdit!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _deadlineController.text =
            "${picked.day.toString().padLeft(2, '0')} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSubjectCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Silakan pilih mata pelajaran terlebih dahulu',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.statusBelum,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Handle Create vs Update
      final currentTeacher = dummyTeacherProfile.fullName;
      setState(() {
        if (widget.taskToEdit != null) {
          // Update existing
          widget.taskToEdit!.title = _titleController.text.trim();
          final subj = dummySubjects.firstWhere((s) => s.code == _selectedSubjectCode);
          widget.taskToEdit!.subject = subj.name;
          widget.taskToEdit!.className = subj.className;
          widget.taskToEdit!.description = _descriptionController.text.trim();
          widget.taskToEdit!.deadline = _deadlineController.text.trim();
          widget.taskToEdit!.priority = _selectedPriority;
        } else {
          // Add new to dummy tasks
          final subj = dummySubjects.firstWhere((s) => s.code == _selectedSubjectCode);
          dummyTasks.add(
            TaskModel(
              title: _titleController.text.trim(),
              subject: subj.name,
              className: subj.className,
              teacher: currentTeacher,
              description: _descriptionController.text.trim(),
              givenDate: DateTime.now().toString().substring(0, 10), // Simplified
              deadline: _deadlineController.text.trim(),
              status: 'Belum Dikerjakan',
              priority: _selectedPriority,
            ),
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data tugas berhasil disimpan',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.statusSelesai,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTeacher = dummyTeacherProfile.fullName;
    final teacherSubjects = dummySubjects.where((s) => s.createdBy == currentTeacher).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit != null ? 'Edit Tugas' : 'Tambah Tugas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Judul Tugas',
                hint: 'Contoh: Praktikum Gerak Lurus',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tugas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Dropdown Mata Pelajaran
              Text(
                'Mata Pelajaran',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedSubjectCode,
                    hint: Text(
                      'Pilih Mata Pelajaran',
                      style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 15),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    items: teacherSubjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject.code,
                        child: Text(
                          '${subject.name} - ${subject.className}',
                          style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedSubjectCode = val;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Custom Text Area for Description
              Text(
                'Deskripsi',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Tulis detail deskripsi tugas...',
                  hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 15),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.all(16),
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
              const SizedBox(height: 20),
              
              _buildDropdown(
                'Prioritas',
                _selectedPriority,
                _priorityList,
                (val) => setState(() => _selectedPriority = val!),
              ),
              const SizedBox(height: 20),
              
              // Date picker field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _deadlineController,
                    label: 'Tenggat Waktu',
                    hint: 'Pilih Tanggal',
                    icon: Icons.calendar_today_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tenggat waktu tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'SIMPAN TUGAS',
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Column(
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 14.3 Ruang Diskusi (Discussion Sheet)

### 1. Desain Tampilan
*(Tempatkan screenshot bottom sheet Ruang Diskusi di sini)*

### 2. Lokasi File
- **Nama File:** `discussion_sheet.dart`
- **Lokasi:** `lib/widgets/discussion_sheet.dart`

### 3. Kode Tampilan (UI Murni - Dengan Bubble Chat Mockup)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../data/dummy_data.dart'; // To get dummy profiles

class DiscussionSheet extends StatefulWidget {
  final TaskModel task;
  final String role; // Current user's role

  const DiscussionSheet({
    super.key,
    required this.task,
    required this.role,
  });

  @override
  State<DiscussionSheet> createState() => _DiscussionSheetState();
}

class _DiscussionSheetState extends State<DiscussionSheet> {
  final _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    
    // Determine author name based on role
    String authorName = '';
    if (widget.role == 'Siswa') {
      authorName = '${dummyStudentProfile.name} (Siswa)';
    } else {
      authorName = dummyTeacherProfile.fullName;
    }

    setState(() {
      widget.task.comments.add(
        CommentModel(
          author: authorName,
          role: widget.role,
          text: text,
          timestamp: timeString,
        ),
      );
      _commentController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ruang Diskusi',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Chat List
          Expanded(
            child: widget.task.comments.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada diskusi.\nMulai percakapan!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.textLight,
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    itemCount: widget.task.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.task.comments[index];
                      final isMe = comment.role == widget.role;
                      final isTeacher = comment.role == 'Guru';

                      return _buildChatBubble(comment, isMe, isTeacher);
                    },
                  ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16).copyWith(
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendComment(),
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      hintStyle: GoogleFonts.inter(color: AppColors.textLight, fontSize: 15),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendComment,
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(CommentModel comment, bool isMe, bool isTeacher) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                comment.author,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isTeacher ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              if (isTeacher) ...[
                const SizedBox(width: 4),
                Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              border: isMe ? null : Border.all(color: AppColors.border),
            ),
            child: Text(
              comment.text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isMe ? Colors.white : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comment.timestamp,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 14.4 Daftar Pengumpulan Tugas (Guru)

### 1. Desain Tampilan
*(Tempatkan screenshot bottom sheet Daftar Pengumpulan Tugas di sini)*

### 2. Lokasi File
- **Nama File:** `submission_list_sheet.dart`
- **Lokasi:** `lib/widgets/submission_list_sheet.dart`

### 3. Kode Tampilan (UI Murni)
```dart
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
```

---

# Bab 15: Tampilan Halaman Mata Pelajaran

Bagian ini membahas daftar kelas/mata pelajaran yang diikuti, detail masing-masing kelas, serta form tambah mata pelajaran (khusus guru).

## 15.1 Daftar Mata Pelajaran

### 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Mata Pelajaran di sini)*

### 2. Lokasi File
- **Nama File:** `subject_screen.dart`
- **Lokasi:** `lib/screens/subject/subject_screen.dart`

### 3. Kode Tampilan (UI Murni)
```dart
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
                    (s) => s.code.toUpperCase() == code
                  );

                  if (alreadyJoined) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Anda sudah bergabung di kelas dengan kode "$code"'),
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
                      SubjectModel(name: subjectName, teacher: teacherName, code: code, className: 'UMUM', createdBy: teacherName, major: 'Umum'),
                    );
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil bergabung ke kelas "$subjectName"'),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        ? dummySubjects.where((s) => s.className == 'X MIPA 1' || s.className == 'UMUM').toList()
        : dummySubjects.where((s) => s.createdBy == currentTeacherName).toList();

    final filteredSubjects = displaySubjects.where((s) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return s.name.toLowerCase().contains(query) ||
             s.code.toLowerCase().contains(query) ||
             s.className.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Pelajaran'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Above bottom nav
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (isSiswa) {
              _showJoinClassDialog();
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubjectFormScreen()),
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
            isSiswa ? 'GABUNG KELAS' : 'TAMBAH MATA KULIAH',
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
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                              child: const Icon(Icons.class_rounded, color: Colors.white),
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
                                      Icon(Icons.person_rounded, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        isSiswa ? 'Guru: ${subject.teacher}' : '${dummyTasks.where((t) => t.subject == subject.name && t.className == subject.className).length} Tugas',
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
                                        Icon(Icons.vpn_key_rounded, size: 14, color: AppColors.primary),
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
                                      Icon(Icons.meeting_room_rounded, size: 14, color: AppColors.primary),
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
                                        Icon(Icons.school_rounded, size: 14, color: AppColors.textSecondary),
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
                            Icon(Icons.chevron_right_rounded, color: AppColors.border),
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
```

---

## 15.2 Detail Mata Pelajaran

### 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Detail Mata Pelajaran di sini)*

### 2. Lokasi File
- **Nama File:** `subject_detail_screen.dart`
- **Lokasi:** `lib/screens/subject_detail/subject_detail_screen.dart`

## 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../models/task_model.dart';
import '../../data/dummy_data.dart';
import '../../widgets/task_card.dart';

class SubjectDetailScreen extends StatefulWidget {
  final SubjectModel subject;
  final String role;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
    required this.role,
  });

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.role == 'Guru' ? 3 : 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSiswa = widget.role == 'Siswa';
    final subjectTasks = dummyTasks
        .where((t) => t.subject == widget.subject.name && t.className == widget.subject.className)
        .toList();
    final activeTasks = subjectTasks.where((t) => t.status == 'Belum Dikerjakan').toList();
    final finishedTasks = subjectTasks.where((t) => t.status == 'Selesai' || t.status == 'Selesai (Terlambat)').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Pelajaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.class_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.subject.name,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Guru: ${widget.subject.teacher}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (!isSiswa) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.school_rounded, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'Jurusan: ${widget.subject.major}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isSiswa) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kode Kelas',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              widget.subject.code,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.copy_rounded, color: AppColors.primary),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.subject.code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kode kelas disalin ke clipboard'),
                                backgroundColor: AppColors.statusSelesai,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (!isSiswa) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Siswa', 
                      '${dummyStudents.length}', 
                      Icons.people_alt_rounded, 
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Mengerjakan', 
                      '${subjectTasks.where((t) => t.status != 'Belum Dikerjakan').length}', 
                      Icons.check_circle_rounded, 
                      AppColors.statusSelesai,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Belum', 
                      '${subjectTasks.where((t) => t.status == 'Belum Dikerjakan').length}', 
                      Icons.hourglass_empty_rounded, 
                      AppColors.statusProses,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
            tabs: [
              const Tab(text: 'Tugas Aktif'),
              const Tab(text: 'Tugas Selesai'),
              if (!isSiswa) const Tab(text: 'Siswa'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Tugas Aktif
                _buildTaskList(activeTasks),
                
                // Tab 2: Tugas Selesai
                _buildTaskList(finishedTasks),

                // Tab 2: Siswa Bergabung (Khusus Guru)
                if (!isSiswa)
                  ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: dummyStudents.length,
                    separatorBuilder: (context, index) => Divider(color: AppColors.divider, height: 32),
                    itemBuilder: (context, index) {
                      final student = dummyStudents[index];
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Icons.person, color: AppColors.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  student.id,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            count,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
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

  Widget _buildTaskList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'Belum ada tugas',
          style: GoogleFonts.inter(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: tasks[index],
          role: widget.role,
        );
      },
    );
  }
}
```

---

## 15.3 Form Tambah Mata Pelajaran (Guru)

### 1. Desain Tampilan
*(Tempatkan screenshot halaman Form Tambah Mata Pelajaran di sini)*

### 2. Lokasi File
- **Nama File:** `subject_form_screen.dart`
- **Lokasi:** `lib/screens/subject_form/subject_form_screen.dart`

### 3. Kode Tampilan (UI Murni)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

import '../../data/dummy_data.dart';
import '../../models/task_model.dart';

class SubjectFormScreen extends StatefulWidget {
  const SubjectFormScreen({super.key});

  @override
  State<SubjectFormScreen> createState() => _SubjectFormScreenState();
}

class _SubjectFormScreenState extends State<SubjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _majorController = TextEditingController();
  final _teacherController = TextEditingController(text: dummyTeacherProfile.fullName);

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _classController.dispose();
    _majorController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim().toUpperCase();
      
      // Save to dummy subjects
      dummySubjects.add(
        SubjectModel(
          name: _nameController.text.trim(),
          teacher: _teacherController.text.trim(),
          code: code,
          className: _classController.text.trim().toUpperCase(),
          createdBy: dummyTeacherProfile.fullName,
          major: _majorController.text.trim(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mata kuliah berhasil disimpan',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.statusSelesai,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Pelajaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _codeController,
                label: 'Kode Mata Pelajaran',
                hint: 'Contoh: x7qz9b',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode mata pelajaran tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _nameController,
                label: 'Nama Mata Pelajaran',
                hint: 'Contoh: Fisika',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama mata pelajaran tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _classController,
                label: 'Kelas',
                hint: 'Contoh: X Bahasa 1, Kelas Pagi',
                icon: Icons.class_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kelas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _majorController,
                label: 'Jurusan',
                hint: 'Contoh: MIPA',
                icon: Icons.school_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jurusan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _teacherController,
                label: 'Nama Guru',
                hint: 'Contoh: Budi Santoso, M.Kom',
                icon: Icons.person_outline_rounded,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama guru tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'SIMPAN MATA KULIAH',
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

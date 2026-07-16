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

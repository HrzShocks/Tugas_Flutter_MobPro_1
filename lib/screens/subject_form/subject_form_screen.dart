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

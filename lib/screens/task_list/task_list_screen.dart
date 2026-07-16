import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../widgets/task_card.dart';
import '../task_form/task_form_screen.dart';
import '../settings/settings_screen.dart';
import '../notification/notification_screen.dart';

class TaskListScreen extends StatefulWidget {
  final String role;
  const TaskListScreen({super.key, required this.role});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isSiswa = widget.role == 'Siswa';
    final currentTeacherName = dummyTeacherProfile.fullName;
    
    // Role based base tasks
    final baseTasks = isSiswa 
        ? dummyTasks.where((t) => t.className == 'X MIPA 1' || t.className == 'UMUM').toList()
        : dummyTasks.where((t) => t.teacher == currentTeacherName).toList();

    final filters = isSiswa 
      ? ['Semua', 'Belum', 'Selesai'] 
      : ['Semua', 'Berjalan', 'Selesai'];

    // Filter logic
    final filteredTasks = baseTasks.where((task) {
      // 1. Apply Search
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            task.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (!matchesSearch) return false;

      // 2. Apply Filter
      if (_selectedFilter == 'Semua') return true;
      
      if (isSiswa) {
        if (_selectedFilter == 'Belum' && task.status == 'Belum Dikerjakan') return true;
        if (_selectedFilter == 'Selesai' && task.status == 'Selesai') return true;
      } else {
        if (_selectedFilter == 'Berjalan' && task.status == 'Belum Dikerjakan') return true;
        if (_selectedFilter == 'Selesai' && task.status == 'Selesai') return true;
      }

      return false;
    }).toList();

    return Scaffold(
      floatingActionButton: widget.role == 'Siswa' ? null : Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Above bottom nav
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskFormScreen()),
            );
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Dashboard-style Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Tugas',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSiswa 
                          ? 'Temukan dan kelola semua tugasmu' 
                          : 'Pantau semua tugas siswa',
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(role: widget.role)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight, // Changed from surface (white) to match project theme
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: GoogleFonts.inter(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Cari tugas kuliah...',
                    hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    icon: Icon(Icons.search_rounded, color: AppColors.primary),
                  ),
                ),
              ),
            ),
          
          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = _selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                  labelStyle: GoogleFonts.inter(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Task List
          Expanded(
            child: filteredTasks.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada tugas ditemukan',
                    style: GoogleFonts.inter(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(task: filteredTasks[index], role: widget.role);
                  },
                ),
          ),
        ],
      ),
    ));
  }
}

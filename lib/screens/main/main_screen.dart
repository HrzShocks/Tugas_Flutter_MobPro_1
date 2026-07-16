import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../task_list/task_list_screen.dart';
import '../subject/subject_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String role;
  const MainScreen({super.key, required this.role});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(role: widget.role),
      TaskListScreen(role: widget.role),
      SubjectScreen(role: widget.role),
      HistoryScreen(role: widget.role),
      ProfileScreen(role: widget.role),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // For floating bottom nav bar
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textLight,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(Icons.home_rounded, 0, 'Beranda'),
              _buildNavItem(Icons.assignment_rounded, 1, 'Tugas'),
              _buildNavItem(Icons.library_books_rounded, 2, 'Pelajaran'),
              _buildNavItem(Icons.history_rounded, 3, 'Riwayat'),
              _buildNavItem(Icons.person_rounded, 4, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    int index,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textLight,
        ),
      ),
      label: label,
    );
  }
}

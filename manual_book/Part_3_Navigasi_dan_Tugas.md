### Title: Manual Book Bagian 3: Navigasi Utama, Dashboard, Notifikasi & Daftar Tugas

Bagian ini membahas pembuatan menu navigasi melayang (*floating bottom navigation*), halaman utama ringkasan tugas (*dashboard*), daftar riwayat notifikasi, serta daftar tugas kuliah lengkap dengan kolom pencarian dan kategori.

---

# Bab 10: Tampilan Navigasi Utama (Bottom Navigation)

Wadah halaman utama yang menggunakan konsep menu melayang (*floating navigation*) dengan 5 opsi navigasi.

## 1. Desain Tampilan
*(Tempatkan screenshot bagian bawah layar navigasi utama di sini)*

## 2. Lokasi File
- **Nama File:** `main_screen.dart`
- **Lokasi:** `lib/screens/main/main_screen.dart`

## 3. Kode Tampilan (UI Murni)
```dart
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
```

---

# Bab 11: Tampilan Beranda (Dashboard)

Halaman utama yang menampilkan ringkasan data statistik jumlah tugas dan daftar tugas prioritas teratas.

## 1. Desain Tampilan
*(Tempatkan screenshot penuh layar Beranda/Dashboard di sini)*

## 2. Lokasi File
- **Nama File:** `dashboard_screen.dart`
- **Lokasi:** `lib/screens/dashboard/dashboard_screen.dart`

## 3. Kode Tampilan (UI Murni - Tanpa Logika Statistik)
```dart
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
```

---

# Bab 12: Tampilan Notifikasi

Halaman daftar riwayat notifikasi baru yang masuk seperti pengingat tenggat waktu atau nilai tugas.

## 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Notifikasi di sini)*

## 2. Lokasi File
- **Nama File:** `notification_screen.dart`
- **Lokasi:** `lib/screens/notification/notification_screen.dart`

## 3. Kode Tampilan (UI Murni - Menggunakan Data Hardcoded)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  final String role;
  NotificationScreen({super.key, required this.role});

  final List<Map<String, dynamic>> dummySiswaNotifications = [
    {
      'title': 'Tenggat Waktu Mendekat!',
      'description': 'Tugas "Desain UI" dari mata pelajaran Fisika harus dikumpulkan besok.',
      'time': '2 jam yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Tugas Dinilai',
      'description': 'Tugas "Diagram UML" Anda telah dinilai oleh Bu Rina. Anda mendapat nilai 85.',
      'time': '5 jam yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Materi Baru Ditambahkan',
      'description': 'Pak Budi menambahkan materi baru untuk Kimia.',
      'time': '1 hari yang lalu',
      'isUnread': false,
    },
    {
      'title': 'Tugas Baru',
      'description': 'Tugas baru ditambahkan untuk mata pelajaran Biologi.',
      'time': '2 hari yang lalu',
      'isUnread': false,
    },
  ];

  final List<Map<String, dynamic>> dummyGuruNotifications = [
    {
      'title': 'Tugas Baru Terkumpul',
      'description': 'Budi Santoso baru saja mengumpulkan tugas "Desain UI" pada mata pelajaran Fisika.',
      'time': '10 menit yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Pertanyaan Siswa',
      'description': 'Siti Aminah bertanya mengenai materi Kimia bab 3.',
      'time': '1 jam yang lalu',
      'isUnread': true,
    },
    {
      'title': 'Tenggat Waktu Berakhir',
      'description': 'Batas waktu pengumpulan tugas "Diagram UML" telah berakhir.',
      'time': '3 jam yang lalu',
      'isUnread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final notifications = role == 'Siswa' ? dummySiswaNotifications : dummyGuruNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final isUnread = notif['isUnread'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnread ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnread ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUnread ? AppColors.primary : AppColors.surface,
                    shape: BoxShape.circle,
                    border: isUnread ? null : Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: isUnread ? Colors.white : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'] as String,
                        style: GoogleFonts.inter(
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['description'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

# Bab 13: Tampilan Daftar Tugas

Halaman yang memuat daftar seluruh tugas terdaftar, kolom pencarian teks, dan filter status ("Semua", "Belum", "Selesai").

## 1. Desain Tampilan
*(Tempatkan screenshot penuh halaman Daftar Tugas di sini)*

## 2. Lokasi File
- **Nama File:** `task_list_screen.dart`
- **Lokasi:** `lib/screens/task_list/task_list_screen.dart`

## 3. Kode Tampilan (UI Murni - Tanpa Logika Filter Pencarian)
```dart
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
```

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Atur Tugas dengan Mudah",
      "description": "Tidak ada lagi tugas yang terlewat. Semua terorganisir di satu tempat dengan rapi.",
      "icon": "Icons.assignment_turned_in_rounded"
    },
    {
      "title": "Pengingat Otomatis",
      "description": "Dapatkan notifikasi sebelum tenggat waktu agar selalu tepat waktu mengumpulkan tugas.",
      "icon": "Icons.notifications_active_rounded"
    },
    {
      "title": "Pantau Progres Belajar",
      "description": "Lihat statistik dan riwayat tugas untuk terus meningkatkan produktivitasmu.",
      "icon": "Icons.bar_chart_rounded"
    },
  ];

  IconData _getIconData(String name) {
    switch (name) {
      case "Icons.assignment_turned_in_rounded":
        return Icons.assignment_turned_in_rounded;
      case "Icons.notifications_active_rounded":
        return Icons.notifications_active_rounded;
      case "Icons.bar_chart_rounded":
        return Icons.bar_chart_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: AppColors.background,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getIconData(_onboardingData[index]["icon"]!),
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 60),
                          Text(
                            _onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _onboardingData[index]["description"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => _buildDot(index: index),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_currentPage == _onboardingData.length - 1)
                      PrimaryButton(
                        text: 'MULAI SEKARANG',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _pageController.jumpToPage(_onboardingData.length - 1);
                              },
                              child: Text(
                                'LEWATI',
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PrimaryButton(
                              text: 'LANJUT',
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

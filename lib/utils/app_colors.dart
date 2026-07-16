import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Vibrant Blue & Purple Gradient
  static Color primary = const Color(0xFF3B82F6); // Bright Blue
  static Color primaryDark = const Color(0xFF1D4ED8);
  static Color primaryLight = const Color(0xFFEFF6FF); // Very light blue
  static Color secondary = const Color(0xFF8B5CF6); // Soft Purple
  
  // Background & Surface
  static Color background = const Color(0xFFF1F5F9); // Very light greyish blue
  static Color surface = const Color(0xFFFFFFFF); // White
  static Color surfaceGlass = const Color(0xB3FFFFFF); // White with 70% opacity for glassmorphism
  
  // Text Colors
  static Color textPrimary = const Color(0xFF0F172A); // Slate 900
  static Color textSecondary = const Color(0xFF475569); // Slate 600
  static Color textLight = const Color(0xFF94A3B8); // Slate 400

  // Status Colors (Soft yet clear)
  static Color statusBelum = const Color(0xFFEF4444); // Soft Red
  static Color statusProses = const Color(0xFFF59E0B); // Soft Amber
  static Color statusSelesai = const Color(0xFF10B981); // Soft Emerald

  // Priority Colors
  static Color priorityTinggi = const Color(0xFFFCA5A5); // Lighter Red
  static Color prioritySedang = const Color(0xFFFCD34D); // Lighter Amber
  static Color priorityRendah = const Color(0xFF93C5FD); // Lighter Blue

  // UI Elements
  static Color border = const Color(0xFFE2E8F0); // Slate 200
  static Color divider = const Color(0xFFF1F5F9); // Slate 100
  static Color shadowColor = const Color(0x1A0F172A); // Subtle dark slate shadow

  static void setLightMode() {
    primaryLight = const Color(0xFFEFF6FF);
    background = const Color(0xFFF1F5F9);
    surface = const Color(0xFFFFFFFF);
    surfaceGlass = const Color(0xB3FFFFFF);
    textPrimary = const Color(0xFF0F172A);
    textSecondary = const Color(0xFF475569);
    textLight = const Color(0xFF94A3B8);
    border = const Color(0xFFE2E8F0);
    divider = const Color(0xFFF1F5F9);
    shadowColor = const Color(0x1A0F172A);
  }

  static void setDarkMode() {
    primaryLight = const Color(0xFF1E293B); // Dark slate
    background = const Color(0xFF0F172A); // Very dark slate
    surface = const Color(0xFF1E293B); // Dark surface
    surfaceGlass = const Color(0xB31E293B); 
    textPrimary = const Color(0xFFF8FAFC); // Very light slate
    textSecondary = const Color(0xFFCBD5E1); // Light slate
    textLight = const Color(0xFF64748B); // Slate
    border = const Color(0xFF334155); // Dark border
    divider = const Color(0xFF334155);
    shadowColor = const Color(0x66000000); // Darker shadow
  }
}


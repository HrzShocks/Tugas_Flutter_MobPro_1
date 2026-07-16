import 'package:flutter/material.dart';
import 'app_colors.dart';

class StatusHelpers {
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return AppColors.priorityTinggi;
      case 'sedang':
        return AppColors.prioritySedang;
      case 'rendah':
      default:
        return AppColors.priorityRendah;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return AppColors.statusSelesai;
      case 'selesai (terlambat)':
        return AppColors.statusBelum;
      case 'belum dikerjakan':
      case 'belum':
        return AppColors.statusBelum;
      default:
        return AppColors.statusProses;
    }
  }

  static String getDisplayStatus(String role, String status, String? grade) {
    if (role == 'Guru') {
      if (status == 'Belum Dikerjakan') return 'Berjalan';
      if (status == 'Selesai' || status == 'Selesai (Terlambat)') {
        return grade == null ? 'Perlu Dinilai' : 'Selesai Dinilai';
      }
    }
    return status;
  }

  static bool isLate(String deadline) {
    final parts = deadline.split(' ');
    if (parts.length != 3) return false;
    
    final day = int.tryParse(parts[0]);
    final year = int.tryParse(parts[2]);
    final monthStr = parts[1].toLowerCase();
    
    int month = 1;
    switch (monthStr) {
      case 'januari': month = 1; break;
      case 'februari': month = 2; break;
      case 'maret': month = 3; break;
      case 'april': month = 4; break;
      case 'mei': month = 5; break;
      case 'juni': month = 6; break;
      case 'juli': month = 7; break;
      case 'agustus': month = 8; break;
      case 'september': month = 9; break;
      case 'oktober': month = 10; break;
      case 'november': month = 11; break;
      case 'desember': month = 12; break;
    }
    
    if (day == null || year == null) return false;
    
    final deadlineDate = DateTime(year, month, day, 23, 59, 59); // End of the day
    final now = DateTime.now();
    
    return now.isAfter(deadlineDate);
  }
}

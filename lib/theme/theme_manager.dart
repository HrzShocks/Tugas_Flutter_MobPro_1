import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ThemeManager {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  static void toggle() {
    isDarkMode.value = !isDarkMode.value;
    if (isDarkMode.value) {
      AppColors.setDarkMode();
    } else {
      AppColors.setLightMode();
    }
  }
}

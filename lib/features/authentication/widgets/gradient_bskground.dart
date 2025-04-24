import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';

BoxDecoration buildGradientBackground() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.blue100.withOpacity(0.3),
        AppColors.blue100.withOpacity(0.3),
        AppColors.actionButton,
      ],
      stops: const [0.0, 0.5, 1.0],
    ),
  );
}

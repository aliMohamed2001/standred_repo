import 'package:flutter/material.dart';

import 'app_colors.dart';

class FontStyles {
  static const TextStyle font18Weight500White = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'standred',
    color: Colors.white,
  );
  static TextStyle appbartext = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    fontFamily: 'standred',
    color: AppColors.actionButton,
  );
  static TextStyle font14Weight400RightAligned = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'standred',
    color: AppColors.textColor,
  );
  static TextStyle font18Weight500Action = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'standred',
    color: AppColors.actionButton,
  );

  static TextStyle font16Weight400Text = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'standred',
    color: AppColors.textColor,
  );

  static TextStyle font16WeightBoldText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'standred',
    color: AppColors.textColor,
  );
}

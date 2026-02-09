import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_constants.dart';

class FontStyles {
  static TextStyle font18Weight500White = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: AppConstants.fontFamily,
    color: Colors.white,
  );
  
  static TextStyle appbartext = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    fontFamily: AppConstants.fontFamily,
    color: AppColors.actionButton,
  );
  
  static TextStyle font14Weight400RightAligned = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: AppConstants.fontFamily,
    color: AppColors.textColor,
  );
  
  static TextStyle font18Weight500Action = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: AppConstants.fontFamily,
    color: AppColors.actionButton,
  );

  static TextStyle font16Weight400Text = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: AppConstants.fontFamily,
    color: AppColors.textColor,
  );

  static TextStyle font16WeightBoldText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: AppConstants.fontFamily,
    color: AppColors.textColor,
  );
  
  static TextStyle font28WeightBoldWhite = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: AppConstants.fontFamily,
    color: Colors.white,
  );

  static TextStyle font28Weight600WhiteTrans = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    fontFamily: AppConstants.fontFamily,
    color: Colors.white,
  );
}

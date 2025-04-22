import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/responsive_utils.dart';
import '../core/utils/styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final IconData? icon;
  final Color? iconColor;
  final bool isLoading;
  final ResponsiveUtils utils;

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.utils,
    this.color,
    this.textColor,
    this.height,
    this.width,
    this.borderRadius,
    this.icon,
    this.iconColor,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? utils.responsiveElementHeight(50),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.actionButton,
          padding: utils.responsivePadding(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: textColor ?? Colors.white),
            borderRadius: BorderRadius.circular(
              borderRadius ?? utils.responsiveElementWidth(12),
            ),
          ),
          elevation: 1,
          shadowColor: AppColors.actionButton.withOpacity(0.3),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: iconColor ?? Colors.white,
                        size: utils.responsiveElementWidth(20),
                      ),
                      SizedBox(width: utils.responsiveElementWidth(6)),
                    ],
                    Text(
                      text,
                      style: FontStyles.font14Weight400RightAligned.copyWith(
                        color: textColor ?? Colors.white,
                        fontSize: utils.responsiveTextScale(14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
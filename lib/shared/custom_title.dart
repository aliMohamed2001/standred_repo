import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/shared/animation_utils.dart' show AnimationUtils;

class CustomTitle extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final ResponsiveUtils utils;

  const CustomTitle({
    required this.text,
    required this.controller,
    required this.utils,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationUtils.fade(
      controller: controller,
      child: ShaderMask(
        shaderCallback:
            (bounds) => LinearGradient(
              colors: [Colors.white, AppColors.blue100],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
        child: Text(
          text,
          style: TextStyle(
            fontSize: utils.responsiveTextScale(28),
            fontWeight: FontWeight.w600,
            decorationStyle: TextDecorationStyle.dashed,
            fontFamily: 'standred',
            leadingDistribution: TextLeadingDistribution.even,
            decorationColor: AppColors.primaryColor,
            color: AppColors.textColor2,
          ),
        ),
      ),
    );
  }
}

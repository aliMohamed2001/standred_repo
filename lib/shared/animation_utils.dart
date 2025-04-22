import 'package:flutter/material.dart';

/// فئة مساعدة لإنشاء الرسوم المتحركة بسهولة في أي تطبيق
class AnimationUtils {
  /// دالة لإنشاء Fade Animation
  static Widget fade({
    required Widget child,
    required AnimationController controller,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
    VoidCallback? onEnd,
  }) {
    final animation = Tween<double>(
      begin: beginOpacity,
      end: endOpacity,
    ).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isCompleted && onEnd != null) onEnd();
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// دالة لإنشاء Slide Animation
  static Widget slide({
    required Widget child,
    required AnimationController controller,
    Duration duration =const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
    Offset beginOffset = const Offset(1.0, 0.0),
    Offset endOffset = Offset.zero,
    VoidCallback? onEnd,
  }) {
    final animation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isCompleted && onEnd != null) onEnd();
        return SlideTransition(
          position: animation,
          child: child,
        );
      },
    );
  }

  /// دالة لإنشاء Scale Animation
  static Widget scale({
    required Widget child,
    required AnimationController controller,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.elasticOut,
    double beginScale = 0.0,
    double endScale = 1.0,
    VoidCallback? onEnd,
  }) {
    final animation = Tween<double>(
      begin: beginScale,
      end: endScale,
    ).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isCompleted && onEnd != null) onEnd();
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }

  /// دالة لإنشاء Rotate Animation
  static Widget rotate({
    required Widget child,
    required AnimationController controller,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
    double beginAngle = 0.0,
    double endAngle = 1.0,
    VoidCallback? onEnd,
  }) {
    final animation = Tween<double>(
      begin: beginAngle,
      end: endAngle,
    ).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isCompleted && onEnd != null) onEnd();
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
    );
  }
}
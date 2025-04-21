import 'package:flutter/material.dart';

enum AnimationType { slide, fade, scale }

extension NavigatorHelper on BuildContext {
  void pushWithAnimation(
    Widget widget, {
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(1.0, 0.0),
  }) {
    Navigator.of(this).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (animationType) {
          case AnimationType.fade:
            return FadeTransition(opacity: animation, child: child);
          case AnimationType.scale:
            return ScaleTransition(scale: animation, child: child);
          case AnimationType.slide:
          default:
            var tween = Tween(begin: begin, end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
        }
      },
    ));
  }

  void pop() {
    Navigator.of(this).pop();
  } 

  void popWithAnimation({
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Offset end = const Offset(-1.0, 0.0),
  }) {
    Navigator.of(this).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => this.widget,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (animationType) {
          case AnimationType.fade:
            return FadeTransition(opacity: animation, child: child);
          case AnimationType.scale:
            return ScaleTransition(scale: animation, child: child);
          case AnimationType.slide:
          default:
            var tween = Tween(begin: end, end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
        }
      },
    ));
  }

  void pushReplacementWithAnimation(
    Widget widget, {
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(0.0, 1.0),
  }) {
    Navigator.of(this).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (animationType) {
          case AnimationType.fade:
            return FadeTransition(opacity: animation, child: child);
          case AnimationType.scale:
            return ScaleTransition(scale: animation, child: child);
          case AnimationType.slide:
          default:
            var tween = Tween(begin: begin, end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
        }
      },
    ));
  }

  void pushAndRemoveUntilWithAnimation(
    Widget widget, {
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(-1.0, 0.0),
  }) {
    Navigator.of(this).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          switch (animationType) {
            case AnimationType.fade:
              return FadeTransition(opacity: animation, child: child);
            case AnimationType.scale:
              return ScaleTransition(scale: animation, child: child);
            case AnimationType.slide:
            default:
              var tween = Tween(begin: begin, end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
          }
        },
      ),
      (Route route) => false,
    );
  }
}

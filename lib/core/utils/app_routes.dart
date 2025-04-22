import 'package:flutter/material.dart';
import 'package:new_standred/features/authentication/screens/forgot_password_screen.dart';
import 'package:new_standred/features/authentication/screens/login_screen.dart' show LoginScreen;
import 'package:new_standred/features/authentication/screens/reset_password_screen.dart';
import 'package:new_standred/features/authentication/screens/sign_up_screen.dart';
import 'package:new_standred/features/authentication/screens/verify_otp_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String forgotPassword = '/forgot_password';
  static const String resetPassword = '/reset_password';
  static const String verifyOtp = '/verify_otp';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signUp: (context) => const SignUpScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
      verifyOtp: (context) => const VerifyOtpScreen(),
    };
  }
}
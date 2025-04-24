import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/app_routes.dart';
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/features/authentication/widgets/gradient_bskground.dart';
import 'package:new_standred/shared/animation_utils.dart';
import 'package:new_standred/shared/auth_custom_text_filed.dart';
import 'package:new_standred/shared/custom_title.dart';
import 'package:new_standred/shared/custome_button.dart';
import 'package:new_standred/shared/toast/show_custom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(ResponsiveUtils utils) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showfailureToast('الرجاء إدخال بريد إلكتروني صالح');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      showfailureToast('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    showSuccessToast('تم تسجيل الدخول بنجاح');
  }

  @override
  Widget build(BuildContext context) {
    final utils = ResponsiveUtils(
      MediaQuery.of(context),
      isDarkMode: Theme.of(context).brightness == Brightness.dark,
      primaryColor: AppColors.primaryColor,
      backgroundColor: AppColors.veryLightGrey,
      isRTL: Directionality.of(context) == TextDirection.rtl,
    );

    return Scaffold(
      body: Container(
        decoration: buildGradientBackground(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimationUtils.fade(
                    controller: _animationController,
                    child: CustomTitle(
                      text: "تسجيل الدخول",
                      controller: _animationController,
                      utils: utils,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnimationUtils.slide(
                    controller: _animationController,
                    beginOffset: const Offset(0.5, 0.0),
                    child: Column(
                      children: [
                        AuthTextFormField(
                          label: 'البريد الإلكتروني',
                          hintText: 'example@mail.com',
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 16),
                        AuthTextFormField(
                          label: 'كلمة المرور',
                          hintText: '********',
                          obscureText: !_isPasswordVisible,
                          textInputType: TextInputType.visiblePassword,
                          controller: _passwordController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.forgotPassword,
                                ),
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontSize: utils.responsiveTextScale(14),
                                color: Colors.white70,
                                fontFamily: "DGAgnadeen",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'تسجيل الدخول',
                          onPressed: () => _handleLogin(utils),
                          utils: utils,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ليس لديك حساب؟ ',
                              style: TextStyle(
                                fontSize: utils.responsiveTextScale(14),
                                color: Colors.white70,
                                fontFamily: "DGAgnadeen",
                              ),
                            ),
                            GestureDetector(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.signUp,
                                  ),
                              child: Text(
                                'سجّل من هنا',
                                style: TextStyle(
                                  fontSize: utils.responsiveTextScale(14),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "DGAgnadeen",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

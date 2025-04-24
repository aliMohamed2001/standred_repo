import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/app_routes.dart' show AppRoutes;
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/shared/animation_utils.dart' show AnimationUtils;
import 'package:new_standred/shared/auth_custom_text_filed.dart';
import 'package:new_standred/shared/custom_title.dart';
import 'package:new_standred/shared/custome_button.dart';
import 'package:new_standred/shared/toast/show_custom_toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _nameController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.blue100.withOpacity(0.3),
          AppColors.veryLightGrey,
          AppColors.actionButton.withOpacity(0.2),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  void _handleSignUp(ResponsiveUtils utils) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || name.length < 2) {
      showfailureToast('الرجاء إدخال اسم صالح (على الأقل حرفين)');
      return;
    }
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showfailureToast('الرجاء إدخال بريد إلكتروني صالح');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      showfailureToast('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    showSuccessToast('تم إنشاء الحساب بنجاح');
    Navigator.pushNamed(context, AppRoutes.verifyOtp);
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
        height: MediaQuery.of(context).size.height,
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: utils.responsiveElementHeight(40)),
              AnimationUtils.slide(
                controller: _animationController,
                child: CustomTitle(
                  text: "إنشاء حساب",
                  controller: _animationController,
                  utils: utils,
                ),
              ),

              SizedBox(height: utils.responsiveElementHeight(40)),
              Expanded(
                child: Padding(
                  padding: utils.responsivePadding(horizontal: 24),
                  child: AnimationUtils.slide(
                    controller: _animationController,
                    beginOffset: const Offset(0.5, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AuthTextFormField(
                          label: 'الاسم',
                          hintText: 'أدخل اسمك',
                          textInputType: TextInputType.name,
                          controller: _nameController,
                        ),
                        SizedBox(height: utils.responsiveElementHeight(16)),
                        AuthTextFormField(
                          label: 'البريد الإلكتروني',
                          hintText: 'example@mail.com',
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        SizedBox(height: utils.responsiveElementHeight(16)),
                        AuthTextFormField(
                          label: 'كلمة المرور',
                          hintText: '********',
                          obscureText: !_isPasswordVisible,
                          suffixIcon:
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off_outlined,
                          suffixTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          textInputType: TextInputType.visiblePassword,
                          controller: _passwordController,
                        ),
                        SizedBox(height: utils.responsiveElementHeight(24)),
                        CustomButton(
                          text: 'إنشاء حساب',
                          onPressed: () => _handleSignUp(utils),
                          utils: utils,
                        ),
                        SizedBox(height: utils.responsiveElementHeight(24)),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'لديك حساب بالفعل؟ ',
                                style: TextStyle(
                                  fontSize: utils.responsiveTextScale(14),
                                  color: AppColors.textColor2,
                                  fontFamily: "DGAgnadeen",
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.login,
                                    ),
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: utils.responsiveTextScale(14),
                                    color: AppColors.primaryColor,
                                    fontFamily: "DGAgnadeen",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: utils.responsiveElementHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}

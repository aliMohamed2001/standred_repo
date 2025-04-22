import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/app_routes.dart' show AppRoutes;
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/shared/animation_utils.dart' show AnimationUtils;
import 'package:new_standred/shared/auth_custom_text_filed.dart';
import 'package:new_standred/shared/custom_title.dart' show CustomTitle;
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

  // دالة لإنشاء الخلفية المتدرجة
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

  // دالة لإنشاء تصميم الحاوية
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.veryLightGrey.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.textColor.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
    );
  }

  // دالة التحقق من الحقول وتسجيل الدخول
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
        height: MediaQuery.of(context).size.height,
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: utils.responsiveElementHeight(40)),
              AnimationUtils.fade(
                controller: _animationController,
                child:  CustomTitle(
                text: "تسجيل الدخول",
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
                    child: Container(
                      padding: utils.responsivePadding(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      decoration: _buildContainerDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                  color: AppColors.textColor2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: utils.responsiveElementHeight(24)),
                          CustomButton(
                            text: 'تسجيل الدخول',
                            onPressed: () => _handleLogin(utils),
                            utils: utils,
                          ),
                          SizedBox(height: utils.responsiveElementHeight(24)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ليس لديك حساب؟ ',
                                style: TextStyle(
                                  fontSize: utils.responsiveTextScale(14),
                                  color: AppColors.textColor2,
                                  fontFamily: "standard",
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
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

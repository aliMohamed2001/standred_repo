import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/app_routes.dart' show AppRoutes;
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/shared/animation_utils.dart' show AnimationUtils;
import 'package:new_standred/shared/auth_custom_text_filed.dart';
import 'package:new_standred/shared/custom_title.dart' show CustomTitle;
import 'package:new_standred/shared/custome_button.dart';
import 'package:new_standred/shared/toast/show_custom_toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _emailController = TextEditingController();

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

  void _handleForgotPassword(ResponsiveUtils utils) {
    final email = _emailController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showfailureToast('الرجاء إدخال بريد إلكتروني صالح');
      return;
    }

    showSuccessToast('تم إرسال رمز التحقق');
    Navigator.pushNamed(context, AppRoutes.verifyOtp, arguments: true);
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
                AnimationUtils.scale(
                controller: _animationController,
                child:  CustomTitle(
                text:   "نسيت كلمة المرور",
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
                      padding: utils.responsivePadding(horizontal: 20, vertical: 30),
                      decoration: _buildContainerDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimationUtils.fade(
                            controller: _animationController,
                            child: Text(
                              'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
                              style: TextStyle(
                                fontSize: utils.responsiveTextScale(16),
                                color: AppColors.textColor2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: utils.responsiveElementHeight(24)),
                          AuthTextFormField(
                            label: 'البريد الإلكتروني',
                            hintText: 'example@mail.com',
                            textInputType: TextInputType.emailAddress,
                            controller: _emailController,
                          ),
                          SizedBox(height: utils.responsiveElementHeight(24)),
                          CustomButton(
                            text: 'إرسال',
                            onPressed: () => _handleForgotPassword(utils),
                            utils: utils,
                          ),
                          SizedBox(height: utils.responsiveElementHeight(24)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'العودة إلى تسجيل الدخول',
                              style: TextStyle(
                                fontSize: utils.responsiveTextScale(14),
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
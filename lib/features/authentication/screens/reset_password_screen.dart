import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/app_routes.dart' show AppRoutes;
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/shared/animation_utils.dart' show AnimationUtils;
import 'package:new_standred/shared/auth_custom_text_filed.dart';
import 'package:new_standred/shared/custom_title.dart';
import 'package:new_standred/shared/custome_button.dart';
import 'package:new_standred/shared/toast/show_custom_toast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  void _handleResetPassword(ResponsiveUtils utils) {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || password.length < 6) {
      showfailureToast('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }
    if (confirmPassword != password) {
      showfailureToast('كلمة المرور غير متطابقة');
      return;
    }

    showSuccessToast('تم تغيير كلمة المرور بنجاح');
    Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                child:  CustomTitle(
                text:  "إعادة تعيين كلمة المرور",
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
                          AuthTextFormField(
                            label: 'كلمة المرور الجديدة',
                            hintText: '********',
                            obscureText: !_isPasswordVisible,
                            suffixIcon:   _isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                            suffixTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                            },
                            textInputType: TextInputType.visiblePassword,
                            controller: _passwordController,
                          ),
                          SizedBox(height: utils.responsiveElementHeight(16)),
                          AuthTextFormField(
                            label: 'تأكيد كلمة المرور',
                            hintText: '********',
                            obscureText: !_isConfirmPasswordVisible,
                            suffixIcon:   _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                            suffixTap: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                            },
                            textInputType: TextInputType.visiblePassword,
                            controller: _confirmPasswordController,
                          ),
                          SizedBox(height: utils.responsiveElementHeight(24)),
                          CustomButton(
                            text: 'حفظ',
                            onPressed: () => _handleResetPassword(utils),
                            utils: utils,
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
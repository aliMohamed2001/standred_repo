import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/app_routes.dart' show AppRoutes;
import 'package:new_standred/core/utils/responsive_utils.dart';
import 'package:new_standred/features/authentication/widgets/gradient_bskground.dart';
import 'package:new_standred/shared/animation_utils.dart' show AnimationUtils;
import 'package:new_standred/shared/custom_title.dart';
import 'package:new_standred/shared/custome_button.dart';
import 'package:new_standred/shared/toast/show_custom_toast.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isFromForgotPassword = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is bool) {
        setState(() {
          _isFromForgotPassword = args;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verifyOtp(ResponsiveUtils utils) {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 4 || !RegExp(r'^\d{4}$').hasMatch(otp)) {
      showfailureToast('الرجاء إدخال رمز صحيح مكون من 4 أرقام');
      return;
    }

    showSuccessToast('تم التحقق من الرمز بنجاح');
    if (_isFromForgotPassword) {
      Navigator.pushReplacementNamed(context, AppRoutes.resetPassword);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
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
        decoration: buildGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: utils.responsiveElementHeight(40)),
              AnimationUtils.slide(
                controller: _animationController,
                child: CustomTitle(
                  text: "التحقق من الرمز",
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
                        AnimationUtils.fade(
                          controller: _animationController,
                          child: Text(
                            'أدخل رمز التحقق المكون من 4 أرقام\nالذي تم إرساله إلى بريدك الإلكتروني',
                            style: TextStyle(
                              fontSize: utils.responsiveTextScale(16),
                              color: AppColors.textColor2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: utils.responsiveElementHeight(24)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: utils.responsiveElementWidth(50),
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.actionButton,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.actionButton,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 3) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: utils.responsiveElementHeight(24)),
                        CustomButton(
                          text: 'تحقق',
                          onPressed: () => _verifyOtp(utils),
                          utils: utils,
                        ),
                        SizedBox(height: utils.responsiveElementHeight(24)),
                        GestureDetector(
                          onTap: () {
                            showSuccessToast('تم إعادة إرسال رمز التحقق');
                          },
                          child: Text(
                            'إعادة إرسال الرمز',
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
              SizedBox(height: utils.responsiveElementHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}

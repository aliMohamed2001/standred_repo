import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/responsive_utils.dart';
import '../core/utils/styles.dart';

class AuthTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? suffixTap;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final double height;
  final double borderRadius;
  final Function(String)? onChanged;
  final Color? suffixIconColor;
  final int? maxLines;
  final FocusNode? focusNode;
  final ResponsiveUtils? responsiveUtils;

  AuthTextFormField({
    required this.label,
    required this.controller,
    required this.textInputType,
    this.obscureText = false,
    this.suffixIcon,
    this.suffixTap,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.height = 55.0,
    this.borderRadius = 14.0,
    this.onChanged,
    this.suffixIconColor,
    this.maxLines = 1,
    this.focusNode,
    this.responsiveUtils,
  });

  @override
  _AuthTextFormFieldState createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveUtils =
        widget.responsiveUtils ??
        ResponsiveUtils(
          MediaQuery.of(context),
          isDarkMode: Theme.of(context).brightness == Brightness.dark,
          primaryColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          isRTL: Directionality.of(context) == TextDirection.rtl,
        );

    double textFieldHeight = responsiveUtils.responsiveElementHeight(
      widget.height,
    );

    if (widget.validator != null) {
      final String? errorText = widget.validator!(widget.controller.text);
      if (errorText != null && errorText.isNotEmpty) {
        textFieldHeight = responsiveUtils.responsiveElementHeight(
          widget.height + 20.0,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: responsiveUtils.responsiveText(
            widget.label,
            style: responsiveUtils.responsiveTextStyle(
              FontStyles.font16Weight400Text.copyWith(
                color: AppColors.textColor,
                fontFamily: 'DGAgnadeen',
                fontSize: 14,
              ),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        responsiveUtils.verticalSpace(1.5),
        SizedBox(
          width: double.infinity,
          height: textFieldHeight,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.textInputType,
              obscureText: _obscureText,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              maxLines: widget.maxLines,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: responsiveUtils.responsiveTextStyle(
                  TextStyle(
                    color: AppColors.textColor2,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "DGAgnadeen",
                  ),
                ),
                filled: true,
                fillColor: AppColors.textColor.withOpacity(0.1),
                contentPadding: responsiveUtils.responsivePadding(
                  vertical: 14.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: responsiveUtils.responsiveBorderRadius(
                    widget.borderRadius,
                  ),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: responsiveUtils.responsiveBorderRadius(
                    widget.borderRadius,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: responsiveUtils.responsiveBorderRadius(
                    widget.borderRadius,
                  ),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: responsiveUtils.responsiveBorderRadius(
                    widget.borderRadius,
                  ),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: responsiveUtils.responsiveBorderRadius(
                    widget.borderRadius,
                  ),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                suffixIcon:
                    widget.obscureText
                        ? IconButton(
                          icon: responsiveUtils.responsiveIcon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: widget.suffixIconColor ?? Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                        : widget.suffixIcon != null
                        ? IconButton(
                          icon: responsiveUtils.responsiveIcon(
                            widget.suffixIcon!,
                            color: widget.suffixIconColor ?? Colors.grey,
                          ),
                          onPressed: widget.suffixTap,
                        )
                        : null,
                isDense: true,
                errorStyle: responsiveUtils.responsiveTextStyle(
                  const TextStyle(color: Colors.red),
                ),
              ),
              validator: widget.validator,
            ),
          ),
        ),
      ],
    );
  }
}

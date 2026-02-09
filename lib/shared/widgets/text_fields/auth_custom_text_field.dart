import 'package:flutter/material.dart';
import 'package:new_standred/core/utils/app_colors.dart';
import 'package:new_standred/core/utils/styles.dart';

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

  const AuthTextFormField({
    super.key,
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
  });

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            widget.label,
            style: FontStyles.font14Weight400RightAligned,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
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
                hintStyle: FontStyles.font14Weight400RightAligned.copyWith(
                  color: AppColors.textColor2,
                ),
                filled: true,
                fillColor: AppColors.textColor.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide:  BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
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
                            icon: Icon(
                              widget.suffixIcon!,
                              color: widget.suffixIconColor ?? Colors.grey,
                            ),
                            onPressed: widget.suffixTap,
                          )
                        : null,
                isDense: true,
                errorStyle: FontStyles.font14Weight400RightAligned.copyWith(color: Colors.red, fontSize: 12),
              ),
              validator: widget.validator,
            ),
          ),
        ),
      ],
    );
  }
}

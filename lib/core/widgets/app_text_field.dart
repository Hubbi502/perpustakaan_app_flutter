import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium text field with label, validation, and password toggle.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.onToggleObscure,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          enabled: enabled,
          onChanged: onChanged,
          focusNode: focusNode,
          autofocus: autofocus,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20)
                : null,
            suffixIcon: obscureText || onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                  )
                : suffix,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'app_text_field.dart';

/// Password input field with interactive visibility toggle and security defaults.
class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  const PasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hint = '••••••••',
    this.errorText,
    this.helperText,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.validator,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      helperText: widget.helperText,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onSubmitted: widget.onSubmitted,
      prefixIcon: Icon(
        Icons.lock_outline_rounded,
        size: AppDimensions.iconM,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: AppDimensions.iconM,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        ),
        tooltip: _obscureText ? 'Show password' : 'Hide password',
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, text }

/// Production-ready button with responsive touch targets, smooth tactile feedback,
/// consistent bounds during loading spinner, and proper disabled states.
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.height = AppDimensions.buttonHeight,
  });

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = AppDimensions.buttonHeight,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = AppDimensions.buttonHeight,
  }) : variant = AppButtonVariant.outline;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.height = 40.0,
  }) : variant = AppButtonVariant.text;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    Border? border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        backgroundColor = _isEnabled
            ? (isDark ? AppColors.primaryDark : AppColors.primary)
            : (isDark ? AppColors.disabledBackgroundDark : AppColors.disabledBackgroundLight);
        foregroundColor = _isEnabled
            ? Colors.white
            : (isDark ? AppColors.disabledTextDark : AppColors.disabledTextLight);
        break;

      case AppButtonVariant.secondary:
        backgroundColor = _isEnabled
            ? (isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight)
            : (isDark ? AppColors.disabledBackgroundDark : AppColors.disabledBackgroundLight);
        foregroundColor = _isEnabled
            ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
            : (isDark ? AppColors.disabledTextDark : AppColors.disabledTextLight);
        break;

      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = _isEnabled
            ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
            : (isDark ? AppColors.disabledTextDark : AppColors.disabledTextLight);
        border = Border.all(
          color: _isEnabled
              ? (isDark ? AppColors.borderDark : AppColors.borderLight)
              : (isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
          width: 1.5,
        );
        break;

      case AppButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = _isEnabled
            ? (isDark ? AppColors.primaryDark : AppColors.primary)
            : (isDark ? AppColors.disabledTextDark : AppColors.disabledTextLight);
        break;
    }

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: AppDimensions.iconS, color: foregroundColor),
          const SizedBox(width: AppDimensions.space8),
        ],
        Text(
          widget.text,
          style: AppTypography.labelLarge.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.text,
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _isEnabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: widget.height,
            width: widget.isFullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: border,
              boxShadow: (widget.variant == AppButtonVariant.primary && _isEnabled && !isDark)
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.20),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}

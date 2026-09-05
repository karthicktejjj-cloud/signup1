import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

enum StatusBannerType { success, error, info }

/// Reusable inline feedback banner for success, error, or info messages.
class StatusBanner extends StatelessWidget {
  final String message;
  final StatusBannerType type;
  final VoidCallback? onDismiss;

  const StatusBanner({
    super.key,
    required this.message,
    this.type = StatusBannerType.error,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color border;
    Color text;
    IconData icon;

    switch (type) {
      case StatusBannerType.success:
        bg = isDark
            ? const Color(0xFF064E3B).withValues(alpha: 0.4)
            : AppColors.successLight;
        border = isDark
            ? AppColors.successDark.withValues(alpha: 0.5)
            : AppColors.successBorder;
        text = isDark ? AppColors.successDark : AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        break;
      case StatusBannerType.error:
        bg = isDark
            ? const Color(0xFF7F1D1D).withValues(alpha: 0.4)
            : AppColors.errorLight;
        border = isDark
            ? AppColors.errorDark.withValues(alpha: 0.5)
            : AppColors.errorBorder;
        text = isDark ? AppColors.errorDark : AppColors.error;
        icon = Icons.error_outline_rounded;
        break;
      case StatusBannerType.info:
        bg = isDark
            ? const Color(0xFF0C4A6E).withValues(alpha: 0.4)
            : AppColors.infoLight;
        border = isDark
            ? AppColors.infoDark.withValues(alpha: 0.5)
            : AppColors.info;
        text = isDark ? AppColors.infoDark : AppColors.info;
        icon = Icons.info_outline_rounded;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: AppDimensions.space16),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconM, color: text),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close_rounded, size: AppDimensions.iconS, color: text),
            ),
        ],
      ),
    );
  }
}

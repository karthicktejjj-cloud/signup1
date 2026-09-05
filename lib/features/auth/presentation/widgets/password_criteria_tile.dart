import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

/// Checklist row used to display live password criteria status.
/// Uses Expanded on label text to ensure responsive wrapping on narrow screens.
class PasswordCriteriaTile extends StatelessWidget {
  final String label;
  final bool isMet;

  const PasswordCriteriaTile({
    super.key,
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isMet
        ? (isDark ? AppColors.successDark : AppColors.success)
        : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 16.0,
            height: 16.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet
                  ? (isDark ? AppColors.successDark.withValues(alpha: 0.2) : AppColors.successLight)
                  : Colors.transparent,
              border: Border.all(
                color: color,
                width: 1.5,
              ),
            ),
            child: isMet
                ? Icon(
                    Icons.check,
                    size: 10.0,
                    color: isDark ? AppColors.successDark : AppColors.success,
                  )
                : null,
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: color,
                fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

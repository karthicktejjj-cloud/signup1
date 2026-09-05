import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

/// Clean navigation footer row for alternating between Login and Signup.
/// Uses Wrap to prevent horizontal overflow on narrow devices or when scaled text is active.
class AuthFooter extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthFooter({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppDimensions.space4,
        runSpacing: AppDimensions.space4,
        children: [
          Text(
            promptText,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          GestureDetector(
            onTap: onActionPressed,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space4),
              child: Text(
                actionText,
                style: AppTypography.labelLarge.copyWith(
                  color: isDark ? AppColors.primaryDark : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

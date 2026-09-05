import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

/// Professional, authenticated empty state area indicating backend integration readiness.
class IntegrationCard extends StatelessWidget {
  const IntegrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Text(
                'AUTHENTICATED FRONTEND READY',
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            'Session Active',
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            'The frontend authentication lifecycle, secure storage, responsive design, and route guard foundations are fully active. Ready for direct API contract integration.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.space20),
          const Divider(),
          const SizedBox(height: AppDimensions.space16),
          _StatusRow(
            title: 'Design System',
            value: 'Light & Dark Mode Active',
            isDone: true,
            isDark: isDark,
          ),
          const SizedBox(height: AppDimensions.space8),
          _StatusRow(
            title: 'Networking Layer',
            value: 'Dio + Bearer Interceptor Ready',
            isDone: true,
            isDark: isDark,
          ),
          const SizedBox(height: AppDimensions.space8),
          _StatusRow(
            title: 'Secure Storage',
            value: 'Encrypted Keystore Active',
            isDone: true,
            isDark: isDark,
          ),
          const SizedBox(height: AppDimensions.space8),
          _StatusRow(
            title: 'Backend API',
            value: 'Awaiting Contract / Swagger',
            isDone: false,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isDone;
  final bool isDark;

  const _StatusRow({
    required this.title,
    required this.value,
    required this.isDone,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    isDone ? Icons.check_circle_rounded : Icons.pending_outlined,
                    size: 14.0,
                    color: isDone
                        ? (isDark ? AppColors.successDark : AppColors.success)
                        : (isDark ? AppColors.warningDark : AppColors.warning),
                  ),
                ),
                const SizedBox(width: AppDimensions.space4),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

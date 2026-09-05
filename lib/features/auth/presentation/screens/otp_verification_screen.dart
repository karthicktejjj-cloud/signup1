import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/otp_input_field.dart';
import '../../../../shared/widgets/screen_container.dart';
import '../../../../shared/widgets/status_banner.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_header.dart';

/// Screen 4: OTP Verification Screen
/// Supports both registration confirmation and password reset verification.
/// Features countdown timer, resend throttle, digit-box inputs, and resilient error states.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String flowType; // 'signup' or 'reset'

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.flowType = 'signup',
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otpCode = '';
  String? _error;
  bool _isResending = false;

  Timer? _timer;
  int _countdownSeconds = 45;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() => _countdownSeconds = 45);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() => _countdownSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final validationError = Validators.otp(_otpCode);
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }

    setState(() => _error = null);

    final success = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(widget.email, _otpCode, widget.flowType);

    if (success && mounted) {
      if (widget.flowType == 'signup') {
        context.go('/home');
      } else {
        context.push('/reset-password', extra: {
          'email': widget.email,
          'otp': _otpCode,
        });
      }
    }
  }

  Future<void> _handleResend() async {
    if (_countdownSeconds > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _error = null;
    });

    final success = await ref
        .read(authControllerProvider.notifier)
        .resendOtp(widget.email);

    if (mounted) {
      setState(() => _isResending = false);
      if (success) {
        _startCountdown();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScreenContainer(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeader(
            showLogo: false,
            title: 'Verify your code',
            subtitle:
                'We sent a 6-digit verification code to\n${widget.email.isNotEmpty ? widget.email : "your email address"}.',
          ),
          const SizedBox(height: AppDimensions.space32),

          if (_error != null || authState.errorMessage != null)
            StatusBanner(
              message: _error ?? authState.errorMessage!,
              type: StatusBannerType.error,
              onDismiss: () {
                setState(() => _error = null);
                ref.read(authControllerProvider.notifier).clearError();
              },
            ),

          OtpInputField(
            length: 6,
            hasError: _error != null || authState.errorMessage != null,
            isEnabled: !authState.isLoading,
            onChanged: (code) {
              _otpCode = code;
              if (_error != null) setState(() => _error = null);
            },
            onCompleted: (code) {
              _otpCode = code;
              _handleVerify();
            },
          ),
          const SizedBox(height: AppDimensions.space32),

          AppButton(
            text: 'Verify and Continue',
            isLoading: authState.isLoading,
            onPressed: _otpCode.length == 6 ? _handleVerify : null,
          ),
          const SizedBox(height: AppDimensions.space24),

          // Resend section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the code?",
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: AppDimensions.space4),
              if (_countdownSeconds > 0)
                Text(
                  'Resend in ${_countdownSeconds}s',
                  style: AppTypography.labelLarge.copyWith(
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
                )
              else
                GestureDetector(
                  onTap: _handleResend,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space4),
                    child: Text(
                      _isResending ? 'Resending...' : 'Resend code',
                      style: AppTypography.labelLarge.copyWith(
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

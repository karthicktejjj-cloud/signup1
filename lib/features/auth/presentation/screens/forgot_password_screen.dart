import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/screen_container.dart';
import '../../../../shared/widgets/status_banner.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_header.dart';

/// Screen 5: Forgot Password Screen
/// Collects user email, provides validation feedback, and advances smoothly to OTP.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    final success = await ref
        .read(authControllerProvider.notifier)
        .forgotPassword(email);

    if (success && mounted) {
      context.push('/verify-otp', extra: {
        'email': email,
        'flowType': 'reset',
      });
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
      child: Form(
        key: _formKey,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              showLogo: false,
              title: 'Reset password',
              subtitle:
                  'Enter the email associated with your account and we’ll send a verification code.',
            ),
            const SizedBox(height: AppDimensions.space32),

            if (authState.errorMessage != null)
              StatusBanner(
                message: authState.errorMessage!,
                type: StatusBannerType.error,
                onDismiss: () =>
                    ref.read(authControllerProvider.notifier).clearError(),
              ),

            AppTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: 'Email address',
              hint: 'name@company.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                size: AppDimensions.iconM,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              onSubmitted: (_) => _handleSubmit(),
            ),
            const SizedBox(height: AppDimensions.space24),

            AppButton(
              text: 'Send Code',
              isLoading: authState.isLoading,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/password_field.dart';
import '../../../../shared/widgets/screen_container.dart';
import '../../../../shared/widgets/status_banner.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_criteria_tile.dart';

/// Screen 6: Reset Password Screen
/// Validates new credentials against security requirements and returns to Login.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _submitted = false;
  String _currentPassword = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _currentPassword = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _passwordController.text;

    final success = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(widget.email, widget.otp, newPassword);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully. Please log in.'),
        ),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

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
              title: 'Create new password',
              subtitle:
                  'Your new password must be different from previous used passwords.',
            ),
            const SizedBox(height: AppDimensions.space32),

            if (authState.errorMessage != null)
              StatusBanner(
                message: authState.errorMessage!,
                type: StatusBannerType.error,
                onDismiss: () =>
                    ref.read(authControllerProvider.notifier).clearError(),
              ),

            PasswordField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: 'New password',
              hint: 'At least 8 characters',
              textInputAction: TextInputAction.next,
              validator: Validators.password,
              onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            ),
            const SizedBox(height: AppDimensions.space8),

            PasswordCriteriaTile(
              label: 'At least 8 characters',
              isMet: Validators.hasMinLength(_currentPassword, 8),
            ),
            PasswordCriteriaTile(
              label: 'Contains a number or uppercase letter',
              isMet: Validators.hasNumber(_currentPassword) ||
                  Validators.hasUppercase(_currentPassword),
            ),
            const SizedBox(height: AppDimensions.space16),

            PasswordField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              label: 'Confirm new password',
              hint: 'Re-enter your new password',
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  Validators.confirmPassword(v, _passwordController.text),
              onSubmitted: (_) => _handleReset(),
            ),
            const SizedBox(height: AppDimensions.space24),

            AppButton(
              text: 'Reset Password',
              isLoading: authState.isLoading,
              onPressed: _handleReset,
            ),
          ],
        ),
      ),
    );
  }
}

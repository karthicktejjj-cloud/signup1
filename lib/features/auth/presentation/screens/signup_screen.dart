import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/password_field.dart';
import '../../../../shared/widgets/screen_container.dart';
import '../../../../shared/widgets/status_banner.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_criteria_tile.dart';

/// Screen 3: Signup Screen
/// Flexible field structure ready for backend DTO specifications.
/// Includes real-time password requirements indicators and confirmation validation.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await ref
        .read(authControllerProvider.notifier)
        .register(name, email, password);

    if (success && mounted) {
      context.push('/verify-otp', extra: {
        'email': email,
        'flowType': 'signup',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScreenContainer(
      child: Form(
        key: _formKey,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.space16),
            const AuthHeader(
              title: 'Create an account',
              subtitle: 'Start your enterprise trial with your business email.',
            ),
            const SizedBox(height: AppDimensions.space24),

            if (authState.errorMessage != null)
              StatusBanner(
                message: authState.errorMessage!,
                type: StatusBannerType.error,
                onDismiss: () =>
                    ref.read(authControllerProvider.notifier).clearError(),
              ),

            // Flexible initial field - can be easily expanded/altered
            AppTextField(
              controller: _nameController,
              focusNode: _nameFocus,
              label: 'Full name',
              hint: 'John Doe',
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.requiredField(v, 'Full name'),
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                size: AppDimensions.iconM,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              onSubmitted: (_) => _emailFocus.requestFocus(),
            ),
            const SizedBox(height: AppDimensions.space16),

            AppTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: 'Work email',
              hint: 'name@company.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                size: AppDimensions.iconM,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: AppDimensions.space16),

            PasswordField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: 'Password',
              hint: 'At least 8 characters',
              textInputAction: TextInputAction.next,
              validator: Validators.password,
              onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            ),
            const SizedBox(height: AppDimensions.space8),

            // Live password criteria tiles
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
              label: 'Confirm password',
              hint: 'Re-enter your password',
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  Validators.confirmPassword(v, _passwordController.text),
              onSubmitted: (_) => _handleSignup(),
            ),
            const SizedBox(height: AppDimensions.space24),

            AppButton(
              text: 'Continue',
              isLoading: authState.isLoading,
              onPressed: _handleSignup,
            ),

            const SizedBox(height: AppDimensions.space16),

            AuthFooter(
              promptText: 'Already have an account?',
              actionText: 'Sign in',
              onActionPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

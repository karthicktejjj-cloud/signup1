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

/// Screen 2: Login Screen
/// Delivers an intentional, sophisticated entry experience with validated fields,
/// robust loading states, keyboard safe scrolling, and inline feedback.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await ref
        .read(authControllerProvider.notifier)
        .login(email, password);

    if (success && mounted) {
      context.go('/home');
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
              title: 'Welcome back',
              subtitle: 'Enter your credentials to access your secure workspace.',
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
              focusNode: _emailFocusNode,
              label: 'Email address',
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
              onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            ),
            const SizedBox(height: AppDimensions.space20),

            PasswordField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              label: 'Password',
              hint: 'Enter your password',
              textInputAction: TextInputAction.done,
              validator: (v) => Validators.password(v, minLength: 6),
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: AppDimensions.space8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: authState.isLoading
                    ? null
                    : () => context.push('/forgot-password'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8,
                    vertical: AppDimensions.space4,
                  ),
                ),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),

            AppButton(
              text: 'Sign In',
              isLoading: authState.isLoading,
              onPressed: _handleLogin,
            ),

            const SizedBox(height: AppDimensions.space24),

            AuthFooter(
              promptText: "Don't have an account?",
              actionText: 'Create an account',
              onActionPressed: () => context.push('/signup'),
            ),
          ],
        ),
      ),
    );
  }
}

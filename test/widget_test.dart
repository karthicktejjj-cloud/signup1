import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:signup/features/auth/presentation/screens/login_screen.dart';
import 'package:signup/features/auth/presentation/screens/signup_screen.dart';
import 'package:signup/features/home/presentation/screens/home_screen.dart';
import 'package:signup/shared/widgets/app_button.dart';
import 'package:signup/shared/widgets/app_text_field.dart';
import 'package:signup/shared/widgets/otp_input_field.dart';

void main() {
  testWidgets('AppButton renders text and triggers callback when enabled', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Submit Request',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Submit Request'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(pressed, isTrue);
  });

  testWidgets('AppButton shows progress indicator when isLoading is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Loading Action',
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading Action'), findsOneWidget);
  });

  testWidgets('AppTextField displays validation error message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            autovalidateMode: AutovalidateMode.always,
            child: AppTextField(
              label: 'Email',
              validator: (v) => 'Invalid email address',
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Invalid email address'), findsOneWidget);
  });

  testWidgets('OtpInputField renders required digit boxes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpInputField(
            length: 6,
            onCompleted: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(TextFormField), findsNWidgets(6));
  });

  testWidgets('LoginScreen renders inputs and action controls', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
  });

  testWidgets('SignupScreen renders registration inputs and criteria', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SignupScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Work email'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen renders email field and submit action', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Reset password'), findsOneWidget);
    expect(find.text('Send Code'), findsOneWidget);
  });

  testWidgets('HomeScreen renders authenticated portal state', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('APEX PORTAL'), findsOneWidget);
    expect(find.text('Session Active'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });
}

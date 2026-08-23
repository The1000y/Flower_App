import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_outlined_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/features/auth/presentation/login/view/login_view.dart';
import 'package:flower_app/features/auth/presentation/login/view/widgets/remember_custom.dart';
import 'package:flower_app/features/auth/presentation/login/view/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/auth_test_helpers.dart';

Widget _app(FakeAuthRepo repo) {
  return MaterialApp(
    onGenerateRoute: (settings) => switch (settings.name) {
      Routes.mainLayout => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Main Layout Screen')),
        ),
      Routes.signUp => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Sign Up Screen')),
        ),
      Routes.forgotPassword => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Forgot Password Screen')),
        ),
      _ => null,
    },
    home: BlocProvider(
      create: (_) => buildLoginViewModel(repo),
      child: const LoginView(),
    ),
  );
}

Future<void> _pumpLogin(WidgetTester tester, FakeAuthRepo repo) async {
  useInMemorySecureStorage();
  await tester.pumpWidget(_app(repo));
  await tester.pump();
}

Finder _loginButton() => find.widgetWithText(CustomButton, 'Login');

void main() {
  group('LoginView widget', () {
    testWidgets('renders email, password and buttons', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(_loginButton(), findsOneWidget);
      expect(find.text('Continue as guest'), findsOneWidget);
      expect(find.byType(RememberCustom), findsOneWidget);
      expect(find.byType(SignupWidget), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.tap(_loginButton());
      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('validates email format', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(_loginButton());
      await tester.pump();

      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Enter a valid email'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('remember me checkbox does not appear preset', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('remember me toggles when tapping the label', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.tap(find.text('Remember me'));
      await tester.pump();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('remember me toggles when tapping the checkbox', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('typing password does not clear the email', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        validEmail,
      );
      await tester.pump();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        validPassword,
      );
      await tester.pump();

      final emailField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Email'),
      );
      expect(emailField.controller!.text, validEmail);
    });

    testWidgets('password field hides and shows text with toggle',
        (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      final passwordField = tester.widget<CustomTextFormField>(
        find.widgetWithText(CustomTextFormField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      final afterToggle = tester.widget<CustomTextFormField>(
        find.widgetWithText(CustomTextFormField, 'Password'),
      );
      expect(afterToggle.obscureText, isFalse);
    });

    testWidgets('restore does not overwrite email the user just typed',
        (tester) async {
      useInMemorySecureStorage({'remembered_email': 'old@example.com'});
      await tester.pumpWidget(_app(FakeAuthRepo()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        validEmail,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      final emailField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Email'),
      );
      expect(emailField.controller!.text, validEmail);
    });

    testWidgets('pre-fills remembered email on startup', (tester) async {
      useInMemorySecureStorage({'remembered_email': 'saved@example.com'});
      await tester.pumpWidget(_app(FakeAuthRepo()));
      await tester.pump();
      await tester.pump();

      final emailField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Email'),
      );
      expect(emailField.controller!.text, 'saved@example.com');

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('shows success snackbar and navigates on valid login',
        (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        validEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        validPassword,
      );
      await tester.pump();

      await tester.tap(_loginButton());
      await tester.pump();
      await tester.pump();

      expect(find.text('Login successful'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Main Layout Screen'), findsOneWidget);
    });

    testWidgets('shows error snackbar on failed login', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo(shouldSucceed: false));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        validEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        validPassword,
      );
      await tester.pump();

      await tester.tap(_loginButton());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('something went wrong, pls try again'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('saves remembered email after successful login with remember me',
        (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        validEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        validPassword,
      );
      await tester.pump();

      await tester.tap(_loginButton());
      await tester.pump();
      await tester.pump();

      expect(await readStorageValue('remembered_email'), validEmail);
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('deletes remembered email after login without remember me',
        (tester) async {
      useInMemorySecureStorage({'remembered_email': validEmail});
      await tester.pumpWidget(_app(FakeAuthRepo()));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        validPassword,
      );
      await tester.pump();

      await tester.tap(_loginButton());
      await tester.pump();
      await tester.pump();

      expect(await readStorageValue('remembered_email'), isNull);
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('continue as guest navigates to home', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.tap(
        find.widgetWithText(CustomOutlinedButton, 'Continue as guest'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Main Layout Screen'), findsOneWidget);
    });

    testWidgets('sign up link navigates to sign up route', (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.ensureVisible(find.byType(SignupWidget));
      await tester.pump();

      final richFinder = find.descendant(
        of: find.byType(SignupWidget),
        matching: find.byType(RichText),
      );
      final glyphOffset = tester
          .renderObject<RenderParagraph>(richFinder)
          .getOffsetForCaret(
            const TextPosition(offset: 26),
            Rect.zero,
          );
      final topLeft = tester.getTopLeft(richFinder);
      await tester.tapAt(topLeft + glyphOffset + const Offset(0, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Sign Up Screen'), findsOneWidget);
    });

    testWidgets('forgot password navigates to forgot password route',
        (tester) async {
      await _pumpLogin(tester, FakeAuthRepo());

      await tester.tap(find.text('Forget password?'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password Screen'), findsOneWidget);
    });
  });
}
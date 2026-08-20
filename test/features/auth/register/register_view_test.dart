import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/features/auth/presentation/register/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/register_test_helpers.dart';

Widget _app(FakeAuthRepo repo) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
      initialRoute: '/register_test',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/register_test':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => buildRegisterViewModel(repo),
                child: const RegisterView(),
              ),
            );
          case Routes.login:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Login Screen')),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Placeholder()),
            );
        }
      },
    ),
  );
}

Future<void> _pumpRegister(WidgetTester tester, FakeAuthRepo repo) async {
  await tester.pumpWidget(_app(repo));
  await tester.pump();
}

Finder _signUpButton() => find.widgetWithText(CustomButton, AppStrings.signUp);

Future<void> _fillValidFields(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(CustomTextFormField, AppStrings.firstNameLabel),
    'John',
  );
  await tester.enterText(
    find.widgetWithText(CustomTextFormField, AppStrings.lastNameLabel),
    'Doe',
  );
  await tester.enterText(
    find.widgetWithText(CustomTextFormField, AppStrings.emailLabel),
    validEmail,
  );
  await tester.enterText(
    find.widgetWithText(CustomTextFormField, AppStrings.passwordLabel),
    validPassword,
  );
  await tester.enterText(
    find
        .widgetWithText(CustomTextFormField, AppStrings.confirmPasswordLabel)
        .first,
    validPassword,
  );
  await tester.enterText(
    find.widgetWithText(CustomTextFormField, AppStrings.phoneNumberLabel),
    '01012345678',
  );
  await tester.pump();
}

void main() {
  group('RegisterView widget', () {
    testWidgets('renders all form fields and the sign up button', (tester) async {
      await _pumpRegister(tester, FakeAuthRepo());

      expect(
        find.widgetWithText(CustomTextFormField, AppStrings.firstNameLabel),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CustomTextFormField, AppStrings.lastNameLabel),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CustomTextFormField, AppStrings.emailLabel),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CustomTextFormField, AppStrings.passwordLabel),
        findsOneWidget,
      );
      expect(
        find
            .widgetWithText(
              CustomTextFormField,
              AppStrings.confirmPasswordLabel,
            )
            .first,
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CustomTextFormField, AppStrings.phoneNumberLabel),
        findsOneWidget,
      );
      expect(_signUpButton(), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await _pumpRegister(tester, FakeAuthRepo());

      await tester.ensureVisible(_signUpButton());
      await tester.tap(_signUpButton());
      await tester.pump();

      expect(find.text(AppStrings.firstNameRequired), findsOneWidget);
      expect(find.text(AppStrings.lastNameRequired), findsOneWidget);
      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsOneWidget);
      expect(find.text(AppStrings.confirmPasswordRequired), findsOneWidget);
      expect(find.text(AppStrings.phoneRequired), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('successful registration navigates to login', (tester) async {
      await _pumpRegister(tester, FakeAuthRepo());

      await _fillValidFields(tester);

      await tester.ensureVisible(_signUpButton());
      await tester.tap(_signUpButton());
      await tester.pump();
      await tester.pump();

      expect(find.text(AppStrings.registerSuccess), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('failed registration shows an error snackbar', (tester) async {
      await _pumpRegister(tester, FakeAuthRepo(shouldSucceed: false));

      await _fillValidFields(tester);

      await tester.ensureVisible(_signUpButton());
      await tester.tap(_signUpButton());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('something went wrong, pls try again'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 5));
    });
  });
}
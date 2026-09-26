import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/auth/presentation/register/view/register_view.dart';
import 'package:flower_app/features/auth/presentation/register/view/widgets/register_custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/auth_test_helpers.dart';

/// The register view pops itself back onto the previous route once the
/// registration succeeds, so the test navigator is seeded with a login screen
/// underneath it and assertions target that screen.
final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

const String _loginScreenLabel = 'Login Screen';

Widget _app(FakeAuthRepo repo) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
      navigatorKey: _navKey,
      initialRoute: Routes.login,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.login:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text(_loginScreenLabel)),
            );
          case '/register_test':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => buildRegisterViewModel(repo),
                child: const RegisterView(),
              ),
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

  _navKey.currentState!.pushNamed('/register_test');
  await tester.pump();
  await tester.pump();
}

Finder _signUpButton() => find.widgetWithText(CustomButton, AppStrings.signUp);

/// Matches on the field's `label` property rather than rendered text:
/// `find.text` substring-matches, and the confirm-password field's label and
/// hint are both "Confirm password", so a text-based finder is ambiguous.
Finder _fieldWithLabel(String label) => find.byWidgetPredicate(
  (widget) => widget is RegisterCustomTextFormField && widget.label == label,
);

Future<void> _fillValidFields(WidgetTester tester) async {
  await tester.enterText(_fieldWithLabel(AppStrings.firstNameLabel), 'John');
  await tester.enterText(_fieldWithLabel(AppStrings.lastNameLabel), 'Doe');
  await tester.enterText(_fieldWithLabel(AppStrings.emailLabel), validEmail);
  await tester.enterText(
    _fieldWithLabel(AppStrings.passwordLabel),
    validRegisterPassword,
  );
  await tester.enterText(
    _fieldWithLabel(AppStrings.confirmPasswordLabel),
    validRegisterPassword,
  );
  await tester.enterText(
    _fieldWithLabel(AppStrings.phoneNumberLabel),
    '01012345678',
  );
  await tester.pump();
}

Future<void> _tapSignUp(WidgetTester tester) async {
  await tester.ensureVisible(_signUpButton());
  await tester.tap(_signUpButton());
  await tester.pump();
}

void main() {
  group('RegisterView widget', () {
    testWidgets('renders all form fields and the sign up button', (
      tester,
    ) async {
      await _pumpRegister(tester, FakeAuthRepo());

      expect(_fieldWithLabel(AppStrings.firstNameLabel), findsOneWidget);
      expect(_fieldWithLabel(AppStrings.lastNameLabel), findsOneWidget);
      expect(_fieldWithLabel(AppStrings.emailLabel), findsOneWidget);
      expect(_fieldWithLabel(AppStrings.passwordLabel), findsOneWidget);
      expect(_fieldWithLabel(AppStrings.confirmPasswordLabel), findsOneWidget);
      expect(_fieldWithLabel(AppStrings.phoneNumberLabel), findsOneWidget);
      expect(_signUpButton(), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (
      tester,
    ) async {
      await _pumpRegister(tester, FakeAuthRepo());

      await _tapSignUp(tester);

      expect(find.text(AppStrings.firstNameRequired), findsOneWidget);
      expect(find.text(AppStrings.lastNameRequired), findsOneWidget);
      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsOneWidget);
      expect(find.text(AppStrings.confirmPasswordRequired), findsOneWidget);
      expect(find.text(AppStrings.phoneRequired), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('sends the trimmed form values to the view model', (
      tester,
    ) async {
      final repo = FakeAuthRepo();
      await _pumpRegister(tester, repo);

      await _fillValidFields(tester);
      await _tapSignUp(tester);
      await tester.pump();

      final request = repo.lastRegisterRequest;
      expect(request, isNotNull);
      expect(request!.fullName, 'John Doe');
      expect(request.email, validEmail);
      expect(request.password, validRegisterPassword);
      expect(request.confirmPassword, validRegisterPassword);
      expect(request.phoneNumber, '01012345678');
      expect(request.gender, 1);

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('successful registration returns to the login screen', (
      tester,
    ) async {
      await _pumpRegister(tester, FakeAuthRepo());

      await _fillValidFields(tester);
      await _tapSignUp(tester);
      await tester.pump();

      expect(find.text(AppStrings.registerSuccess), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text(_loginScreenLabel), findsOneWidget);
      expect(find.byType(RegisterView), findsNothing);
    });

    testWidgets('failed registration shows an error snackbar', (tester) async {
      await _pumpRegister(tester, FakeAuthRepo(shouldSucceed: false));

      await _fillValidFields(tester);
      await _tapSignUp(tester);
      await tester.pump();

      // The listener calls hideCurrentSnackBar() before showSnackBar(), so the
      // outgoing snackbar can still be in the tree; assert on the content
      // rather than counting SnackBar widgets.
      expect(find.text('something went wrong, pls try again'), findsWidgets);
      expect(
        find.widgetWithText(SnackBar, 'something went wrong, pls try again'),
        findsWidgets,
      );

      // The failed attempt must keep the user on the register screen.
      expect(find.byType(RegisterView), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });
  });
}

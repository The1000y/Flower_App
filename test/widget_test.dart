import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flower_app/features/auth/presentation/login/view/login_view.dart';

const _validEmail = 'bassiony555@gmail.com';
const _validPassword = '12345678';

class _SuccessAuthRepo implements AuthRepo {
  @override
  Future<BaseResponce<LoginEntity>> login(RequestLogin req) async {
    return SuccessResponce(
      const LoginEntity(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresIn: 900,
        driverStatus: 'Approved',
      ),
    );
  }
}

class _ErrorAuthRepo implements AuthRepo {
  @override
  Future<BaseResponce<LoginEntity>> login(RequestLogin req) async {
    return ErrorResponce(Exception('login failed'));
  }
}

class _DelayedStoragePlatform extends TestFlutterSecureStoragePlatform {
  _DelayedStoragePlatform(super.data);

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return super.read(key: key, options: options);
  }
}

void _useInMemorySecureStorage() {
  FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({});
}

Widget _app(AuthRepo repo) {
  return MaterialApp(
    routes: {
      Routes.mainLayout: (_) => const Scaffold(body: Placeholder()),
    },
    home: BlocProvider(
      create: (_) => LoginViewModel(
        LoginUseCase(repo),
        SecureStorageService(const FlutterSecureStorage()),
      ),
      child: const LoginView(),
    ),
  );
}

Future<void> _pumpLogin(WidgetTester tester, AuthRepo repo) async {
  _useInMemorySecureStorage();
  await tester.pumpWidget(_app(repo));
  await tester.pump();
}

Finder _loginButton() => find.widgetWithText(CustomButton, 'Login');

void main() {
  testWidgets('renders email, password and buttons', (tester) async {
    await _pumpLogin(tester, _SuccessAuthRepo());

    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(_loginButton(), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await _pumpLogin(tester, _SuccessAuthRepo());

    await tester.tap(_loginButton());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Email is required'), findsNWidgets(2));
    expect(find.text('Password is required'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('remember me toggles when tapping the label', (tester) async {
    await _pumpLogin(tester, _SuccessAuthRepo());

    await tester.tap(find.text('Remember me'));
    await tester.pump();

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);
  });

  testWidgets('typing password does not clear the email', (tester) async {
    await _pumpLogin(tester, _SuccessAuthRepo());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      _validEmail,
    );
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      _validPassword,
    );
    await tester.pump();

    final emailField = tester.widget<TextFormField>(
      find.widgetWithText(TextFormField, 'Email'),
    );
    expect(emailField.controller!.text, _validEmail);
  });

  testWidgets('restore does not overwrite email the user just typed',
      (tester) async {
    FlutterSecureStoragePlatform.instance = _DelayedStoragePlatform({
      'remembered_email': 'old@example.com',
    });
    await tester.pumpWidget(_app(_SuccessAuthRepo()));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      _validEmail,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    final emailField = tester.widget<TextFormField>(
      find.widgetWithText(TextFormField, 'Email'),
    );
    expect(emailField.controller!.text, _validEmail);
  });

  testWidgets('shows success snackbar and navigates on valid login',
      (tester) async {
    await _pumpLogin(tester, _SuccessAuthRepo());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      _validEmail,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      _validPassword,
    );
    await tester.pump();

    await tester.tap(_loginButton());
    await tester.pump();
    await tester.pump();

    expect(find.text('Login successful'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(Placeholder), findsOneWidget);
  });

  testWidgets('shows error snackbar on failed login', (tester) async {
    await _pumpLogin(tester, _ErrorAuthRepo());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      _validEmail,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      _validPassword,
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
}

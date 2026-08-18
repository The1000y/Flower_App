import 'package:flower_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

class _Harness {
  _Harness({FakeAuthRepo? repo}) : repo = repo ?? FakeAuthRepo() {
    useInMemorySecureStorage();
    viewModel = buildLoginViewModel(this.repo);
  }

  final FakeAuthRepo repo;
  late final LoginViewModel viewModel;
}

void main() {
  group('LoginViewModel', () {
    test('initial state is empty', () {
      final harness = _Harness();
      expect(harness.viewModel.state.email, '');
      expect(harness.viewModel.state.password, '');
      expect(harness.viewModel.state.rememberMe, isFalse);
      expect(harness.viewModel.state.loginSuccess, isFalse);
      expect(harness.viewModel.state.isLoading, isFalse);
    });

    test('EmailChanged updates email and clears error', () async {
      final harness = _Harness(repo: FakeAuthRepo(shouldSucceed: false));
      harness.viewModel.handle(EmailChanged(validEmail));
      harness.viewModel.handle(PasswordChanged(validPassword));
      await harness.viewModel.handle(LoginPressed());
      expect(harness.viewModel.state.errorMessage, isNotEmpty);

      harness.viewModel.handle(EmailChanged(validEmail));

      expect(harness.viewModel.state.email, validEmail);
      expect(harness.viewModel.state.errorMessage, '');
    });

    test('PasswordChanged updates password and clears error', () {
      final harness = _Harness();
      harness.viewModel.handle(PasswordChanged(validPassword));

      expect(harness.viewModel.state.password, validPassword);
    });

    test('RememberMeChanged updates rememberMe flag', () {
      final harness = _Harness();
      harness.viewModel.handle(RememberMeChanged(true));

      expect(harness.viewModel.state.rememberMe, isTrue);
    });

    test('ValidationFailed sets errorMessage without loading login', () {
      final harness = _Harness();
      harness.viewModel.handle(ValidationFailed('bad input'));

      expect(harness.viewModel.state.errorMessage, 'bad input');
      expect(harness.viewModel.state.isLoading, isFalse);
      expect(harness.viewModel.state.loginSuccess, isFalse);
    });

    test(
        'LoadRememberedEmail restores saved email and sets rememberMe when email empty',
        () async {
      useInMemorySecureStorage({'remembered_email': 'saved@example.com'});
      final viewModel = buildLoginViewModel(FakeAuthRepo());

      await viewModel.handle(LoadRememberedEmail());

      expect(viewModel.state.email, 'saved@example.com');
      expect(viewModel.state.rememberMe, isTrue);
    });

    test('LoadRememberedEmail does not overwrite already typed email', () async {
      useInMemorySecureStorage({'remembered_email': 'old@example.com'});
      final viewModel = buildLoginViewModel(FakeAuthRepo());

      viewModel.handle(EmailChanged(validEmail));
      await viewModel.handle(LoadRememberedEmail());

      expect(viewModel.state.email, validEmail);
      expect(viewModel.state.rememberMe, isFalse);
    });

    test('LoadRememberedEmail does nothing when no saved email', () async {
      final harness = _Harness();
      await harness.viewModel.handle(LoadRememberedEmail());

      expect(harness.viewModel.state.email, '');
      expect(harness.viewModel.state.rememberMe, isFalse);
    });

    test('login success sets LoginEntity and loginSuccess true', () async {
      final harness = _Harness();
      harness.viewModel.handle(EmailChanged(validEmail));
      harness.viewModel.handle(PasswordChanged(validPassword));

      await harness.viewModel.handle(LoginPressed());

      final state = harness.viewModel.state;
      expect(state.loginSuccess, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, '');
      expect(state.data, isNotNull);
    });

    test('login success with rememberMe saves email to storage', () async {
      useInMemorySecureStorage();
      final viewModel = buildLoginViewModel(FakeAuthRepo());

      viewModel.handle(EmailChanged(validEmail));
      viewModel.handle(PasswordChanged(validPassword));
      viewModel.handle(RememberMeChanged(true));

      await viewModel.handle(LoginPressed());

      expect(await readStorageValue('remembered_email'), validEmail);
    });

    test('login success without rememberMe deletes saved email', () async {
      useInMemorySecureStorage({'remembered_email': 'old@example.com'});
      final viewModel = buildLoginViewModel(FakeAuthRepo());

      viewModel.handle(EmailChanged(validEmail));
      viewModel.handle(PasswordChanged(validPassword));
      viewModel.handle(RememberMeChanged(false));

      await viewModel.handle(LoginPressed());

      expect(await readStorageValue('remembered_email'), isNull);
    });

    test('login failure sets errorMessage and clears loading', () async {
      final harness = _Harness(repo: FakeAuthRepo(shouldSucceed: false));
      harness.viewModel.handle(EmailChanged(validEmail));
      harness.viewModel.handle(PasswordChanged(validPassword));

      await harness.viewModel.handle(LoginPressed());

      final state = harness.viewModel.state;
      expect(state.loginSuccess, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNotEmpty);
    });

    test('login passes LoginCredentials to the repo', () async {
      final harness = _Harness();
      harness.viewModel.handle(EmailChanged(validEmail));
      harness.viewModel.handle(PasswordChanged(validPassword));

      await harness.viewModel.handle(LoginPressed());

      expect(harness.repo.lastRequest?.email, validEmail);
      expect(harness.repo.lastRequest?.password, validPassword);
    });

    test('login emits loading while in progress', () async {
      useInMemorySecureStorage();
      final viewModel = buildLoginViewModel(
        FakeAuthRepo(failDelay: const Duration(milliseconds: 50)),
      );

      viewModel.handle(EmailChanged(validEmail));
      viewModel.handle(PasswordChanged(validPassword));

      final future = viewModel.handle(LoginPressed());
      expect(viewModel.state.isLoading, isTrue);

      await future;
      expect(viewModel.state.isLoading, isFalse);
    });
  });
}
sealed class LoginIntent {}

class LoadRememberedEmail extends LoginIntent {}

class LoginPressed extends LoginIntent {}

class EmailChanged extends LoginIntent {
  final String email;

  EmailChanged(this.email);
}

class PasswordChanged extends LoginIntent {
  final String password;

  PasswordChanged(this.password);
}

class RememberMeChanged extends LoginIntent {
  final bool value;

  RememberMeChanged(this.value);
}

class TogglePasswordVisibility extends LoginIntent {}

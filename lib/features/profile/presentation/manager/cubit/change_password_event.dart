sealed class ChangePasswordEvent {}

class UpdatePasswordEvent extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  UpdatePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

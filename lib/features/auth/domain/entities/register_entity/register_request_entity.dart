class RegisterRequestEntity {

final String fullName;
final String email;
final String phoneNumber;
final int gender; // Note: Assuming int based on your example (1)
final String password;
final String confirmPassword;

// Constructor with 'required' named parameters
RegisterRequestEntity({
required this.fullName,
required this.email,
required this.phoneNumber,
required this.gender,
required this.password,
required this.confirmPassword,
});
}
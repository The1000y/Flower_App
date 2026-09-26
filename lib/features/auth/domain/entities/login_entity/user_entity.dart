class UserEntity {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String role;
  final String? photoUrl;
  final String status;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.role,
    this.photoUrl,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'status': status,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
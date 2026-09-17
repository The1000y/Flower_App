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
      'photoUrl': photoUrl,
      'status': status,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      role: json['role'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      status: json['status'] as String? ?? '',
    );
  }
}

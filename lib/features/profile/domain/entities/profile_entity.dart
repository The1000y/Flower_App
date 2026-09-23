import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
    final String firstName;
    final String lastName;
    final String email;
    final String phoneNumber;
    final String gender;
    final String? photoUrl;

    const ProfileEntity({
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.phoneNumber,
        required this.gender,
        this.photoUrl,
    });

    @override
    List<Object?> get props => [firstName, lastName, email, phoneNumber, gender, photoUrl];
}
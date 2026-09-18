//import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
// import 'package:injectable/injectable.dart';
//
// import '../../../../config/base/base_responce.dart';
// import '../../domain/repo/profile_repo.dart';
//
// const _dummyUserEntity = UserEntity(
//   id: 1,
//   fullName: "John Doe",
//   email: "john.doe@example.com",
//   phoneNumber: "+1234567890",
//   gender: "male",
//   role: "user",
//   status: "active",
// );
//
// @Injectable(as: ProfileRepo)
// class ProfileRepoImpl implements ProfileRepo {
//   @override
//   Future<BaseResponce<UserEntity>> getProfile() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return SuccessResponce(_dummyUserEntity);
//   }
//
//
//
//
// }
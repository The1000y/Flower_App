import 'dart:convert';
import 'dart:developer';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/storage_keys.dart';

import '../../../data/data_source/local_data_source/auth_local_data_source.dart';


@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    // TODO: implement register
    // Check each parameter and exit immediately if one is invalid
    if (request.fullName == null) {
      log("Full name cannot be null");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Full name cannot be null",
          data: false);
      // Or return a specific HTTP 400 response
    } else if (request.email == null) {
      log("Email cannot be null");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Email cannot be null",
          data: false);
    } else if (request.phoneNumber == null) {
      log("Phone number cannot be null");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Phone number cannot be null",
          data: false);
    } else if (request.gender == null) {
      log("Gender cannot be null");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Gender cannot be null",
          data: false);
    } else if (request.password == null) {
      log("Password cannot be null");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Password cannot be null",
          data: false);
    } else if (request.confirmPassword == null) {
      log("Confirm password cannot be null");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Confirm password cannot be null",
          data: false);
    }

// Extra validation: Check if passwords actually match
    else if (request.password != request.confirmPassword) {
      log("Passwords do not match");
      return RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: "Passwords do not match",
          data: false);
    } else {
      return RegisterResponse(
          isSuccess: true,
          errorCode: 200,
          message: "Registration successful",
          data: true);
    }

// If the code reaches here, ALL parameters are valid.
// Proceed with your logic (e.g., saving to the database).
  }
}


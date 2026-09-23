import 'dart:io';

import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      buildWhen: (previous, current) =>
      previous.pickedImagePath != current.pickedImagePath ||
          previous.profileState.data?.photoUrl != current.profileState.data?.photoUrl,
      builder: (context, state) {
        final pickedPath = state.pickedImagePath;
        final photoUrl = state.profileState.data?.photoUrl;
        final ImageProvider? image = pickedPath != null
            ? FileImage(File(pickedPath))
            : (photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null);

        return GestureDetector(
          onTap: () => context.read<ProfileViewModel>().doEvent(PickProfileImageEvent()),
          child: Stack(
            children: [
              CircleAvatar(radius: 40.r, backgroundImage: image),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: AppColors.pinkBase,
                  child: Icon(Icons.camera_alt, size: 14.sp, color: AppColors.whiteBase),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
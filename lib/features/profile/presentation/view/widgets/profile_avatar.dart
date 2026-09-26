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

        return GestureDetector(
          onTap: () => context.read<ProfileViewModel>().doEvent(PickProfileImageEvent()),
          child: Stack(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 80.r,
                  height: 80.r,
                  child: _buildImage(pickedPath, photoUrl),
                ),
              ),
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

  Widget _buildImage(String? pickedPath, String? photoUrl) {
    if (pickedPath != null) {
      return Image.file(
        File(pickedPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return Image.network(
        photoUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return ColoredBox(
      color: AppColors.grayDark.withValues(alpha: 0.1),
      child: Icon(Icons.person, size: 40.sp, color: AppColors.grayDark),
    );
  }
}
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'option_tile.dart';
import 'profile_avatar.dart';

/// Body of the profile tab: header, profile summary, and the options list.
class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.profile,
    required this.onEditProfile,
    required this.onNotification,
    required this.onLanguage,
    required this.onLogout,
  });

  final ProfileEntity? profile;
  final VoidCallback onEditProfile;
  final VoidCallback onNotification;
  final VoidCallback onLanguage;
  final VoidCallback onLogout;

  String get _fullName {
    final profile = this.profile;
    if (profile == null) return '';
    return '${profile.firstName} ${profile.lastName}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: 20.h),
          _buildProfileInfo(),
          SizedBox(height: 20.h),
          _buildProfileOptions(context),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.floweryAppbarTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: onNotification,
            child: Stack(
              children: [
                const Icon(Icons.notifications_none_outlined, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.pinkBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const ProfileAvatar(),
            Positioned(
              right: -4,
              bottom: -2,
              child: GestureDetector(
                onTap: onEditProfile,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.whiteBase,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white70),
                  ),
                  child: const Icon(Icons.edit_outlined, size: 14),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          _fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(height: 4.h),
        Text(
          profile?.email ?? '',
          style: TextStyle(color: AppColors.white90, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return Column(
          children: [
            ProfileOptionTile(
              icon: Icons.receipt_long_outlined,
              title: AppStrings.myOrdersTitle,
              onTap: () => Navigator.pushNamed(context, Routes.myOrders),
            ),
            ProfileOptionTile(
              icon: Icons.bookmark_border,
              title: AppStrings.saveAddress,
              onTap: () => Navigator.pushNamed(context, Routes.savedAddresses),
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              icon: Icons.notifications_none_outlined,
              title: AppStrings.notificationTitle,
              onTap: () => Navigator.pushNamed(context, Routes.notifications),
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              icon: Icons.lock_outline,
              title: AppStrings.actionChange,
              onTap: () => Navigator.pushNamed(context, Routes.changePassword),
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              icon: Icons.language_outlined,
              title: AppStrings.language,
              trailingText: locale.languageCode == 'ar'
                  ? AppStrings.languageArabic
                  : AppStrings.languageEnglish,
              onTap: onLanguage,
            ),
            ProfileOptionTile(
              icon: Icons.info_outline,
              title: AppStrings.aboutUs,
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.description_outlined,
              title: AppStrings.termsAndConditionsAlt,
              onTap: () {},
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              icon: Icons.logout_outlined,
              title: AppStrings.logout,
              onTap: onLogout,
            ),
          ],
        );
      },
    );
  }
}

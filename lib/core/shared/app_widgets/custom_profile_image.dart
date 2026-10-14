import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_svgs/app_svgs.dart';
import '../../themes/app_colors/app_color.dart';

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({super.key, required this.profileImageURL});

  final String? profileImageURL;

  @override
  Widget build(BuildContext context) {
    final bool hasValidUrl =
        profileImageURL != null && profileImageURL!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: hasValidUrl
          ? CachedNetworkImage(
              imageUrl: profileImageURL!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 50,
                height: 50,
                color: AppColors.pinkBase.withValues(alpha: 0.15),
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => SvgPicture.asset(
                AppSvgs.deliveryBoy,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
          : SvgPicture.asset(
              AppSvgs.deliveryBoy,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/utils/helpers/phone_launcher.dart';
import '../../../../config/utils/helpers/whatsapp_launcher.dart';
import '../../../../core/constants/app_svgs/app_svgs.dart';

class CustomContractCard extends StatelessWidget {
  const CustomContractCard({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => phoneLauncher(phoneNumber, context),
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(AppSvgs.phone, width: 22, height: 22),
        ),

        IconButton(
          onPressed: () => whatsAppLauncher(phoneNumber, context),
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(AppSvgs.whatsapp, width: 22, height: 22),
        ),
      ],
    );
  }
}

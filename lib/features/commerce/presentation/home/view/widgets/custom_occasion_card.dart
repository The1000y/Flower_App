// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flower_app/core/constants/apps_images/app_images.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';

import '../../../../../../config/routing/routes.dart';

class OccasionCard extends StatelessWidget {
  final OccasionEntity occasion;
  const OccasionCard({super.key, required this.occasion});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
onTap: () {
Navigator.pushNamed(
context,
Routes.occasion,
arguments: occasion.name,);},
child: SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              occasion.imageUrl,
              width: 131,
              height: 151,
              // cacheWidth: 150,
              // cacheHeight: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppImages.error,
                  fit: BoxFit.cover,
                  width: 131,
                  height: 151,
                  // cacheWidth: 150,
                  // cacheHeight: 200,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            occasion.name,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }
}

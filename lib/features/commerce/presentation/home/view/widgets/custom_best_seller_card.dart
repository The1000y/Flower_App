import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/apps_images/app_images.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flutter/material.dart';

class BestSellerCard extends StatelessWidget {
  final BestSellerEntity bestSellerEntity;
  const BestSellerCard({super.key, required this.bestSellerEntity});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.productDetails,
        arguments: bestSellerEntity.id,
      ),
      child: SizedBox(
        width: 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                bestSellerEntity.imageUrl,
                // cacheWidth: 150,
                // cacheHeight: 200,
                width: 131,
                height: 151,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  AppImages.error,
                  fit: BoxFit.cover,
                  width: 131,
                  height: 151,
                  // cacheWidth: 150,
                  // cacheHeight: 200,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bestSellerEntity.name,
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "${bestSellerEntity.price} ${bestSellerEntity.currency}",
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

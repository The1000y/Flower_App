import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/config/routing/routes.dart';
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
              child: CachedNetworkImage(
                imageUrl: bestSellerEntity.imageUrl,
                width: 131,
                height: 151,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

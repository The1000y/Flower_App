import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_section_type.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/best_seller_section.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/categories_section.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/occasions_section.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/products_carousel_section.dart';
import 'package:flutter/material.dart';

class HomeSectionFactory extends StatelessWidget {
  final HomeEntity section;
  final HomeState state;

  const HomeSectionFactory({
    super.key,
    required this.section,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return switch (section.sectionType) {
      HomeSectionType.categories => CategoriesSection(
          section: section,
          categoriesState: state.categoriesState,
        ),
      HomeSectionType.bestSeller => BestSellerSection(
          section: section,
          bestSellersState: state.bestSellersState,
        ),
      HomeSectionType.occasions => OccasionsSection(
          section: section,
          occasionsState: state.occasionsState,
        ),
      HomeSectionType.productsCarousel => ProductsCarouselSection(
          section: section,
          productsState: state.productsFor(section),
        ),
      HomeSectionType.unknown => const SizedBox.shrink(),
    };
  }
}

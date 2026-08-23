import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_section_type.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/product_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/section_content_view.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_sections/section_header.dart';
import 'package:flutter/material.dart';

class ProductsCarouselSection extends StatelessWidget {
  final HomeEntity section;
  final BaseState<List<ProductEntity>> productsState;

  const ProductsCarouselSection({
    super.key,
    required this.section,
    required this.productsState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.displayTitle != null)
          SectionHeader(title: section.displayTitle!),
        const SizedBox(height: 16),
        SectionContentView<ProductEntity>(
          sectionState: productsState,
          builder: (context, products) => ProductList(products: products),
        ),
      ],
    );
  }
}

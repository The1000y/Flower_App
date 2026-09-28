import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/api/data_source_impl/local/local_data_source_impl.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_dto.dart'
    as best_seller;
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CommerceLocalDataSource dataSource;

  setUp(() {
    dataSource = LocalDataSourceImpl();
  });

  // Cart is served by the remote data source only. These tests lock in that the
  // local data source can never become a silent cart fallback again: the
  // CommerceLocalDataSource contract has no cart members, and every method it
  // does expose fails instead of returning seeded data.
  group('CommerceLocalDataSource', () {
    test('getCategories is not implemented locally', () async {
      final result = await dataSource.getCategories();

      expect(result, isA<ErrorResponce<List<CategoryDto>>>());
      expect(
        (result as ErrorResponce<List<CategoryDto>>).error.toString(),
        contains('Not implemented locally'),
      );
    });

    test('getProducts is not implemented locally', () async {
      final result = await dataSource.getProducts();

      expect(result, isA<ErrorResponce<ProductsResponseDto>>());
    });

    test('getBestSellers is not implemented locally', () async {
      final result = await dataSource.getBestSellers();

      expect(result, isA<ErrorResponce<List<best_seller.ProductDto>>>());
    });

    test('getSections is not implemented locally', () async {
      final result = await dataSource.getSections();

      expect(result, isA<ErrorResponce<List<SectionDto>>>());
    });

    test('getOccasions is not implemented locally', () async {
      final result = await dataSource.getOccasions();

      expect(result, isA<ErrorResponce<List<OccasionDto>>>());
    });

    test('getProductsForOccasion is not implemented locally', () async {
      final result = await dataSource.getProductsForOccasion('1');

      expect(result, isA<ErrorResponce<ProductsResponseDto>>());
    });
  });
}

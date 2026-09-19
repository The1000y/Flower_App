import 'package:flower_app/features/commerce/data/repo_impl/commerce_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_dto.dart'
    as best_seller;
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/add_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/request/cart_request/update_cart_item_request_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_item_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/cart_response/cart_response_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/models/cart/add_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/models/cart/update_cart_item_params.dart';

class MockCommerceRemoteDataSource extends Mock
    implements CommerceRemoteDataSource {}

class MockCommerceLocalDataSource extends Mock
    implements CommerceLocalDataSource {}

void main() {
  late MockCommerceRemoteDataSource mockRemoteDataSource;
  late MockCommerceLocalDataSource mockLocalDataSource;
  late CommerceRepoImpl commerceRepo;

  setUpAll(() {
    registerFallbackValue(AddCartItemRequestDto(productId: 0, quantity: 0));
    registerFallbackValue(UpdateCartItemRequestDto(quantity: 0));
  });

  setUp(() {
    mockRemoteDataSource = MockCommerceRemoteDataSource();
    mockLocalDataSource = MockCommerceLocalDataSource();
    commerceRepo = CommerceRepoImpl(mockLocalDataSource, mockRemoteDataSource);
  });

  group('getOccasions', () {
    test(
      'should return SuccessResponce<List<OccasionEntity>> when local data source succeeds',
      () async {
        final occasionDto = OccasionDto(
          id: 1,
          name: 'Birthday',
          imageUrl: 'https://example.com/birthday.png',
        );

        when(() => mockLocalDataSource.getOccasions()).thenAnswer(
          (_) async => SuccessResponce<List<OccasionDto>>([occasionDto]),
        );

        final result = await commerceRepo.getOccasions();

        expect(result, isA<SuccessResponce<List<OccasionEntity>>>());
        final data = (result as SuccessResponce<List<OccasionEntity>>).data;
        expect(data.length, 1);
        expect(data.first.id, 1);
        expect(data.first.name, 'Birthday');
        expect(data.first.imageUrl, 'https://example.com/birthday.png');
        verify(() => mockLocalDataSource.getOccasions()).called(1);
      },
    );

    test('should return ErrorResponce when local data source fails', () async {
      final exception = Exception('Failed to get occasions');
      when(
        () => mockLocalDataSource.getOccasions(),
      ).thenAnswer((_) async => ErrorResponce<List<OccasionDto>>(exception));

      final result = await commerceRepo.getOccasions();

      expect(result, isA<ErrorResponce<List<OccasionEntity>>>());
      verify(() => mockLocalDataSource.getOccasions()).called(1);
    });
  });

  group('getOccasionsProducts', () {
    test(
      'should return SuccessResponce<PaginatedProducts> when remote data source succeeds',
      () async {
        final productDto = ProductDto(
          id: 1,
          name: 'Red Rose',
          imageUrl: 'https://example.com/rose.png',
          currency: 'EGP',
          price: 250,
          originalPrice: 300,
          discountPercentage: 16.67,
          status: 'Available',
        );

        final paginationDto = PaginationDto(
          page: 1,
          pageSize: 10,
          totalPages: 1,
          totalCount: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        );

        final responseDto = ProductsResponseDto(
          data: ProductListDataDto(
            items: [productDto],
            pagination: paginationDto,
          ),
          isSuccess: true,
          message: 'Success',
          errorCode: '',
        );

        when(() => mockRemoteDataSource.getProducts(1, page: 1)).thenAnswer(
          (_) async => SuccessResponce<ProductsResponseDto>(responseDto),
        );

        final result = await commerceRepo.getOccasionsProducts(1, page: 1);

        expect(result, isA<SuccessResponce<PaginatedProducts>>());
        final data = (result as SuccessResponce<PaginatedProducts>).data;
        expect(data.items.length, 1);
        expect(data.items.first.id, 1);
        expect(data.items.first.name, 'Red Rose');
        expect(data.items.first.price, 250);
        expect(data.pagination.page, 1);
        verify(() => mockRemoteDataSource.getProducts(1, page: 1)).called(1);
      },
    );

    test('should return ErrorResponce when remote data source fails', () async {
      final exception = Exception('Failed to get products');
      when(
        () => mockRemoteDataSource.getProducts(1, page: 1),
      ).thenAnswer((_) async => ErrorResponce<ProductsResponseDto>(exception));

      final result = await commerceRepo.getOccasionsProducts(1, page: 1);

      expect(result, isA<ErrorResponce<PaginatedProducts>>());
      verify(() => mockRemoteDataSource.getProducts(1, page: 1)).called(1);
    });
  });

  group('getCategories', () {
    test(
      'should return SuccessResponce with mapped categories when local data source succeeds',
      () async {
        final categoryDto = CategoryDto(
          id: 1,
          name: 'Roses',
          iconUrl: 'https://example.com/rose.png',
        );

        when(() => mockLocalDataSource.getCategories()).thenAnswer(
          (_) async => SuccessResponce<List<CategoryDto>>([categoryDto]),
        );

        final result = await commerceRepo.getCategories();

        expect(result, isA<SuccessResponce<List<CategoryEntity>>>());

        final success = result as SuccessResponce<List<CategoryEntity>>;

        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.name, 'Roses');
        expect(success.data.first.iconUrl, 'https://example.com/rose.png');

        verify(() => mockLocalDataSource.getCategories()).called(1);
      },
    );

    test('should return ErrorResponce when local data source fails', () async {
      final exception = Exception('Failed to get categories');

      when(
        () => mockLocalDataSource.getCategories(),
      ).thenAnswer((_) async => ErrorResponce<List<CategoryDto>>(exception));

      final result = await commerceRepo.getCategories();
      expect(result, isA<ErrorResponce<List<CategoryEntity>>>());

      verify(() => mockLocalDataSource.getCategories()).called(1);
    });
  });

  group('getBestSeller', () {
    test('should return SuccessResponce with mapped best sellers', () async {
      final productDto = best_seller.ProductDto(
        id: 1,
        name: 'Red Rose Bouquet',
        imageUrl: 'https://example.com/rose.png',
        currency: 'SAR',
        price: 150,
        originalPrice: 200,
        discountPercentage: 25,
        status: 'available',
      );

      when(() => mockLocalDataSource.getBestSellers()).thenAnswer(
        (_) async =>
            SuccessResponce<List<best_seller.ProductDto>>([productDto]),
      );

      final result = await commerceRepo.getBestSeller();

      expect(result, isA<SuccessResponce<List<BestSellerEntity>>>());

      final success = result as SuccessResponce<List<BestSellerEntity>>;

      expect(success.data.length, 1);
      expect(success.data.first.id, 1);
      expect(success.data.first.name, 'Red Rose Bouquet');

      verify(() => mockLocalDataSource.getBestSellers()).called(1);
    });
  });

  group('cart operations', () {
    final responseDto = CartResponseDto(
      data: CartDataDto(
        items: [
          CartItemResponseDto(
            id: 'item-1',
            productId: 1,
            productName: 'Rose Bouquet',
            productImageUrl: 'https://example.com/rose.jpg',
            unitPrice: 200,
            quantity: 2,
            lineSubtotal: 400,
            inStock: true,
            priceChanged: false,
          ),
        ],
        subtotal: 400,
        deliveryFee: 20,
        total: 420,
        hasChanges: false,
      ),
      isSuccess: true,
      message: 'Success',
      messageLocalized: 'Success',
      statusCode: '200',
    );

    test('getCart maps the local datasource response', () async {
      when(
        () => mockLocalDataSource.getCart(),
      ).thenAnswer((_) async => SuccessResponce(responseDto));

      final result = await commerceRepo.getCart();

      expect(result, isA<SuccessResponce<CartEntity>>());
      final cart = (result as SuccessResponce<CartEntity>).data;
      expect(cart.items.single.productName, 'Rose Bouquet');
      expect(cart.total, 420);
      verify(() => mockLocalDataSource.getCart()).called(1);
    });

    test('getCart returns datasource errors', () async {
      when(() => mockLocalDataSource.getCart()).thenAnswer(
        (_) async => ErrorResponce<CartResponseDto>(Exception('failed')),
      );

      final result = await commerceRepo.getCart();

      expect(result, isA<ErrorResponce<CartEntity>>());
    });

    test('addToCart maps the response and passes request values', () async {
      when(
        () => mockLocalDataSource.addToCart(any()),
      ).thenAnswer((_) async => SuccessResponce(responseDto));

      final result = await commerceRepo.addToCart(
        const AddCartItemParams(productId: 7, quantity: 3),
      );

      expect(result, isA<SuccessResponce<CartEntity>>());
      final request =
          verify(
                () => mockLocalDataSource.addToCart(captureAny()),
              ).captured.single
              as AddCartItemRequestDto;
      expect(request.productId, 7);
      expect(request.quantity, 3);
    });

    test('addToCart returns datasource errors', () async {
      when(() => mockLocalDataSource.addToCart(any())).thenAnswer(
        (_) async => ErrorResponce<CartResponseDto>(Exception('failed')),
      );

      final result = await commerceRepo.addToCart(
        const AddCartItemParams(productId: 7, quantity: 3),
      );

      expect(result, isA<ErrorResponce<CartEntity>>());
    });

    test('updateCartItemQuantity passes id and quantity', () async {
      when(
        () => mockLocalDataSource.updateCartItemQuantity(any(), any()),
      ).thenAnswer((_) async => SuccessResponce(responseDto));

      final result = await commerceRepo.updateCartItemQuantity(
        'item-1',
        const UpdateCartItemParams(quantity: 5),
      );

      expect(result, isA<SuccessResponce<CartEntity>>());
      final captured = verify(
        () => mockLocalDataSource.updateCartItemQuantity(
          captureAny(),
          captureAny(),
        ),
      ).captured;
      expect(captured[0], 'item-1');
      expect((captured[1] as UpdateCartItemRequestDto).quantity, 5);
    });

    test('updateCartItemQuantity returns datasource errors', () async {
      when(
        () => mockLocalDataSource.updateCartItemQuantity(any(), any()),
      ).thenAnswer(
        (_) async => ErrorResponce<CartResponseDto>(Exception('failed')),
      );

      final result = await commerceRepo.updateCartItemQuantity(
        'item-1',
        const UpdateCartItemParams(quantity: 5),
      );

      expect(result, isA<ErrorResponce<CartEntity>>());
    });

    test('removeCartItem passes id and maps the response', () async {
      when(
        () => mockLocalDataSource.removeCartItem('item-1'),
      ).thenAnswer((_) async => SuccessResponce(responseDto));

      final result = await commerceRepo.removeCartItem('item-1');

      expect(result, isA<SuccessResponce<CartEntity>>());
      verify(() => mockLocalDataSource.removeCartItem('item-1')).called(1);
    });

    test('removeCartItem returns datasource errors', () async {
      when(() => mockLocalDataSource.removeCartItem('item-1')).thenAnswer(
        (_) async => ErrorResponce<CartResponseDto>(Exception('failed')),
      );

      final result = await commerceRepo.removeCartItem('item-1');

      expect(result, isA<ErrorResponce<CartEntity>>());
    });
  });

  group('getSection', () {
    test(
      'should return SuccessResponce with mapped sections when local data source succeeds',
      () async {
        final sectionDto = SectionDto(
          id: 1,
          type: 'Categories',
          index: 0,
          isActive: true,
          title: 'Categories',
          occasionId: null,
          categoryId: null,
        );

        when(() => mockLocalDataSource.getSections()).thenAnswer(
          (_) async => SuccessResponce<List<SectionDto>>([sectionDto]),
        );

        final result = await commerceRepo.getSection();

        expect(result, isA<SuccessResponce<List<SectionEntity>>>());
        final success = result as SuccessResponce<List<SectionEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.type, SectionType.category);
        expect(success.data.first.title, 'Categories');
        verify(() => mockLocalDataSource.getSections()).called(1);
      },
    );

    test('should return ErrorResponce when local data source fails', () async {
      final exception = Exception('Failed to get sections');

      when(
        () => mockLocalDataSource.getSections(),
      ).thenAnswer((_) async => ErrorResponce<List<SectionDto>>(exception));

      final result = await commerceRepo.getSection();
      expect(result, isA<ErrorResponce<List<SectionEntity>>>());
      verify(() => mockLocalDataSource.getSections()).called(1);
    });
  });
}

import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_cubit.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_state.dart';
import 'package:flower_app/features/commerce/presentation/product_details/view/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_view_test.mocks.dart';

@GenerateMocks([ProductDetailsCubit])
void main() {
  late MockProductDetailsCubit mockCubit;

  setUpAll(() {
    // Initializing ScreenUtil for widget tests
  });

  setUp(() {
    mockCubit = MockProductDetailsCubit();
    
    // Allow re-assignment in GetIt
    getIt.allowReassignment = true;
    getIt.registerSingleton<ProductDetailsCubit>(mockCubit);

    // Default stubbing
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockCubit.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: const MaterialApp(
        home: ProductDetails(productId: 1),
      ),
    );
  }

  testWidgets('should display loading indicator when state is loading', (tester) async {
    // arrange
    when(mockCubit.state).thenReturn(const ProductDetailsState(isLoading: true));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(const ProductDetailsState(isLoading: true)));

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display product data when state is successful', (tester) async {
    // arrange
    final tProduct = ProductDetailsEntity(
      id: 1,
      name: 'Test Flower',
      imageUrl: 'https://test.com/image.png',
      currency: 'EGP',
      price: 100,
      status: 'In Stock',
      images: ['https://test.com/image.png'],
      description: 'Test description',
      includes: [],
      occasionIds: [],
    );
    when(mockCubit.state).thenReturn(ProductDetailsState(isLoading: false, data: tProduct));
    when(mockCubit.stream).thenAnswer((_) => Stream.value(ProductDetailsState(isLoading: false, data: tProduct)));

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // assert
    expect(find.text('Test Flower'), findsOneWidget);
  });

  testWidgets('should display error message when state has error', (tester) async {
    // arrange
    when(mockCubit.state).thenReturn(const ProductDetailsState(isLoading: false, errorMessage: 'Error occurred'));

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text('Error occurred'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_cubit.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_state.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/widgets/occasion_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOccasionCubit extends MockCubit<OccasionState> implements OccasionCubit {}

void main() {
  late MockOccasionCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(LoadMoreProducts());
  });

  setUp(() {
    mockCubit = MockOccasionCubit();
    when(() => mockCubit.handle(any())).thenReturn(null);
  });

  final tProduct = ProductEntity(
    id: 1,
    name: 'Red Rose',
    imageUrl: 'https://example.com/rose.png',
    currency: 'EGP',
    price: 250,
    status: 'Available',
  );

  Future<void> pumpApp(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(widget);
  }

  Widget wrap() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        home: Scaffold(
          body: BlocProvider<OccasionCubit>.value(
            value: mockCubit,
            child: const OccasionTabView(),
          ),
        ),
      ),
    );
  }

  testWidgets('shows a loading indicator while products are loading', (tester) async {
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: const OccasionState(
        productsState: BaseState(isLoading: true),
      ),
    );

    await pumpApp(tester, wrap());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the error message when loading products fails', (tester) async {
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: const OccasionState(
        productsState: BaseState(errorMessage: 'Failed to load products'),
      ),
    );

    await pumpApp(tester, wrap());

    expect(find.text('Failed to load products'), findsOneWidget);
  });

  testWidgets('renders a card per product', (tester) async {
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: OccasionState(
        productsState: BaseState<List<ProductEntity>>(data: [tProduct]),
      ),
    );

    await pumpApp(tester, wrap());
    await tester.pumpAndSettle();

    expect(find.text('Red Rose'), findsOneWidget);
  });

  testWidgets('does not dispatch LoadMoreProducts when there is no next page', (tester) async {
    final products = List.generate(
      20,
      (i) => ProductEntity(
        id: i,
        name: 'Product $i',
        imageUrl: 'url',
        currency: 'EGP',
        price: 100,
        status: 'Available',
      ),
    );

    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: OccasionState(
        productsState: BaseState<List<ProductEntity>>(data: products),
        pagination: PaginationEntity(
          page: 1,
          pageSize: 20,
          totalCount: 20,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      ),
    );

    await pumpApp(tester, wrap());
    await tester.fling(find.byType(CustomScrollView), const Offset(0, -3000), 3000);
    await tester.pumpAndSettle();

    verifyNever(() => mockCubit.handle(any(that: isA<LoadMoreProducts>())));
  });

  testWidgets('dispatches LoadMoreProducts when scrolled near the bottom and hasNextPage is true', (tester) async {
    final products = List.generate(
      20,
      (i) => ProductEntity(
        id: i,
        name: 'Product $i',
        imageUrl: 'url',
        currency: 'EGP',
        price: 100,
        status: 'Available',
      ),
    );

    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: OccasionState(
        productsState: BaseState<List<ProductEntity>>(data: products),
        pagination: PaginationEntity(
          page: 1,
          pageSize: 20,
          totalCount: 40,
          totalPages: 2,
          hasNextPage: true,
          hasPreviousPage: false,
        ),
      ),
    );

    await pumpApp(tester, wrap());
    await tester.fling(find.byType(CustomScrollView), const Offset(0, -3000), 3000);
    await tester.pumpAndSettle();

    verify(() => mockCubit.handle(any(that: isA<LoadMoreProducts>()))).called(greaterThanOrEqualTo(1));
  });
}

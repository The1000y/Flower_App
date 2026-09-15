import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_event.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_state.dart';
import 'package:flower_app/features/search/presentation/view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

void main() {
  late MockSearchCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(SearchProductsEvent(''));
  });

  setUp(() {
    mockCubit = MockSearchCubit();
    when(() => mockCubit.doEvent(any())).thenReturn(null);
  });

  Future<void> pumpApp(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(widget);
  }

  Widget wrap(SearchState state) {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: mockCubit,
          child: const SearchView(),
        ),
      ),
    );
  }

  testWidgets('shows the AppBar with back button and Search title', (tester) async {
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: const SearchState(),
    );

    await pumpApp(tester, wrap(const SearchState()));

    expect(find.text('Search'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
  });

  testWidgets('shows empty state message when query is empty', (tester) async {
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: const SearchState(),
    );

    await pumpApp(tester, wrap(const SearchState()));

    expect(find.text('Start typing to search'), findsOneWidget);
  });

  testWidgets('shows a loading indicator while searching', (tester) async {
    final state = const SearchState(
      query: 'rose',
      resultState: BaseState<List<ProductEntity>>(isLoading: true),
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the error message and Retry button on failure', (tester) async {
    final state = const SearchState(
      query: 'rose',
      resultState: BaseState<List<ProductEntity>>(
        errorMessage: 'something went wrong, pls try again',
      ),
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    expect(find.text('something went wrong, pls try again'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('tapping Retry dispatches SearchProductsEvent', (tester) async {
    final state = const SearchState(
      query: 'rose',
      resultState: BaseState<List<ProductEntity>>(
        errorMessage: 'something went wrong, pls try again',
      ),
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    await tester.tap(find.text('Retry'));

    verify(
      () => mockCubit.doEvent(
        any(that: isA<SearchProductsEvent>()),
      ),
    ).called(1);
  });

  testWidgets('shows no results message when products list is empty', (tester) async {
    final state = const SearchState(
      query: 'rose',
      resultState: BaseState<List<ProductEntity>>(data: []),
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('does not dispatch a search event before the debounce delay elapses', (tester) async {
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: const SearchState(),
    );

    await pumpApp(tester, wrap(const SearchState()));

    await tester.enterText(find.byType(TextFormField), 'rose');
    await tester.pump(const Duration(milliseconds: 399));

    verifyNever(() => mockCubit.doEvent(any()));

    // Let the pending debounce timer fire so no timer remains at teardown.
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('dispatches SearchProductsEvent with the typed query after the debounce delay', (tester) async {
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: const SearchState(),
    );

    await pumpApp(tester, wrap(const SearchState()));

    await tester.enterText(find.byType(TextFormField), 'rose');
    await tester.pump(const Duration(milliseconds: 400));

    verify(
      () => mockCubit.doEvent(
        any(
          that: isA<SearchProductsEvent>().having((e) => e.query, 'query', 'rose'),
        ),
      ),
    ).called(1);
  });

  testWidgets('resets the debounce timer on rapid typing and dispatches only the final query', (tester) async {
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: const SearchState(),
    );

    await pumpApp(tester, wrap(const SearchState()));

    await tester.enterText(find.byType(TextFormField), 'r');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(find.byType(TextFormField), 'ros');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(find.byType(TextFormField), 'roses');
    await tester.pump(const Duration(milliseconds: 400));

    verify(
      () => mockCubit.doEvent(
        any(
          that: isA<SearchProductsEvent>().having((e) => e.query, 'query', 'roses'),
        ),
      ),
    ).called(1);
    verifyNever(
      () => mockCubit.doEvent(
        any(
          that: isA<SearchProductsEvent>().having((e) => e.query, 'query', 'ros'),
        ),
      ),
    );
  });

  testWidgets('renders the product grid with product names', (tester) async {
    final products = [
      ProductEntity(
        id: 1,
        name: 'Red Roses Bouquet',
        imageUrl: 'https://example.com/rose.png',
        currency: 'EGP',
        price: 600,
        status: 'InStock',
      ),
      ProductEntity(
        id: 2,
        name: 'White Lily Bouquet',
        imageUrl: 'https://example.com/lily.png',
        currency: 'EGP',
        price: 700,
        status: 'InStock',
      ),
    ];
    final state = SearchState(
      query: 'rose',
      resultState: BaseState<List<ProductEntity>>(data: products),
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.text('Red Roses Bouquet'), findsOneWidget);
    expect(find.text('White Lily Bouquet'), findsOneWidget);
  });

  testWidgets('shows a loading indicator when loading more products', (tester) async {
    final products = [
      ProductEntity(
        id: 1,
        name: 'Red Roses Bouquet',
        imageUrl: 'https://example.com/rose.png',
        currency: 'EGP',
        price: 600,
        status: 'InStock',
      ),
      ProductEntity(
        id: 2,
        name: 'White Lily Bouquet',
        imageUrl: 'https://example.com/lily.png',
        currency: 'EGP',
        price: 700,
        status: 'InStock',
      ),
    ];
    final state = SearchState(
      query: 'rose',
      isLoadingMore: true,
      resultState: BaseState<List<ProductEntity>>(data: products),
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('dispatches LoadMoreSearchEvent when scrolled near the bottom with a next page', (tester) async {
    final products = List.generate(
      8,
      (i) => ProductEntity(
        id: i + 1,
        name: 'Product $i',
        imageUrl: 'https://example.com/$i.png',
        currency: 'EGP',
        price: 100,
        status: 'InStock',
      ),
    );
    final pagination = PaginationEntity(
      page: 1,
      pageSize: 8,
      totalCount: 16,
      totalPages: 2,
      hasNextPage: true,
      hasPreviousPage: false,
    );
    final state = SearchState(
      query: 'flower',
      resultState: BaseState<List<ProductEntity>>(data: products),
      pagination: pagination,
    );
    whenListen(
      mockCubit,
      const Stream<SearchState>.empty(),
      initialState: state,
    );

    await pumpApp(tester, wrap(state));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pump();

    verify(
      () => mockCubit.doEvent(
        any(that: isA<LoadMoreSearchEvent>()),
      ),
    ).called(1);
  });
}

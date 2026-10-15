import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_cubit.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_state.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/view/bestseller_view.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

import '../../../fixtures/commerce_fixtures.dart';
import '../../../mocks/mocks.mocks.dart';
import '../../../mocks/test_dummies.dart';

class MockCartCubit extends mocktail.Mock implements CartCubit {}

void main() {
  registerCommerceTestDummies();

  late MockBestsellerCubit mockCubit;
  late MockCartCubit mockCartCubit;

  setUpAll(() {
    getIt.allowReassignment = true;
  });

  setUp(() {
    mockCubit = MockBestsellerCubit();
    getIt.registerSingleton<BestsellerCubit>(mockCubit);

    mockCartCubit = MockCartCubit();
    mocktail.when(() => mockCartCubit.state).thenReturn(const CartState());
    mocktail
        .when(() => mockCartCubit.stream)
        .thenAnswer((_) => const Stream.empty());
    mocktail.when(() => mockCartCubit.close()).thenAnswer((_) async {});

    // Default stubbing
    when(mockCubit.state).thenReturn(const BestsellerState());
    when(
      mockCubit.stream,
    ).thenAnswer((_) => const Stream<BestsellerState>.empty());
    when(mockCubit.close()).thenAnswer((_) async {});
  });

  void setPhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget createWidgetUnderTest() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: BlocProvider<CartCubit>.value(
        value: mockCartCubit,
        child: const MaterialApp(home: BestsellerView()),
      ),
    );
  }

  group('BestsellerView', () {
    testWidgets('displays CircularProgressIndicator when state is loading', (
      tester,
    ) async {
      // Arrange
      when(mockCubit.state).thenReturn(const BestsellerState(isLoading: true));

      // Act
      setPhoneSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays products grid when data is loaded', (tester) async {
      // Arrange
      final tData = CommerceFixtures.tBestSellers;
      when(
        mockCubit.state,
      ).thenReturn(BestsellerState(isLoading: false, data: tData));

      // Act
      setPhoneSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BestsellerProductCard), findsAtLeastNWidgets(1));
      expect(find.text(tData[0].name), findsOneWidget);
    });

    testWidgets(
      'displays error message and retry button when state has error',
      (tester) async {
        // Arrange
        const tError = 'error message';
        when(mockCubit.state).thenReturn(
          const BestsellerState(isLoading: false, errorMessage: tError),
        );

        // Act
        setPhoneSurface(tester);
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text(tError), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });
}

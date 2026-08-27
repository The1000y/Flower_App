import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_cubit.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_state.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/view/bestseller_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/commerce_fixtures.dart';
import '../../../mocks/mocks.mocks.dart';
import '../../../mocks/test_dummies.dart';


void main() {
  registerCommerceTestDummies();

  late MockBestsellerCubit mockCubit;

  setUpAll(() {
    getIt.allowReassignment = true;
  });

  setUp(() {
    mockCubit = MockBestsellerCubit();
    getIt.registerSingleton<BestsellerCubit>(mockCubit);

    // Default stubbing
    when(mockCubit.state).thenReturn(const BestsellerState());
    when(mockCubit.stream).thenAnswer((_) => const Stream<BestsellerState>.empty());
    when(mockCubit.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: const MaterialApp(
        home: BestsellerView(),
      ),
    );
  }

  group('BestsellerView', () {
    testWidgets('displays CircularProgressIndicator when state is loading', (tester) async {
      // Arrange
      when(mockCubit.state).thenReturn(const BestsellerState(isLoading: true));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays products grid when data is loaded', (tester) async {
      // Arrange
      final tData = CommerceFixtures.tBestSellers;
      when(mockCubit.state).thenReturn(BestsellerState(isLoading: false, data: tData));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BestsellerProductCard), findsAtLeastNWidgets(1));
      expect(find.text(tData[0].name), findsOneWidget);
    });

    testWidgets('displays error message and retry button when state has error', (tester) async {
      // Arrange
      const tError = 'error message';
      when(mockCubit.state).thenReturn(const BestsellerState(isLoading: false, errorMessage: tError));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text(tError), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

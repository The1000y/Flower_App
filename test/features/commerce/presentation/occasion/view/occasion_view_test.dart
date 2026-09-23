import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_cubit.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_state.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/occasion_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOccasionCubit extends MockCubit<OccasionState> implements OccasionCubit {}

void main() {
  late MockOccasionCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(LoadOccasions());
  });

  setUp(() {
    mockCubit = MockOccasionCubit();
    when(() => mockCubit.handle(any())).thenReturn(null);
    if (getIt.isRegistered<OccasionCubit>()) {
      getIt.unregister<OccasionCubit>();
    }
    getIt.registerFactory<OccasionCubit>(() => mockCubit);
  });

  tearDown(() {
    getIt.reset();
  });

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
      child: const MaterialApp(home: OccasionView()),
    );
  }

  testWidgets('shows a loading indicator while occasions are loading', (tester) async {
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: const OccasionState(
        occasionsState: BaseState(isLoading: true),
      ),
    );

    await pumpApp(tester, wrap());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the error message when loading occasions fails', (tester) async {
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: const OccasionState(
        occasionsState: BaseState(errorMessage: 'Something went wrong'),
      ),
    );

    await pumpApp(tester, wrap());

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('shows an empty-state message when there are no occasions', (tester) async {
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: const OccasionState(
        occasionsState: BaseState(data: []),
      ),
    );

    await pumpApp(tester, wrap());

    expect(find.text('No occasions available right now.'), findsOneWidget);
  });

  testWidgets('renders a tab per occasion when occasions are loaded', (tester) async {
    final occasions = [
      OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'url1'),
      OccasionEntity(id: 2, name: 'Wedding', imageUrl: 'url2'),
    ];

    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: OccasionState(
        occasionsState: BaseState<List<OccasionEntity>>(data: occasions),
        productsState: const BaseState<List<ProductEntity>>(data: []),
      ),
    );

    await pumpApp(tester, wrap());

    expect(find.text('Birthday'), findsOneWidget);
    expect(find.text('Wedding'), findsOneWidget);
  });
}

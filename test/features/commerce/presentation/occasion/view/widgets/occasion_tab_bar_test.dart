import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_cubit.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_state.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/widgets/occasion_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    whenListen(
      mockCubit,
      const Stream<OccasionState>.empty(),
      initialState: const OccasionState(),
    );
  });

  final occasions = [
    OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'url1'),
    OccasionEntity(id: 2, name: 'Wedding', imageUrl: 'url2'),
  ];

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
        home: DefaultTabController(
          length: occasions.length,
          child: Scaffold(
            body: BlocProvider<OccasionCubit>.value(
              value: mockCubit,
              child: OccasionTabBar(occasions: occasions),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders one tab per occasion', (tester) async {
    await pumpApp(tester, wrap());

    expect(find.text('Birthday'), findsOneWidget);
    expect(find.text('Wedding'), findsOneWidget);
  });

  testWidgets('tapping a tab dispatches LoadProductsForOccasion with the right id', (tester) async {
    await pumpApp(tester, wrap());

    await tester.tap(find.text('Wedding'));
    await tester.pumpAndSettle();

    final captured = verify(() => mockCubit.handle(captureAny())).captured;
    expect(captured.whereType<LoadProductsForOccasion>().last.occasionId, 2);
  });
}

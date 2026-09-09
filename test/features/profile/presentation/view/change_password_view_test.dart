import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_cubit.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_state.dart';
import 'package:flower_app/features/profile/presentation/view/change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordCubit extends MockCubit<ChangePasswordState>
    implements ChangePasswordCubit {}

class FakeChangePasswordEvent extends Fake implements ChangePasswordEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChangePasswordEvent());
  });

  late MockChangePasswordCubit mockCubit;

  setUp(() {
    mockCubit = MockChangePasswordCubit();
    when(() => mockCubit.state).thenReturn(const ChangePasswordState());
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: BlocProvider<ChangePasswordCubit>.value(
          value: mockCubit,
          child: const ChangePasswordView(),
        ),
      ),
    );
  }

  group('ChangePasswordView Widget Tests', () {
    testWidgets('renders all input fields and update button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('dispatches UpdatePasswordEvent when form is valid', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'OldPassword123');
      await tester.enterText(fields.at(1), 'NewPassword123');
      await tester.enterText(fields.at(2), 'NewPassword123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => mockCubit.doEvent(any())).called(1);
    });
  });
}

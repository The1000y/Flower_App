import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
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

void main() {
  setUpAll(() {
    registerFallbackValue(
      UpdatePasswordEvent(
        currentPassword: 'dummy',
        newPassword: 'dummy',
        confirmPassword: 'dummy',
      ),
    );
  });

  late MockChangePasswordCubit mockCubit;

  setUp(() {
    mockCubit = MockChangePasswordCubit();
    when(() => mockCubit.state).thenReturn(const ChangePasswordState());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream<ChangePasswordState>.empty());
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

      await tester.enterText(find.byType(CustomTextFormField).at(0), 'OldPass@123');
      await tester.enterText(find.byType(CustomTextFormField).at(1), 'NewStrong@123');
      await tester.enterText(find.byType(CustomTextFormField).at(2), 'NewStrong@123');

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      verify(() => mockCubit.doEvent(any())).called(1);
    });

    testWidgets('renders loading state on button when isLoading is true', (tester) async {
      when(() => mockCubit.state).thenReturn(const ChangePasswordState(
        changePasswordState: BaseState(isLoading: true),
      ));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error snackbar when state transitions from loading to error', (tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([
          const ChangePasswordState(changePasswordState: BaseState(isLoading: true)),
          const ChangePasswordState(
            changePasswordState: BaseState(
              isLoading: false,
              errorMessage: 'Invalid current password',
            ),
          ),
        ]),
        initialState: const ChangePasswordState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Invalid current password'), findsOneWidget);
    });

    testWidgets('shows success snackbar when state transitions from loading to success', (tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([
          const ChangePasswordState(changePasswordState: BaseState(isLoading: true)),
          ChangePasswordState(
            changePasswordState: BaseState(
              isLoading: false,
              data: ChangePasswordEntity(message: 'Success'),
            ),
          ),
        ]),
        initialState: const ChangePasswordState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(AppStrings.passwordUpdatedSuccessfully), findsOneWidget);
    });
  });
}

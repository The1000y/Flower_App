import 'dart:async';

import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_ui_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart_ui_event_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:flower_app/l10n/app_localizations_en.dart';

class MockCartCubit extends mocktail.Mock implements CartCubit {}

void main() {
  late MockCartCubit mockCartCubit;
  late StreamController<CartUiEvent> controller;

  setUp(() {
    mockCartCubit = MockCartCubit();
    controller = StreamController<CartUiEvent>.broadcast();
    mocktail.when(() => mockCartCubit.stream)
        .thenAnswer((_) => const Stream<CartState>.empty());
    mocktail.when(() => mockCartCubit.uiEvents)
        .thenAnswer((_) => controller.stream);
  });

  tearDown(() => controller.close());

  Future<void> pumpListener(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CartCubit>.value(
          value: mockCartCubit,
          child: const CartUiEventListener(child: Scaffold()),
        ),
      ),
    );
  }

  testWidgets('shows a success snackbar for a success event', (tester) async {
    await pumpListener(tester);

    controller.add(const AddToCartSuccessUiEvent());
    await tester.pump();

    expect(find.text(AppLocalizationsEn().productAddedToCart), findsOneWidget);
  });

  testWidgets('shows the failure message for a failure event', (tester) async {
    await pumpListener(tester);

    controller.add(const AddToCartFailureUiEvent(message: 'add failed'));
    await tester.pump();

    expect(find.text('add failed'), findsOneWidget);
  });

  testWidgets('falls back to a generic message when the failure has none', (
    tester,
  ) async {
    await pumpListener(tester);

    controller.add(const AddToCartFailureUiEvent());
    await tester.pump();

    expect(find.text(AppLocalizationsEn().somethingWentWrong), findsOneWidget);
  });
}

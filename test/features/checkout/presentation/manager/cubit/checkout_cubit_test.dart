import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/checkout_fixtures.dart';
import '../../../mocks/mocks.mocks.dart';
import '../../../mocks/test_dummies.dart';

void main() {
  registerCheckoutTestDummies();

  late MockGetCheckoutUseCase mockGetCheckoutUseCase;
  late MockEstimationTimeUseCase mockEstimationTimeUseCase;
  late CheckoutCubit cubit;

  setUp(() {
    mockGetCheckoutUseCase = MockGetCheckoutUseCase();
    mockEstimationTimeUseCase = MockEstimationTimeUseCase();
    cubit = CheckoutCubit(mockGetCheckoutUseCase, mockEstimationTimeUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('CheckoutCubit', () {
    test(
      'initial state should be a loading CheckoutState with empty values',
      () {
        // Arrange & Act
        final state = cubit.state;

        // Assert
        expect(state, const CheckoutState());
        expect(state.checkoutDetailsState.isLoading, isTrue);
        expect(state.estimationTimeState.isLoading, isTrue);
        expect(state.selectedPaymentMethod, isEmpty);
        expect(state.isGift, isFalse);
        expect(state.giftRecipientName, isEmpty);
        expect(state.giftRecipientPhone, isEmpty);
      },
    );

    group('GetCheckoutEvent', () {
      blocTest<CheckoutCubit, CheckoutState>(
        'emits [loading, success] when the use case succeeds',
        build: () {
          when(mockGetCheckoutUseCase.call()).thenAnswer(
            (_) async => SuccessResponce<CheckoutDetailsEntity>(
              CheckoutFixtures.tCheckoutDetailsEntity,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(GetCheckoutEvent()),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.checkoutDetailsState.isLoading,
            'isLoading',
            isTrue,
          ),
          isA<CheckoutState>()
              .having(
                (s) => s.checkoutDetailsState.isLoading,
                'isLoading',
                isFalse,
              )
              .having(
                (s) => s.checkoutDetailsState.data,
                'data',
                CheckoutFixtures.tCheckoutDetailsEntity,
              )
              .having(
                (s) => s.checkoutDetailsState.errorMessage,
                'errorMessage',
                isEmpty,
              ),
        ],
        verify: (_) {
          verify(mockGetCheckoutUseCase.call()).called(1);
          verifyNever(
            mockEstimationTimeUseCase.call(
              addressId: CheckoutFixtures.tAddressId,
            ),
          );
        },
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'seeds estimationTimeState with the details estimated delivery time',
        build: () {
          when(mockGetCheckoutUseCase.call()).thenAnswer(
            (_) async => SuccessResponce<CheckoutDetailsEntity>(
              CheckoutFixtures.tCheckoutDetailsEntity,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(GetCheckoutEvent()),
        expect: () => [
          isA<CheckoutState>(),
          isA<CheckoutState>()
              .having(
                (s) => s.estimationTimeState.data,
                'data',
                const EstimationTimeEntity(
                  estimatedDeliveryAt: CheckoutFixtures.tEstimatedDeliveryAt,
                ),
              )
              .having(
                (s) => s.estimationTimeState.isLoading,
                'isLoading',
                isFalse,
              ),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits [loading, error] when the use case returns ErrorResponce',
        build: () {
          when(mockGetCheckoutUseCase.call()).thenAnswer(
            (_) async => ErrorResponce<CheckoutDetailsEntity>(
              Exception('Failed to get checkout details'),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(GetCheckoutEvent()),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.checkoutDetailsState.isLoading,
            'isLoading',
            isTrue,
          ),
          isA<CheckoutState>()
              .having(
                (s) => s.checkoutDetailsState.isLoading,
                'isLoading',
                isFalse,
              )
              .having(
                (s) => s.checkoutDetailsState.errorMessage,
                'errorMessage',
                'something went wrong, pls try again',
              )
              .having((s) => s.checkoutDetailsState.data, 'data', isNull),
        ],
        verify: (_) {
          verify(mockGetCheckoutUseCase.call()).called(1);
        },
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'keeps the estimation time untouched when the use case fails',
        build: () {
          when(mockGetCheckoutUseCase.call()).thenAnswer(
            (_) async =>
                ErrorResponce<CheckoutDetailsEntity>(Exception('boom')),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(GetCheckoutEvent()),
        expect: () => [
          isA<CheckoutState>(),
          isA<CheckoutState>()
              .having(
                (s) => s.estimationTimeState.isLoading,
                'isLoading',
                isTrue,
              )
              .having((s) => s.estimationTimeState.data, 'data', isNull),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits the loading state before awaiting the use case',
        build: () {
          when(mockGetCheckoutUseCase.call()).thenAnswer(
            (_) async => SuccessResponce<CheckoutDetailsEntity>(
              CheckoutFixtures.tCheckoutDetailsEntity,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(GetCheckoutEvent()),
        expect: () => [
          CheckoutState(
            checkoutDetailsState: const BaseState<CheckoutDetailsEntity>(
              isLoading: true,
            ),
          ),
          isA<CheckoutState>(),
        ],
      );
    });

    group('GetEstimationTimeEvent', () {
      blocTest<CheckoutCubit, CheckoutState>(
        'emits [loading, success] when the use case succeeds',
        build: () {
          when(
            mockEstimationTimeUseCase.call(
              addressId: CheckoutFixtures.tAddressId,
            ),
          ).thenAnswer(
            (_) async => SuccessResponce<EstimationTimeEntity>(
              CheckoutFixtures.tEstimationTimeEntity,
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(
          GetEstimationTimeEvent(addressId: CheckoutFixtures.tAddressId),
        ),
        expect: () => [
          isA<CheckoutState>()
              .having(
                (s) => s.estimationTimeState.isLoading,
                'isLoading',
                isTrue,
              )
              .having((s) => s.estimationTimeState.data, 'data', isNull),
          isA<CheckoutState>()
              .having(
                (s) => s.estimationTimeState.isLoading,
                'isLoading',
                isFalse,
              )
              .having(
                (s) => s.estimationTimeState.data,
                'data',
                CheckoutFixtures.tEstimationTimeEntity,
              )
              .having(
                (s) => s.estimationTimeState.errorMessage,
                'errorMessage',
                isEmpty,
              ),
        ],
        verify: (_) {
          verify(
            mockEstimationTimeUseCase.call(
              addressId: CheckoutFixtures.tAddressId,
            ),
          ).called(1);
          verifyNever(mockGetCheckoutUseCase.call());
        },
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits [loading, error] when the use case returns ErrorResponce',
        build: () {
          when(
            mockEstimationTimeUseCase.call(
              addressId: CheckoutFixtures.tAddressId,
            ),
          ).thenAnswer(
            (_) async => ErrorResponce<EstimationTimeEntity>(
              Exception('Failed to get estimation time'),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(
          GetEstimationTimeEvent(addressId: CheckoutFixtures.tAddressId),
        ),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.estimationTimeState.isLoading,
            'isLoading',
            isTrue,
          ),
          isA<CheckoutState>()
              .having(
                (s) => s.estimationTimeState.isLoading,
                'isLoading',
                isFalse,
              )
              .having(
                (s) => s.estimationTimeState.errorMessage,
                'errorMessage',
                'something went wrong, pls try again',
              )
              .having((s) => s.estimationTimeState.data, 'data', isNull),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'forwards the given addressId to the use case',
        build: () {
          when(
            mockEstimationTimeUseCase.call(addressId: 'another-address'),
          ).thenAnswer(
            (_) async => SuccessResponce<EstimationTimeEntity>(
              CheckoutFixtures.tEstimationTimeEntity,
            ),
          );
          return cubit;
        },
        act: (cubit) =>
            cubit.doEvent(GetEstimationTimeEvent(addressId: 'another-address')),
        expect: () => [isA<CheckoutState>(), isA<CheckoutState>()],
        verify: (_) {
          verify(
            mockEstimationTimeUseCase.call(addressId: 'another-address'),
          ).called(1);
        },
      );
    });

    group('SelectPaymentMethodEvent', () {
      blocTest<CheckoutCubit, CheckoutState>(
        'emits the selected payment method',
        build: () => cubit,
        act: (cubit) => cubit.doEvent(
          SelectPaymentMethodEvent(paymentMethod: CheckoutFixtures.tCod),
        ),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.selectedPaymentMethod,
            'selectedPaymentMethod',
            CheckoutFixtures.tCod,
          ),
        ],
        verify: (_) {
          verifyNever(mockGetCheckoutUseCase.call());
          verifyNever(
            mockEstimationTimeUseCase.call(
              addressId: CheckoutFixtures.tAddressId,
            ),
          );
        },
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'overwrites the previously selected payment method',
        build: () => cubit,
        seed: () =>
            const CheckoutState(selectedPaymentMethod: CheckoutFixtures.tCod),
        act: (cubit) => cubit.doEvent(
          SelectPaymentMethodEvent(paymentMethod: CheckoutFixtures.tCard),
        ),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.selectedPaymentMethod,
            'selectedPaymentMethod',
            CheckoutFixtures.tCard,
          ),
        ],
      );
    });

    group('ToggleGiftEvent', () {
      blocTest<CheckoutCubit, CheckoutState>(
        'emits isGift true when toggled on',
        build: () => cubit,
        act: (cubit) => cubit.doEvent(ToggleGiftEvent(isGift: true)),
        expect: () => [
          isA<CheckoutState>().having((s) => s.isGift, 'isGift', isTrue),
        ],
      );

      blocTest<CheckoutCubit, CheckoutState>(
        'emits isGift false when toggled off',
        build: () => cubit,
        seed: () => const CheckoutState(isGift: true),
        act: (cubit) => cubit.doEvent(ToggleGiftEvent(isGift: false)),
        expect: () => [
          isA<CheckoutState>().having((s) => s.isGift, 'isGift', isFalse),
        ],
      );
    });

    group('ChangeGiftRecipientNameEvent', () {
      blocTest<CheckoutCubit, CheckoutState>(
        'emits the new gift recipient name',
        build: () => cubit,
        act: (cubit) =>
            cubit.doEvent(ChangeGiftRecipientNameEvent(name: 'Mona')),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.giftRecipientName,
            'giftRecipientName',
            'Mona',
          ),
        ],
      );
    });

    group('ChangeGiftRecipientPhoneEvent', () {
      blocTest<CheckoutCubit, CheckoutState>(
        'emits the new gift recipient phone',
        build: () => cubit,
        act: (cubit) =>
            cubit.doEvent(ChangeGiftRecipientPhoneEvent(phone: '01012345678')),
        expect: () => [
          isA<CheckoutState>().having(
            (s) => s.giftRecipientPhone,
            'giftRecipientPhone',
            '01012345678',
          ),
        ],
      );
    });

    group('copyWith', () {
      test('keeps the previous values for every omitted field', () {
        // Arrange
        const state = CheckoutState(
          giftRecipientName: 'Mona',
          giftRecipientPhone: '01012345678',
          selectedPaymentMethod: CheckoutFixtures.tCod,
          isGift: true,
        );

        // Act
        final result = state.copyWith(
          selectedPaymentMethod: CheckoutFixtures.tCard,
        );

        // Assert
        expect(result.giftRecipientName, 'Mona');
        expect(result.giftRecipientPhone, '01012345678');
        expect(result.isGift, isTrue);
        expect(result.selectedPaymentMethod, CheckoutFixtures.tCard);
      });

      test('replaces the checkout details state when provided', () {
        // Arrange
        const state = CheckoutState();

        // Act
        final result = state.copyWith(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            data: CheckoutFixtures.tCheckoutDetailsEntity,
            isLoading: false,
          ),
        );

        // Assert
        expect(result.checkoutDetailsState.isLoading, isFalse);
        expect(
          result.checkoutDetailsState.data,
          CheckoutFixtures.tCheckoutDetailsEntity,
        );
      });
    });
  });
}

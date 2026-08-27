import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_cubit.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_event.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/commerce_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';
import '../../../../mocks/test_dummies.dart';

void main() {
  registerCommerceTestDummies();

  late MockGetBestSellerUseCase mockUseCase;
  late BestsellerCubit cubit;

  setUp(() {
    mockUseCase = MockGetBestSellerUseCase();
    cubit = BestsellerCubit(mockUseCase);
  });

  group('BestsellerCubit', () {
    test('initial state should be BestsellerState with isLoading false', () {
      expect(cubit.state, const BestsellerState());
    });

    blocTest<BestsellerCubit, BestsellerState>(
      'emits [isLoading: true, data: data] when getBestsellerList succeeds',
      build: () {
        when(mockUseCase.call()).thenAnswer(
          (_) async => SuccessResponce<List<BestSellerEntity>>(CommerceFixtures.tBestSellers),
        );
        return cubit;
      },
      act: (cubit) => cubit.getBestsellerList(),
      expect: () => [
        const BestsellerState(isLoading: true),
        BestsellerState(isLoading: false, data: CommerceFixtures.tBestSellers),
      ],
    );

    blocTest<BestsellerCubit, BestsellerState>(
      'emits [isLoading: true, errorMessage: error] when getBestsellerList fails',
      build: () {
        when(mockUseCase.call()).thenAnswer(
          (_) async => ErrorResponce<List<BestSellerEntity>>(Exception('error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.getBestsellerList(),
      expect: () => [
        const BestsellerState(isLoading: true),
        const BestsellerState(isLoading: false, errorMessage: 'something went wrong, pls try again'),
      ],
    );
   group('doEvent', () {
      blocTest<BestsellerCubit, BestsellerState>(
        'triggers getBestsellerList when GetBestsellerListEvent is received',
        build: () {
          when(mockUseCase.call()).thenAnswer(
            (_) async => SuccessResponce<List<BestSellerEntity>>(CommerceFixtures.tBestSellers),
          );
          return cubit;
        },
        act: (cubit) => cubit.doEvent(GetBestsellerListEvent()),
        expect: () => [
          const BestsellerState(isLoading: true),
          BestsellerState(isLoading: false, data: CommerceFixtures.tBestSellers),
        ],
      );
    });
  });
}

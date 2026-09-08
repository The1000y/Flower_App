import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_home_sections_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/commerce_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCommerceTestDummies();

  late MockCommerceRepo mockCommerceRepo;
  late GetHomeSectionsUseCase useCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    useCase = GetHomeSectionsUseCase(mockCommerceRepo);
  });

  group('GetHomeSectionsUseCase', () {
    test(
      'returns SuccessResponce with active sections sorted by index '
      'when repository call succeeds',
      () async {
        // Arrange
        final tSuccess =
            SuccessResponce<List<SectionEntity>>(CommerceFixtures.tUnsortedSections);
        when(mockCommerceRepo.getSection()).thenAnswer((_) async => tSuccess);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<SuccessResponce<List<SectionEntity>>>());
        expect(
          (result as SuccessResponce<List<SectionEntity>>).data,
          equals(CommerceFixtures.tActiveSortedSections),
        );
        verify(mockCommerceRepo.getSection()).called(1);
        verifyNoMoreInteractions(mockCommerceRepo);
      },
    );

    test(
      'returns ErrorResponce with message when repository call fails',
      () async {
        // Arrange
        final tError =
            ErrorResponce<List<SectionEntity>>(Exception('server error'));
        when(mockCommerceRepo.getSection()).thenAnswer((_) async => tError);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<ErrorResponce<List<SectionEntity>>>());
        expect(
          (result as ErrorResponce<List<SectionEntity>>).errorMessage,
          tError.errorMessage,
        );
        verify(mockCommerceRepo.getSection()).called(1);
        verifyNoMoreInteractions(mockCommerceRepo);
      },
    );
  });
}

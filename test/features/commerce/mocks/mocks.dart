import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_best_seller_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_home_sections_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_occasions_use_case.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_cubit.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  CommerceRepo,
  CommerceLocalDataSource,
  GetCategoriesUseCase,
  GetBestSellerUseCase,
  GetHomeSectionsUseCase,
  GetOccasionsUseCase,
  BestsellerCubit,
])
class Mocks {}

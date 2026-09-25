import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/checkout/api/client/checkout_api_client.dart';
import 'package:flower_app/features/checkout/data/data_source/remote_data_source.dart';
import 'package:flower_app/features/checkout/domain/repo/checkout_repo.dart';
import 'package:flower_app/features/checkout/domain/use_cases/estimation_time_use_case.dart';
import 'package:flower_app/features/checkout/domain/use_cases/get_checkout_use_case.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  CheckoutApiClient,
  RemoteDataSource,
  CheckoutRepo,
  GetCheckoutUseCase,
  EstimationTimeUseCase,
  CheckoutCubit,
  AddressCubit,
])
class Mocks {}

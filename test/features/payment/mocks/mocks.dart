import 'package:flower_app/features/payment/api/client/payment_api_client.dart';
import 'package:flower_app/features/payment/data/data_source/remote_data_source.dart';
import 'package:flower_app/features/payment/domain/repo/place_order_repo.dart';
import 'package:flower_app/features/payment/domain/use_case/place_order_use_case.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_cubit.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  PaymentApiClient,
  RemoteDataSource,
  PlaceOrderRepo,
  PlaceOrderUseCase,
  PlaceOrderCubit,
])
class PaymentMocks {}

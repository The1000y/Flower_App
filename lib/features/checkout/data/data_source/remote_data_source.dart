import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/data/model/responce/data_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';

abstract interface class RemoteDataSource {

  Future<BaseResponce<DataDto>> getCheckoutDetails();
  Future<BaseResponce<EstimationTimeDto>> getEstimationTime({required String addressId});

}
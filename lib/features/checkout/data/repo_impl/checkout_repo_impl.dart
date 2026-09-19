import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/data/data_source/remote_data_source.dart';
import 'package:flower_app/features/checkout/data/model/responce/data_dto.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/repo/checkout_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CheckoutRepo)
class CheckoutRepoImpl implements CheckoutRepo {
  RemoteDataSource remoteDataSource;

  CheckoutRepoImpl(this.remoteDataSource);
  @override
  Future<BaseResponce<CheckoutDetailsEntity>> getCheckoutDetails() async {
    final responce = await remoteDataSource.getCheckoutDetails();
    switch (responce) {
      case SuccessResponce<DataDto>():
        return SuccessResponce<CheckoutDetailsEntity>(responce.data.toEntity());

      case ErrorResponce<DataDto>():
        return ErrorResponce<CheckoutDetailsEntity>(responce.error);
    }
  }
}

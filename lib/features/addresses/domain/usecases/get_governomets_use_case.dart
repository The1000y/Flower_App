import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGovernoratesUseCase {
  final AddressRepo repository;

  GetGovernoratesUseCase(this.repository);

  Future<List<GovernorateEntity>> call() async {
    return await repository.getGovernorates();
  }
}

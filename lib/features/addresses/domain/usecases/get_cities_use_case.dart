import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCitiesUseCase {
  final AddressRepo repository;

  GetCitiesUseCase(this.repository);

  Future<List<CityEntity>> call(String governorateId) async {
    return await repository.getCities(governorateId: governorateId);
  }
}

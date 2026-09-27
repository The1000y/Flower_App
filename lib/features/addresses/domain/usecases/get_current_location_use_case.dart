import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentLocationUseCase {
  AddressRepo addressRepo;

  GetCurrentLocationUseCase({required this.addressRepo});

  Future<Position?> call() async {
    return await addressRepo.getCurrentLocation();
  }
}

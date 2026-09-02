import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/datasource_impl/local_data_source/address_dummy_data.dart';
import '../model/ response/address_dto.dart';


@lazySingleton
class AddressLocalStorage {
  static const _key = 'saved_addresses';

  Future<List<AddressDto>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) {
      final seeded = _seedAddresses();
      await save(seeded);
      return seeded;
    }

    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => AddressDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> save(List<AddressDto> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(addresses.map((a) => a.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  List<AddressDto> _seedAddresses() {
    return [
      AddressDto.fromJson(AddressDummyData.addressDummyData),
    ];
  }
}
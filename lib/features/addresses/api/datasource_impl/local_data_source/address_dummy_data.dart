// features/addresses/api/data_source_impl/local/address_dummy_data.dart

import '../../../domain/entities/address_entity.dart';

abstract class AddressDummyData {
  // His required map - DO NOT TOUCH
  static Map<String, dynamic> addressDummyData = {
    "id": "dummy-id-123",
    "recipientName": "elalfy",
    "recipientPhone": "01277919151",
    "addressLine": "XH72+PCC,",
    "city": "Giza",
    "area": "Dokki",
    "lat": 29.964004958067264,
    "lng": 32.550108432769775,
    "label": "Home",
    "isDefault": false,
    "storeId": "store-123",
    "isServiceable": true,
    "createdAt": "2024-01-15T10:30:00Z",
  };

  // Your new robust list for the Cart & Saved Addresses
  static List<Map<String, dynamic>> savedAddressesList = [
    addressDummyData, // Include his address so it shows up in your list
    {
      "id": "dummy-id-456",
      "recipientName": "Mona Ahmed",
      "recipientPhone": "01012345678",
      "addressLine": "2XVP+XC",
      "city": "Cairo",
      "area": "Sheikh Zayed",
      "lat": 30.0131,
      "lng": 31.2089,
      "label": "Work",
      "isDefault": true,
      "storeId": "store-456",
      "isServiceable": true,
      "createdAt": "2024-02-10T09:15:00Z",
    }
  ];
}
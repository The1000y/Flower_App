// features/addresses/api/data_source_impl/local/address_dummy_data.dart

abstract class AddressDummyData {
  static Map<String, dynamic> addressDummyData = {
    "id": "dummy-id-123",
    "recipientName": "elalfy", 
    "recipientPhone": "01277919151",
    "addressLine": "XH72+PCC,",
    "city": "Giza",
    "area": "Dokki",
    //lat-log in emulator locationPosition
    "lat": 29.964004958067264,
    "lng": 32.550108432769775,
    "label": "Home",
    "isDefault": false,
    "storeId": "store-123",
    "isServiceable": true, 
    "createdAt": "2024-01-15T10:30:00Z",
  };
}


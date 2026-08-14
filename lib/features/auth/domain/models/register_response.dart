class RegisterResponse {
  final bool isSuccess;
  final int errorCode;
  final String message;
  final dynamic data;
  RegisterResponse({
    required this.isSuccess,
    required this.errorCode,
    required this.message,
    this.data,
  });
factory RegisterResponse.fromJson(Map<String, dynamic> json) {
return RegisterResponse(
// بنستخدم ?? كحماية لو السيرفر مبعتش القيمة، نحط قيمة افتراضية عشان التطبيق ميضربش
isSuccess: json['isSuccess'] ?? false,
errorCode: json['errorCode'] ?? 0,
message: json['message'] ?? 'Unhandled error',
data: json['data'],
);}
  }




// device_code_model.dart
class DeviceCodeResponse {
  final String status;
  final String message;
  final String newDeviceCode;

  DeviceCodeResponse({
    required this.status,
    required this.message,
    required this.newDeviceCode,
  });

  factory DeviceCodeResponse.fromJson(Map<String, dynamic> json) {
    return DeviceCodeResponse(
      status: json['status'],
      message: json['message'],
      newDeviceCode: json['new_device_code'],
    );
  }
}

// lib/models/subscription_response.dart
class SubscriptionResponse {
  final String status;
  final String message;
  final String studentId;

  SubscriptionResponse({
    required this.status,
    required this.message,
    required this.studentId,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      status: json['status'],
      message: json['message'],
      studentId: json['student_id'],
    );
  }
}

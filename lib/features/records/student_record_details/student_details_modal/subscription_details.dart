// lib/models/subscription_details.dart
class SubscriptionDetailsModal {
  final String id;
  final String studentId;
  final String startDate;
  final String endDate;
  final String fee;
  final String createdAt;

  SubscriptionDetailsModal({
    required this.id,
    required this.studentId,
    required this.startDate,
    required this.endDate,
    required this.fee,
    required this.createdAt,
  });

  factory SubscriptionDetailsModal.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetailsModal(
      id: json['id'],
      studentId: json['student_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      fee: json['fee'],
      createdAt: json['created_at'],
    );
  }
}

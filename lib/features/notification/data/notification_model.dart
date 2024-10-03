// lib/models/notification_model.dart

import '../../../utils/logger.dart';

class NotificationResponse {
  final String status;
  final String message;
  final Map<String, List<NotificationData>> data;

  NotificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Manually handle JSON parsing
  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    try {
      logDebug('Parsing NotificationResponse from JSON: $json'); // Debug log

      final status = json['status'] as String;
      final message = json['message'] as String;
      final data = (json['data'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((item) => NotificationData.fromJson(item as Map<String, dynamic>))
              .toList(),
        ),
      );

      return NotificationResponse(
        status: status,
        message: message,
        data: data,
      );
    } catch (e) {
      logDebug('Error parsing NotificationResponse: $e'); // Debug log
      rethrow;
    }
  }

  // Manually handle JSON serialization
  Map<String, dynamic> toJson() {
    try {
      logDebug('Serializing NotificationResponse to JSON'); // Debug log
      return {
        'status': status,
        'message': message,
        'data': data.map(
              (key, value) => MapEntry(
            key,
            value.map((item) => item.toJson()).toList(),
          ),
        ),
      };
    } catch (e) {
      logDebug('Error serializing NotificationResponse: $e'); // Debug log
      rethrow;
    }
  }
}

class NotificationData {
  final String id;
  final String studentId;
  final String startDate;
  final String endDate;
  final String fee;
  final String createdAt;
  final String studentName;
  final String endingOn;

  NotificationData({
    required this.id,
    required this.studentId,
    required this.startDate,
    required this.endDate,
    required this.fee,
    required this.createdAt,
    required this.studentName,
    required this.endingOn,
  });

  // Manually handle JSON parsing
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    try {
      logDebug('Parsing NotificationData from JSON: $json'); // Debug log

      return NotificationData(
        id: json['id'] as String,
        studentId: json['student_id'] as String,
        startDate: json['start_date'] as String,
        endDate: json['end_date'] as String,
        fee: json['fee'] as String,
        createdAt: json['created_at'] as String,
        studentName: json['student_name'] as String,
        endingOn: json['ending_on']as String,
      );
    } catch (e) {
      logDebug('Error parsing NotificationData: $e'); // Debug log
      rethrow;
    }
  }

  // Manually handle JSON serialization
  Map<String, dynamic> toJson() {
    try {
      logDebug('Serializing NotificationData to JSON'); // Debug log
      return {
        'id': id,
        'student_id': studentId,
        'start_date': startDate,
        'end_date': endDate,
        'fee': fee,
        'created_at': createdAt,
        'student_name': studentName,
      };
    } catch (e) {
      logDebug('Error serializing NotificationData: $e'); // Debug log
      rethrow;
    }
  }
}

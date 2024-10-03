// lib/ViewModel/NotificationViewModel.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';

class NotificationViewModel with ChangeNotifier {
  Map<String, List<NotificationData>> _notificationsByDate = {};
  Map<String, List<NotificationData>> get notificationsByDate => _notificationsByDate;
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadNotifications(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(AppUrl.notificationApi),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final notificationsData = data['data'] as Map<String, dynamic>;
          _notificationsByDate = notificationsData.map(
                (date, notificationsList) {
              final notifications = (notificationsList as List).map(
                    (item) => NotificationData.fromJson(item as Map<String, dynamic>),
              ).toList();
              return MapEntry(date, notifications);
            },
          );
        } else {
          _error = data['message'] ?? 'Error occurred';
        }
      } else {
        _error = 'Failed to load data';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
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

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      studentId: json['student_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      fee: json['fee'],
      createdAt: json['created_at'],
      studentName: json['student_name'],
      endingOn: json['ending_on'],
    );
  }
}

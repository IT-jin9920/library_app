// lib/viewmodels/home_notification_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../utils/logger.dart'; // Ensure this path is correct
import '../data/notification_model.dart';
import '../data/notification_repository.dart';

class HomeNotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<NotificationData> notifications = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadNotifications(int userId) async {
    logDebug('Loading notifications for user_id: $userId'); // Debug log
    isLoading = true;
    errorMessage = null; // Reset error message
    notifyListeners();

    try {
      // Fetch notifications from repository
      final response = await _repository.SuperAdminHomefetchNotifications(userId);
      notifications = _extractNotifications(response); // Process the response
      logDebug('Notifications loaded: ${notifications.length} items'); // Debug log
    } catch (e) {
      errorMessage = 'Failed to load notifications';
      logDebug('Error loading notifications: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to process and extract notifications from response
  List<NotificationData> _extractNotifications(NotificationResponse response) {
    logDebug('Extracting notifications from response: ${response.data}'); // Debug log

    List<NotificationData> allNotifications = [];
    response.data.forEach((date, notificationsList) {
      allNotifications.addAll(notificationsList);
    }); // Correctly close the forEach method

    logDebug('Extracted notifications count: ${allNotifications.length}'); // Debug log
    return allNotifications;
  }
}

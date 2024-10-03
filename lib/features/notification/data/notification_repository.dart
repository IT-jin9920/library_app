import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';
import '../../../utils/logger.dart';
import 'notification_model.dart';

class NotificationRepository {
  final String apiUrl = AppUrl.notificationApi;

  Future<NotificationResponse> fetchNotifications(int userId) async {
    try {
      logDebug('Sending request to $apiUrl with user_id: $userId'); // Debug log
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': userId.toString()},
      );

      logDebug('Received response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return NotificationResponse.fromJson(jsonResponse);
      } else {
        logDebug('Error: ${response.statusCode}'); // Debug log
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      logDebug('Error in fetchNotifications: $e'); // Debug log
      rethrow;
    }
  }

  Future<NotificationResponse> SuperAdminHomefetchNotifications(int userId) async {
    try {
      final today = DateTime.now();
      final formattedDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      logDebug('Sending request to $apiUrl with user_id: $userId and date: $formattedDate'); // Debug log


      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_id': userId.toString(),
          'date': formattedDate, // Include today's date in the request
        },
      );

      logDebug('Received response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return NotificationResponse.fromJson(jsonResponse);
      } else {
        logDebug('Error: ${response.statusCode}'); // Debug log
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      logDebug('Error in fetchNotifications: $e'); // Debug log
      rethrow;
    }
  }
}

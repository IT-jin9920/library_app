import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:library_app/res/app_url/app_url.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  bool isLoading = true;
  String error = '';
  DashboardData? dashboardData;

  Future<void> loadDashboardData(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(AppUrl.dashbordApi),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Received response: ${response.body}');

        dashboardData = DashboardData.fromJson(data);
        print('Parsed DashboardData: ${dashboardData?.toJson()}');
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      error = e.toString();
      print('Error fetching dashboard data: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class DashboardData {
  final String todayAvailableStudents;
  final String leftLibraryStudents;
  final String todayPresentStudents;

  DashboardData({
    required this.todayAvailableStudents,
    required this.leftLibraryStudents,
    required this.todayPresentStudents,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      todayAvailableStudents: json['today_available_students'] as String,
      leftLibraryStudents: json['left_library_students'] as String,
      todayPresentStudents: json['today_present_students'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_available_students': todayAvailableStudents,
      'left_library_students': leftLibraryStudents,
      'today_present_students': todayPresentStudents,
    };
  }
}

// lib/features/home_page/Superadmin/data/student_dashboard_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';

class StudentDashboardRepository {

  // Constructor
  StudentDashboardRepository();

  Future<Map<String, dynamic>> fetchDashboardData(int userId) async {
    final url = '${AppUrl.dashbordApi}?userId=$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}

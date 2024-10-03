import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';
import '../../../../utils/logger.dart';

class SupervisorStudentDashboardRepository {

  Future<Map<String, dynamic>> fetchDashboardData(int userId) async {
    final url = Uri.parse(AppUrl.dashbordApi);
    logDebug('Fetching data from $url');

    final body = {
      'user_id': userId.toString(),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      logDebug('Data received: ${response.body}');
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      logDebug('Failed to load dashboard data. Status code: ${response.statusCode}');
      throw Exception('Failed to load dashboard data');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';
import 'report_model.dart';

class StudentReportRepository {

  Future<List<StudentReport>> fetchReports({
    required String userId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      // Log request details
     // print('Sending API request to $apiUrl with user_id: $userId, start_date: $startDate, end_date: $endDate');

      final response = await http.post(
        Uri.parse(AppUrl.reportApi),
        body: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      // Log the response details
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          // Ensure 'data' is a List
          if (data['data'] is List) {
            List<dynamic> reportData = data['data'];
            return reportData.map((json) => StudentReport.fromJson(json)).toList();
          } else {
            throw Exception('API Error: Unexpected data format');
          }
        } else {
          throw Exception('API Error: ${data['message']}');
        }
      } else {
        throw Exception('API Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      // Log the error and rethrow it
      print('API Request Error: $e');
      throw Exception('Failed to load reports: $e');
    }
  }
}

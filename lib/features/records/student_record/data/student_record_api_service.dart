// lib/repositories/student_record_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';

import '../../../../utils/logger.dart';
import 'student_record_model.dart';

class StudentRecordRepository {

  // Use AppUrl.recordApi instead of a hardcoded URL
  final String apiUrl = AppUrl.recordApi;

  Future<List<StudentRecord>> fetchStudentRecord(int userId) async {
    final Map<String, String> requestBody = {
      'user_id': userId.toString(),
    };

    // Log and print the request URL and body
    final Uri requestUrl = Uri.parse(apiUrl);
    logDebug('Request URL for fetchStudentRecord: $requestUrl');

    logDebug('Request Body for fetchStudentRecord: ${jsonEncode(requestBody)}');


    try {
      final response = await http.post(
        requestUrl,
        body: requestBody,
      );

      // Log and print the status code and response body
      logDebug('Response Status Code for fetchStudentRecord: ${response.statusCode}');
      print('Response Status Code for fetchStudentRecord: ${response.statusCode}');
      logDebug('Response Body for fetchStudentRecord: ${response.body}');
      print('Response Body for fetchStudentRecord: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> data = responseData['data'];
          logDebug('Data fetched successfully for fetchStudentRecord');
          return data.map((json) => StudentRecord.fromJson(json)).toList();
        } else {
          logDebug('Error in fetchStudentRecord: ${responseData['message']}');
          return [];
        }
      } else {
        logDebug('Error: Failed to load data in fetchStudentRecord');
        return [];
      }
    } catch (error) {
      logDebug('Exception in fetchStudentRecord: $error');
      return [];
    }
  }

  Future<List<StudentRecord>> fetchStudentRecords(int userId, String endDate) async {
    final Map<String, String> requestBody = {
      'user_id': userId.toString(),
      'end_date': endDate,
    };

    // Log and print the request URL and body
    final Uri requestUrl = Uri.parse(apiUrl);
    logDebug('Request URL for fetchStudentRecords: $requestUrl');
    print('Request URL for fetchStudentRecords: $requestUrl'); // Added print statement

    logDebug('Request Body for fetchStudentRecords: ${jsonEncode(requestBody)}');
    print('Request Body for fetchStudentRecords: ${jsonEncode(requestBody)}'); // Added print statement

    try {
      final response = await http.post(
        requestUrl,
        body: requestBody,
      );

      // Log and print the status code and response body
      logDebug('Response Status Code for fetchStudentRecords: ${response.statusCode}');
      print('Response Status Code for fetchStudentRecords: ${response.statusCode}'); // Added print statement

      logDebug('Response Body for fetchStudentRecords: ${response.body}');
      print('Response Body for fetchStudentRecords: ${response.body}'); // Added print statement

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> data = responseData['data'];
          logDebug('Data fetched successfully for fetchStudentRecords');

          return data.map((json) => StudentRecord.fromJson(json)).toList();
        } else {
          logDebug('Error in fetchStudentRecords: ${responseData['message']}');

          return [];
        }
      } else {
        logDebug('Error: Failed to load data in fetchStudentRecords');

        return [];
      }
    } catch (error) {
      logDebug('Exception in fetchStudentRecords: $error');

      return [];
    }
  }

}

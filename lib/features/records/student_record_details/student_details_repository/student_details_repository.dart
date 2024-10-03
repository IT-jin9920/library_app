// lib/repositories/student_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';

import '../student_details_modal/student_details_modal.dart';
import '../student_details_modal/subscription_details.dart';


class StudentDetailsRepository {


  Future<StudentDetailsModal> fetchStudentDetails(int studentId) async {
    final response = await http.post(
      Uri.parse(AppUrl.recorddetaislApi),
      body: {
        'student_id': studentId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success' && data['data'] is Map<String, dynamic>) {
        return StudentDetailsModal.fromJson(data['data']);
      } else {
        throw Exception('Failed to load student details: ${data['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('Failed to load student details: ${response.reasonPhrase}');
    }
  }

  Future<List<SubscriptionDetailsModal>> fetchSubscriptionDetails(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.subscription_detailsApi),
//        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'student_id': studentId.toString()},
      );

      // Debugging: Print the response body
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Ensure that the response is properly formatted JSON
        final data = json.decode(response.body);

        // Debugging: Print the data to see its structure
        print('Decoded data: ${data}');

        if (data['status'] == 'success' && data['data'] is List<dynamic>) {
          return (data['data'] as List)
              .map((json) => SubscriptionDetailsModal.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load subscription details: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load subscription details: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Debugging: Print the error
      print('Error fetching subscription details: $e');
      rethrow;
    }
  }


}

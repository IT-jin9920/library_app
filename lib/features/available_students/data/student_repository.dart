// lib/repositories/student_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'student_model.dart';

class StudentRepository {
  final String apiUrl = 'https://library.mechodal.com/available_student.php';

  Future<AvailableStudentsResponse> fetchAvailableStudents(int userId) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'user_id': userId.toString(),
      },
    );

    if (response.statusCode == 200) {
      return AvailableStudentsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load students');
    }
  }
}

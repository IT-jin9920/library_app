import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';

import 'delete_student_response.dart';
import 'student_details_response.dart';
import 'student_update_response.dart';

class StudentService {

  Future<StudentDetailsResponse> getStudentDetails(int studentId) async {
    final url = Uri.parse(AppUrl.recorddetaislApi);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Correct header for form data
      body: {
        'student_id': studentId.toString(),
      },
    );

    print('Raw API Response: ${response.body}'); // Print the raw response body

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        // Ensure correct parsing based on your model
        return StudentDetailsResponse.fromJson(data);
      } catch (e) {
        throw FormatException('Error parsing response body: $e');
      }
    } else {
      throw Exception('Failed to load student details. Status: ${response.statusCode}');
    }
  }


  // Future<StudentUpdateResponse> updateStudentDetails({
  //   required int studentId,
  //   required String name,
  //   required String serialNo,
  //   required String contact,
  //   required String aadharNo,
  //   required String address,
  //   required String Empcode,
  //   required String seatNo,
  //   required String photo,
  //   required String aadharFront,
  //   required String aadharBack,
  //
  // }) async {
  //
  //   // Print the API URL and request body
  //   print('API URL: ${AppUrl.recordeditApi}');
  //
  //   final response = await http.post(
  //     Uri.parse(AppUrl.recordeditApi),
  //     body: {
  //       'student_id': studentId.toString(),
  //       'name': name,
  //       'serial_no': serialNo,
  //       'contact': contact,
  //       'aadhar_no': aadharNo,
  //       'address': address,
  //       'Empcode': Empcode,
  //       'seat_no': seatNo, // Include seat number
  //       'photo': photo, // Include profile photo URL
  //       'aadhar_front': aadharFront, // Include Aadhar front image URL
  //       'aadhar_back': aadharBack, // Include Aadhar back image URL
  //     },
  //   );
  //
  //   // Print the response status and body
  //   print('Response Status: ${response.statusCode}');
  //   print('Response Body: ${response.body}');
  //
  //
  //   if (response.statusCode == 200) {
  //     return StudentUpdateResponse.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to update student details');
  //   }
  // }

  Future<StudentUpdateResponse> updateStudentDetails({
    required int studentId,
    required String name,
    required String serialNo,
    required String contact,
    required String aadharNo,
    required String address,
    required String empCode,
    required String seatNo,
    required File? photo,
    required File? aadharFront,
    required File? aadharBack,
  }) async {
    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.recordeditApi),
    );

    // Add fields to the request
    request.fields['student_id'] = studentId.toString();
    request.fields['name'] = name;
    request.fields['serial_no'] = serialNo;
    request.fields['contact'] = contact;
    request.fields['aadhar_no'] = aadharNo;
    request.fields['address'] = address;
    request.fields['Empcode'] = empCode;
    request.fields['seat_no'] = seatNo;

    // Add files to the request if they are provided
    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }
    if (aadharFront != null) {
      request.files.add(await http.MultipartFile.fromPath('aadhar_front', aadharFront.path));
    }
    if (aadharBack != null) {
      request.files.add(await http.MultipartFile.fromPath('aadhar_back', aadharBack.path));
    }

    // Print the request fields
    print('API URL: ${AppUrl.recordeditApi}');
    print('Request Fields: ${request.fields}');

    // Send the request
    final response = await request.send();

    // Get the response body
    final responseBody = await http.Response.fromStream(response);

    // Print the response status and body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${responseBody.body}');

    if (response.statusCode == 200) {
      return StudentUpdateResponse.fromJson(json.decode(responseBody.body));
    } else {
      throw Exception('Failed to update student details: ${responseBody.body}');
    } }

  Future<void> deleteStudent(int studentId) async {
    final response = await http.post(
      Uri.parse(AppUrl.recorddeleteApi),
      body: {
        'student_id': studentId.toString(),
      },
    );

    if (response.statusCode == 200) {
      try {
        // Check if response is JSON
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print(data['message']); // Successfully deleted
        } else {
          throw Exception(data['message']);
        }
      } catch (e) {
        // Handle JSON decoding errors
        throw Exception('Error parsing response: $e');
      }
    } else {
      throw Exception('Failed to delete student, status code: ${response.statusCode}');
    }
  }

}

// // lib/repositories/registration_repository.dart
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:library_app/res/app_url/app_url.dart';
// import '../../../utils/logger.dart';
// import 'registration_model.dart';
//
// class RegistrationRepository {
//   Future<RegistrationResponse> registerStudent({
//     required String name,
//     required String serialNo,
//     required String contact,
//     required String aadharNo,
//     required String address,
//     required String startDate,
//     required String endDate,
//     required String fee,
//     required String userId,
//   }) async {
//     final Map<String, dynamic> requestPayload = {
//       'name': name,
//       'serial_no': serialNo,
//       'contact': contact,
//       'aadhar_no': aadharNo,
//       'address': address,
//       'start_date': startDate,
//       'end_date': endDate,
//       'fee': fee,
//       'user_id': userId,
//     };
//
//     logDebug('Request body: ${jsonEncode(requestPayload)}');
//
//     final response = await http.post(
//       Uri.parse(AppUrl.registerApi),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(requestPayload),
//     );
//
//     logDebug('Response status: ${response.statusCode}');
//     logDebug('Response body: ${response.body}');
//
//     // Handle unexpected response formats
//     if (response.statusCode == 200) {
//       try {
//         final responseBody = jsonDecode(response.body);
//         return RegistrationResponse.fromJson(responseBody);
//       } catch (e) {
//         logDebug('Error parsing JSON response: $e');
//         throw Exception('Failed to parse response');
//       }
//     } else {
//       logDebug('Unexpected server response: ${response.body}');
//       throw Exception('Server responded with status code: ${response.statusCode}');
//     }
//   }
// }

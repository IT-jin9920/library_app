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
//     required String seatNo,
//     required String paymentMode,
//     required String empCode,
//   }) async {
//     // Create the request payload
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
//     // Log the request body
//     logDebug('Request body: ${jsonEncode(requestPayload)}');
//
//     try {
//       // Send the HTTP POST request
//       final response = await http.post(
//         Uri.parse(AppUrl.registerApi),
//         // headers: {'Content-Type': 'application/json'},
//         body:requestPayload,
//       );
//      // logDebug('You are Here Reg repo');
//       // Log the response status and body
//       logDebug('Response status: ${response.statusCode}');
//       logDebug('Response body: ${response.body}');
//
//       // Check for successful status code
//       if (response.statusCode == 200) {
//         try {
//           // Try to parse the response body as JSON
//           final jsonResponse = jsonDecode(response.body);
//
//           if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('status')) {
//             if (jsonResponse['status'] == 'success') {
//               return RegistrationResponse.fromJson(jsonResponse);
//             } else {
//               throw Exception('Registration failed: ${jsonResponse['message']}');
//             }
//           } else {
//             throw Exception('Unexpected response format');
//           }
//         } catch (e) {
//           // Log and throw an error if JSON parsing fails
//           logDebug('Error parsing JSON response: $e');
//           throw Exception('Failed to parse response');
//         }
//       } else {
//         // Handle other status codes
//         throw Exception('Failed to register student: HTTP status ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle network errors or other issues
//       logDebug('Error during request: $e');
//       throw Exception('Network error or request failed');
//     }
//   }
//
// }

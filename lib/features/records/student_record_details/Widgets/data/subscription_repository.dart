// // lib/repositories/subscription_repository.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:library_app/res/app_url/app_url.dart';
//
// import 'subscription_response.dart';
//
// class SubscriptionRepository {
//   //final String _url = 'https://library.mechodal.com/add_new_subscription.php';
//
//   Future<SubscriptionResponse> addSubscription({
//     required int studentId,
//     required String startDate,
//     required String endDate,
//     required String fee,
//     required String feesInWords,
//     required String paymentMode,
//   }) async {
//
//
//     final response = await http.post(
//       Uri.parse(AppUrl.new_subscriptionApi),
//       body: {
//         'student_id': studentId.toString(),
//         'start_date': startDate,
//         'end_date': endDate,
//         'fee': fee,
//         'fees_in_word': feesInWords,
//         'payment_mode': paymentMode,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       return SubscriptionResponse.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to submit subscription');
//     }
//   }
// }

// lib/repositories/subscription_repository.dart
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';
import 'subscription_response.dart';

void logDebug(String message) {
  // Replace this with your preferred logging mechanism
  print(message);
}

class SubscriptionRepository {
  // final String _url = 'https://library.mechodal.com/add_new_subscription.php';

  Future<SubscriptionResponse> addSubscription({
    required int studentId,
    required String startDate, // Expects format 'dd-MM-yyyy'
    required String endDate,   // Expects format 'dd-MM-yyyy'
    required String fee,
    required String feesInWords,
    required String paymentMode,
  }) async {

    // Parse the input dates from 'dd-MM-yyyy' to DateTime
    DateTime parsedStartDate = DateFormat('dd-MM-yyyy').parse(startDate);
    DateTime parsedEndDate = DateFormat('dd-MM-yyyy').parse(endDate);

    // Format the dates to 'yyyy-MM-dd'
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(parsedStartDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(parsedEndDate);

    // Prepare the request body
    final requestBody = {
      'student_id': studentId.toString(),
      'start_date': formattedStartDate, // Use formatted date
      'end_date': formattedEndDate,       // Use formatted date
      'fee': fee,
      'fees_in_word': feesInWords,
      'payment_mode': paymentMode,
    };

    // Log the request body for debugging
    logDebug('Sending request to ${AppUrl.new_subscriptionApi} with body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse(AppUrl.new_subscriptionApi),
      body: requestBody,
    );

    // Log the response status and body
    logDebug('Response status: ${response.statusCode}');
    logDebug('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return SubscriptionResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to submit subscription: ${response.statusCode} - ${response.body}');
    }
  }
}

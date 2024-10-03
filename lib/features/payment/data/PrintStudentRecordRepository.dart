import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';

import '../../../../utils/logger.dart';
import 'PrintStudentRecordsDetails_Modal.dart';
import 'Printstudent_record_model.dart';

class PrintStudentRecordRepository {

  Future<List<PrintStudentRecord>> fetchStudentRecord(int userId) async {
    final Map<String, String> requestBody = {
      'user_id': userId.toString(),
    };

    final Uri requestUrl = Uri.parse(AppUrl.recordApi);
    logDebug('Request URL for fetchStudentRecord: $requestUrl');
    logDebug('Request Body for fetchStudentRecord: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        requestUrl,
        body: requestBody,
      );

      logDebug('Response Status Code for fetchStudentRecord: ${response.statusCode}');
      logDebug('Response Body for fetchStudentRecord: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> data = responseData['data'];
          return data.map((json) => PrintStudentRecord.fromJson(json)).toList();
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

  Future<List<PrintStudentRecordsDetails>> fetchSubscriptionDetails(int studentId) async {
    final Map<String, String> requestBody = {
      'student_id': studentId.toString(),
    };

    final Uri requestUrl = Uri.parse(AppUrl.subscription_detailsApi);
    logDebug('Request URL for fetchSubscriptionDetails: $requestUrl');
    logDebug('Request Body for fetchSubscriptionDetails: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        requestUrl,
        body: requestBody,
      );

      logDebug('Response Status Code for fetchSubscriptionDetails: ${response.statusCode}');
      logDebug('Response Body for fetchSubscriptionDetails: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> data = responseData['data'];
          return data.map((json) {
            try {
              return PrintStudentRecordsDetails.fromJson(json);
            } catch (e) {
              logDebug('Error parsing record: $e');
              return PrintStudentRecordsDetails(); // Return a default instance on error
            }
          }).toList();
        } else {
          logDebug('Error in fetchSubscriptionDetails: ${responseData['message']}');
          return [];
        }
      } else {
        logDebug('Error: Failed to load data in fetchSubscriptionDetails');
        return [];
      }
    } catch (error) {
      logDebug('Exception in fetchSubscriptionDetails: $error');
      return [];
    }
  }

}

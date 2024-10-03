import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../utils/utils.dart';
import '../app_excaption.dart';
import 'BaseApiService.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      print('GET request to: $url');
    }

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      return _returnResponse(response);
    } on SocketException {
      Utils.snackBar('Network Error', 'No internet connection');
      throw InternetException('No internet connection');
    } on TimeoutException {
      Utils.snackBar('Request Timeout', 'Request timed out');
      throw RequestTimeOut('Request timed out');
    } catch (e) {
      Utils.snackBar('Unexpected Error', 'An unexpected error occurred: $e');
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<dynamic> postApi(dynamic data, String url) async {
    if (kDebugMode) {
      print('POST request to: $url');
      print('Data: $data');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      return _returnResponse(response);
    } on SocketException {
      Utils.snackBar('Network Error', 'No internet connection');
      throw InternetException('No internet connection');
    } on TimeoutException {
      Utils.snackBar('Request Timeout', 'Request timed out');
      throw RequestTimeOut('Request timed out');
    } catch (e) {
      Utils.snackBar('Unexpected Error', 'An unexpected error occurred: $e');
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw FetchDataException('Bad request: ${response.body}');
      case 401:
        throw FetchDataException('Unauthorized: ${response.body}');
      case 403:
        throw FetchDataException('Forbidden: ${response.body}');
      case 404:
        throw FetchDataException('Not found: ${response.body}');
      case 500:
        throw ServerException('Internal server error: ${response.body}');
      default:
        throw FetchDataException('Unexpected error: ${response.statusCode}');
    }
  }
}

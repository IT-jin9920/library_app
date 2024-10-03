import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/res/app_url/app_url.dart';
import '../../../data/app_excaption.dart';
import '../../../utils/logger.dart';
import '../../../utils/utils.dart';
import 'login_model.dart';

class AuthRepository {

  Future<LoginModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrl.loginApi),
        body: {
          'email': email,
          'password': password,
        },
      );

      logDebug('Response status: ${response.statusCode}');
      logDebug('Response body: ${response.body}');

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseJson['status'] == 'error') {
          final errorMessage = responseJson['message'] ?? 'An error occurred';
          throw AppExceptions(errorMessage, 'Login Error: ');
        }

        if (responseJson['status'] == 'success') {
          return LoginModel.fromJson(responseJson);
        } else {
          final errorMessage = responseJson['message'] ?? 'Unexpected status received';
          throw AppExceptions(errorMessage, 'Unexpected Status: ');
        }
      } else if (response.statusCode == 401) {
        // Specifically handle 401 Unauthorized error
        final errorMessage = responseJson['message'] ?? 'Unauthorized access';
        throw AppExceptions(errorMessage, 'Unauthorized Error: ');
      } else {
        final errorMessage = 'Failed to login with status code ${response.statusCode}';
        throw FetchDataException(errorMessage);
      }
    } catch (e) {
      logDebug('Login error: $e');
      throw FetchDataException('$e');
    }
  }
}


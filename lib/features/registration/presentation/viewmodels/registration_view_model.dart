// // lib/viewmodels/registration_viewmodel.dart
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../utils/logger.dart';
// import '../../data/registration_model.dart';
// import '../../data/registration_repository.dart';
//
// class RegistrationViewModel extends ChangeNotifier {
//   final RegistrationRepository _registrationRepository;
//
//   RegistrationViewModel(this._registrationRepository);
//
//   bool _isLoading = false;
//   String? _errorMessage;
//   RegistrationResponse? _registrationResponse;
//
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   RegistrationResponse? get registrationResponse => _registrationResponse;
//
//   Future<String?> registerStudent({
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
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final response = await _registrationRepository.registerStudent(
//         name: name,
//         serialNo: serialNo,
//         contact: contact,
//         aadharNo: aadharNo,
//         address: address,
//         startDate: startDate,
//         endDate: endDate,
//         fee: fee,
//         userId: userId,
//         seatNo: seatNo,
//         paymentMode: paymentMode,
//         empCode: empCode,
//       );
//       _registrationResponse = response;
//
//       if (response.status == 'success') {
//         final studentId = response.studentId;
//         logDebug('Registration successful: ${response.message}');
//         return studentId?.toString();
//       } else {
//         _errorMessage = response.message;
//         logDebug('Registration failed: ${response.message}');
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'An error occurred: $e';
//       logDebug(_errorMessage!);
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//
// }

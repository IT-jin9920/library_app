// lib/view_models/print_payment_view_model.dart
import 'package:flutter/material.dart';

class PrintPaymentViewModel extends ChangeNotifier {
  String? selectedStudent;
  String? selectedSubscription;
  int? _selectedStudentId;

  // List<String> studentNames = [
  //   'John Doe',
  //   'Jane Smith',
  //   'Michael Johnson',
  //   'Emily Davis',
  //   // Add more student names as needed
  // ];
  //
  // List<Map<String, String>> subscriptions = [
  //   {'subscriptionPeriod': 'Monthly', 'upgradedAt': '01-09-2024', 'amount': '100 USD'},
  //   {'subscriptionPeriod': 'Quarterly', 'upgradedAt': '01-09-2024', 'amount': '250 USD'},
  //   // Add more subscriptions as needed
  // ];

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _feesController = TextEditingController();

  FocusNode _startDateFocusNode = FocusNode();
  FocusNode _endDateFocusNode = FocusNode();
  FocusNode _feesFocusNode = FocusNode();

  TextEditingController get startDateController => _startDateController;
  TextEditingController get endDateController => _endDateController;
  TextEditingController get feesController => _feesController;

  FocusNode get startDateFocusNode => _startDateFocusNode;
  FocusNode get endDateFocusNode => _endDateFocusNode;
  FocusNode get feesFocusNode => _feesFocusNode;

  // Mock fetch method for students (usually from an API or database)
  Future<void> fetchStudentRecords() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }
}

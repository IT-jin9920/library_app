// lib/viewmodels/student_view_model.dart
import 'package:flutter/material.dart';

import '../student_details_modal/student_details_modal.dart';
import '../student_details_modal/subscription_details.dart';
import '../student_details_repository/student_details_repository.dart';


class StudentDetailsViewModel extends ChangeNotifier {
  final StudentDetailsRepository _repository = StudentDetailsRepository();

  StudentDetailsModal? _student;
  StudentDetailsModal? get student => _student;

  List<SubscriptionDetailsModal> _subscriptions = [];
  List<SubscriptionDetailsModal> get subscriptions => _subscriptions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? get studentName => _student?.name; // Add this getter

  Future<void> fetchStudentDetails(int studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _student = await _repository.fetchStudentDetails(studentId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubscriptionDetails(int studentId) async {
    try {
      _subscriptions = await _repository.fetchSubscriptionDetails(studentId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}


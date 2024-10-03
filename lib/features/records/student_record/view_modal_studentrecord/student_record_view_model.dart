import 'package:flutter/material.dart';

import '../data/student_record_api_service.dart';
import '../data/student_record_model.dart';



class StudentRecordViewModel extends ChangeNotifier {
  final StudentRecordRepository _repository = StudentRecordRepository();

  List<StudentRecord> _studentRecords = [];
  List<StudentRecord> get studentRecords => _studentRecords;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchStudentRecord(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _studentRecords = await _repository.fetchStudentRecord(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load student records';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStudentRecords(int userId, String endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      _studentRecords = await _repository.fetchStudentRecords(userId, endDate);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load student records';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

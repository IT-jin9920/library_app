import 'package:flutter/material.dart';
import '../data/report_model.dart';
import '../data/report_repository.dart';

class StudentReportViewModel extends ChangeNotifier {
  final StudentReportRepository _repository = StudentReportRepository();

  List<StudentReport> _reports = [];
  bool _isLoading = false;
  String _error = '';

  List<StudentReport> get reports => _reports;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchReports({
    required String userId,
    required String startDate,
    required String endDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reports = await _repository.fetchReports(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      _error = '';
    } catch (e) {
      _error = e.toString();
      _reports = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

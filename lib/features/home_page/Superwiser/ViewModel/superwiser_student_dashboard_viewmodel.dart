import 'package:flutter/material.dart';
import '../../../../utils/logger.dart';
import '../data/SuperwiserStudentDashboardRepository.dart';
import '../data/superwiser_student_dashboard_model.dart';

class SupervisorStudentDashboardViewModel extends ChangeNotifier {
  final SupervisorStudentDashboardRepository _repository;
  SupervisorStudentDashboardModel? _dashboardData;
  String _error = '';
  bool _isLoading = false;

  SupervisorStudentDashboardViewModel(this._repository);

  SupervisorStudentDashboardModel? get dashboardData => _dashboardData;
  String get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadDashboardData(int userId) async {
    _isLoading = true;
    notifyListeners();
    logDebug('Loading dashboard data for userId: $userId');

    try {
      final Map<String, dynamic> data = await _repository.fetchDashboardData(userId);
      logDebug('Dashboard data: $data');
      if (data.isNotEmpty) {
        _dashboardData = SupervisorStudentDashboardModel.fromJson(data);
      } else {
        _dashboardData = null;
        _error = 'No data available';
      }
    } catch (e) {
      _error = e.toString();
      logDebug('Error loading data: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String get availableCount => _dashboardData?.todayAvailableStudents ?? '0';
  String get leftLibraryCount => _dashboardData?.leftLibraryStudents ?? '0';
  String get presentTodayCount => _dashboardData?.todayPresentStudents ?? '0';
}

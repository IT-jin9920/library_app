// lib/viewmodels/student_viewmodel.dart

import 'package:flutter/material.dart';

import '../data/student_model.dart';
import '../data/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository;
  StudentViewModel(this._repository);

  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  int _studentCount = 0;
  int get studentCount => _studentCount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchAvailableStudents(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.fetchAvailableStudents(userId);
      _students = response.todayAvailableStudents;
      _studentCount = response.todayAvailableStudentsCount;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

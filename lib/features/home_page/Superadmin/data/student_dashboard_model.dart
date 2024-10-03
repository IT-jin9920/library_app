// lib/data/student_model.dart

class StudentModel {
  final String name;
  final String inTime;

  StudentModel({
    required this.name,
    required this.inTime,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'] ?? '',
      inTime: json['in_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'in_time': inTime,
    };
  }
}

// lib/data/student_dashboard_model.dart


class StudentDashboardModel {
  final String todayAvailableStudents;
  final String leftLibraryStudents;
  final String todayPresentStudents;
  final List<StudentModel> availableStudents;

  StudentDashboardModel({
    required this.todayAvailableStudents,
    required this.leftLibraryStudents,
    required this.todayPresentStudents,
    required this.availableStudents,
  });

  factory StudentDashboardModel.fromJson(Map<String, dynamic> json) {
    return StudentDashboardModel(
      todayAvailableStudents: json['today_available_students'] ?? '0',
      leftLibraryStudents: json['left_library_students'] ?? '0',
      todayPresentStudents: json['today_present_students'] ?? '0',
      availableStudents: (json['available_students'] as List<dynamic>? ?? [])
          .map((item) => StudentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_available_students': todayAvailableStudents,
      'left_library_students': leftLibraryStudents,
      'today_present_students': todayPresentStudents,
      'available_students': availableStudents.map((student) => student.toJson()).toList(),
    };
  }
}

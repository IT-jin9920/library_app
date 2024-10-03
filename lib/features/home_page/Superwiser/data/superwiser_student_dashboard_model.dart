
class Student {
  final String name;
  final String inTime;

  Student({
    required this.name,
    required this.inTime,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] as String? ?? '',
      inTime: json['inTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'inTime': inTime,
    };
  }
}


class SupervisorStudentDashboardModel {
  final String todayAvailableStudents;
  final String leftLibraryStudents;
  final String todayPresentStudents;
  final List<Student> availableStudents;

  SupervisorStudentDashboardModel({
    required this.todayAvailableStudents,
    required this.leftLibraryStudents,
    required this.todayPresentStudents,
    required this.availableStudents,
  });

  factory SupervisorStudentDashboardModel.fromJson(Map<String, dynamic> json) {
    return SupervisorStudentDashboardModel(
      todayAvailableStudents: json['today_available_students'] as String? ?? '0',
      leftLibraryStudents: json['left_library_students'] as String? ?? '0',
      todayPresentStudents: json['today_present_students'] as String? ?? '0',
      availableStudents: (json['available_students'] as List<dynamic>?)
          ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_available_students': todayAvailableStudents,
      'left_library_students': leftLibraryStudents,
      'today_present_students': todayPresentStudents,
      'available_students': availableStudents.map((e) => e.toJson()).toList(),
    };
  }
}

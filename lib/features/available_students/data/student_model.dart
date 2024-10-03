// lib/models/student_model.dart

class StudentModel {
  final String id;
  final String name;
  final String lastSignInTime;

  StudentModel({
    required this.id,
    required this.name,
    required this.lastSignInTime,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      lastSignInTime: json['last_sign_in_time'],
    );
  }
}

class AvailableStudentsResponse {
  final int todayAvailableStudentsCount;
  final List<StudentModel> todayAvailableStudents;

  AvailableStudentsResponse({
    required this.todayAvailableStudentsCount,
    required this.todayAvailableStudents,
  });

  factory AvailableStudentsResponse.fromJson(Map<String, dynamic> json) {
    var studentsJson = json['today_available_students'] as List;
    List<StudentModel> studentsList = studentsJson.map((i) => StudentModel.fromJson(i)).toList();

    return AvailableStudentsResponse(
      todayAvailableStudentsCount: json['today_available_students_count'],
      todayAvailableStudents: studentsList,
    );
  }
}

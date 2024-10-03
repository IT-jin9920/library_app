// lib/models/student_report.dart
class StudentReport {
  final String studentId;
  final String studentName;
  final String id;
  final String startDate;
  final String endDate;
  final String fee;
  final String createdAt;

  StudentReport({
    required this.studentId,
    required this.studentName,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.fee,
    required this.createdAt,
  });

  factory StudentReport.fromJson(Map<String, dynamic> json) {
    return StudentReport(
      studentId: json['student_id'],
      studentName: json['student_name'],
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      fee: json['fee'],
      createdAt: json['created_at'],
    );
  }
}

// lib/features/records/data/models/delete_student_response.dart

class DeleteStudentResponse {
  final String status;
  final String message;

  DeleteStudentResponse({required this.status, required this.message});

  factory DeleteStudentResponse.fromJson(Map<String, dynamic> json) {
    return DeleteStudentResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

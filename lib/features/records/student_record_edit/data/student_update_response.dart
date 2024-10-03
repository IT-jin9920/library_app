class StudentUpdateResponse {
  final String status;
  final String message;

  StudentUpdateResponse({required this.status, required this.message});

  factory StudentUpdateResponse.fromJson(Map<String, dynamic> json) {
    return StudentUpdateResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

// lib/models/student.dart
class StudentDetailsModal {
  final String id;
  final String userId;
  final String name;
  final String serialNo;
  final String contact;
  final String aadharNo;
  final String address;
  final String date;
  final String updateAt;

  StudentDetailsModal({
    required this.id,
    required this.userId,
    required this.name,
    required this.serialNo,
    required this.contact,
    required this.aadharNo,
    required this.address,
    required this.date,
    required this.updateAt,
  });

  factory StudentDetailsModal.fromJson(Map<String, dynamic> json) {
    return StudentDetailsModal(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      serialNo: json['serial_no'] ?? '',
      contact: json['contact'] ?? '',
      aadharNo: json['aadhar_no'] ?? '',
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      updateAt: json['update_at'] ?? '',
    );
  }
}

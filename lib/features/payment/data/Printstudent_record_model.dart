// lib/models/Printstudent_record_model.dart
import 'dart:convert';

class PrintStudentRecord {
  final String id;
  final String userId;
  final String name;
  final String serialNo;
  final String contact;
  final String aadharNo;
  final String address;
  final String date;
  final String updateAt;
  final String studentId;
  final String startDate;
  final String endDate;
  final String fee;
  final String createdAt;

  PrintStudentRecord({
    required this.id,
    required this.userId,
    required this.name,
    required this.serialNo,
    required this.contact,
    required this.aadharNo,
    required this.address,
    required this.date,
    required this.updateAt,
    required this.studentId,
    required this.startDate,
    required this.endDate,
    required this.fee,
    required this.createdAt,
  });

  factory PrintStudentRecord.fromJson(Map<String, dynamic> json) {
    return PrintStudentRecord(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      serialNo: json['serial_no'],
      contact: json['contact'],
      aadharNo: json['aadhar_no'],
      address: json['address'],
      date: json['date'],
      updateAt: json['update_at'],
      studentId: json['student_id'],
      startDate: json['start_date'] ?? 'N/A',
      endDate: json['end_date'] ?? 'N/A',
      fee: json['fee'] ?? 'N/A',
      createdAt: json['created_at'] ?? 'N/A',
    );
  }
}



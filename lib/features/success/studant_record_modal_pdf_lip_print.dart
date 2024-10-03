
class StudentRecord {
  final String name;
  final String studentId;
  final String fee;
  final String startDate;
  final String endDate;
  final String serialNo;
  final String contact;
  final String aadharNo;
  final String address;

  StudentRecord({
    required this.name,
    required this.studentId,
    required this.fee,
    required this.startDate,
    required this.endDate,
    required this.serialNo,
    required this.contact,
    required this.aadharNo,
    required this.address,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      name: json['name'],
      studentId: json['student_id'],
      fee: json['fee'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      serialNo: json['serial_no'],
      contact: json['contact'],
      aadharNo: json['aadhar_no'],
      address: json['address'],
    );
  }
}

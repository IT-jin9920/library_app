
class ModelStudentRegisterDemo {
  String studentName;
  DateTime startDate;
  DateTime endDate;
  double fees;
  String serialNumber;
  String contactDetails;
  String aadharNumber;
  String address;
  String seatNo;         // New field
  String paymentMode;    // New field
  String empCode;        // New field

  ModelStudentRegisterDemo({
    required this.studentName,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.serialNumber,
    required this.contactDetails,
    required this.aadharNumber,
    required this.address,
    required this.seatNo,       // New parameter
    required this.paymentMode,   // New parameter
    required this.empCode,       // New parameter
  });

  Map<String, dynamic> toJson() => {
    'studentName': studentName,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'fees': fees,
    'serialNumber': serialNumber,
    'contactDetails': contactDetails,
    'aadharNumber': aadharNumber,
    'address': address,
    'seatNo': seatNo,           // Include in JSON
    'paymentMode': paymentMode, // Include in JSON
    'empCode': empCode,         // Include in JSON
  };

  factory ModelStudentRegisterDemo.fromJson(Map<String, dynamic> json) => ModelStudentRegisterDemo(
    studentName: json['studentName'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    fees: json['fees'],
    serialNumber: json['serialNumber'],
    contactDetails: json['contactDetails'],
    aadharNumber: json['aadharNumber'],
    address: json['address'],
    seatNo: json['seatNo'],
    paymentMode: json['paymentMode'],
    empCode: json['empCode'],
  );
}

// lib/models/registration_model.dart

class RegistrationResponse {
  final String status;
  final String message;
  final int? studentId;

  RegistrationResponse({
    required this.status,
    required this.message,
    this.studentId,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'],
      message: json['message'],
      studentId: json['student_id'],
    );
  }
}

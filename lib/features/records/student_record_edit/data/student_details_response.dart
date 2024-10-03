class StudentDetailsResponse {
  final String status;
  final String message;
  final StudentData data;

  StudentDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StudentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return StudentDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: StudentData.fromJson(json['data']),
    );
  }
}

class StudentData {
  final String id;
  final String userId;
  final String name;
  final String serialNo;
  final String contact;
  final String aadharNo;
  final String address;
  final String empCode;
  final String photo;
  final String aadharFront;
  final String aadharBack;
  final String seatNo;

  StudentData({
    required this.id,
    required this.userId,
    required this.name,
    required this.serialNo,
    required this.contact,
    required this.aadharNo,
    required this.address,
    required this.empCode,
    required this.photo,
    required this.aadharFront,
    required this.aadharBack,
    required this.seatNo,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      serialNo: json['serial_no'],
      contact: json['contact'],
      aadharNo: json['aadhar_no'],
      address: json['address'],
      empCode: json['Empcode'],
      photo: json['photo'], // Include Profile Photo URL
      aadharFront: json['aadhar_front'], // Include Aadhar Front Image URL
      aadharBack: json['aadhar_back'], // Include Aadhar Back Image URL
      seatNo: json['seat_no'], // Include Seat Number

    );
  }
}

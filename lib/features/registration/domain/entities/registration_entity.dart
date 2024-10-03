// lib/domain/entities/registration_entity.dart
class RegistrationEntity {
  final String studentName;
  final DateTime startDate;
  final DateTime endDate;
  final double fees;
  final String serialNumber;
  final String contactDetails;
  final String aadharNumber;
  final String address;

  RegistrationEntity({
    required this.studentName,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.serialNumber,
    required this.contactDetails,
    required this.aadharNumber,
    required this.address,
  });
}

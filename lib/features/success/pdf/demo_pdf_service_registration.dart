import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';

class PdfService {
  Future<Uint8List> generatePdf({
    required String studentName,
    required String serialNo,
    required String contact,
    required String aadharNo,
    required String address,
    required String startDate,
    required String endDate,
    required String fee,
    required String feeWord,
    required String userId,
    required String seatNo,
    required String paymentMode,
    required String empCode,
    String? profileImagePath,
    String? aadharFrontImagePath,
    String? aadharBackImagePath,
  }) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/Poppins/Poppins-Regular.ttf');
    final font = pw.Font.ttf(fontData);

    final logoData = await rootBundle.load('assets/images/login-img.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    // Get current date formatted
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Define a custom light grey color
    final lightGreyColor = PdfColor.fromInt(0xFFB0B0B0); // Light grey color

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (profileImagePath != null && profileImagePath.isNotEmpty)
                    pw.Image(
                      pw.MemoryImage(File(profileImagePath).readAsBytesSync()),
                      height: 50,
                    ),
                  pw.SizedBox(width: 50),
                  pw.Image(logoImage, height: 100),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Student Registration Form',
                style: pw.TextStyle(fontSize: 30, font: font, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              _buildDetailsTable(
                studentName: studentName,
                serialNo: serialNo,
                contact: contact,
                aadharNo: aadharNo,
                address: address,
                startDate: startDate,
                endDate: endDate,
                fee: fee,
                feeWord: feeWord,
                userId: userId,
                seatNo: seatNo,
                paymentMode: paymentMode,
                empCode: empCode,
                font: font,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 10), // Spacing
                  if (aadharFrontImagePath != null && aadharFrontImagePath.isNotEmpty)
                    pw.Transform.rotate(
                      angle: 3.14 / 2, // Rotate 90 degrees (in radians)
                      child: pw.Image(
                        pw.MemoryImage(File(aadharFrontImagePath).readAsBytesSync()),
                        height: 100,
                        width: 200,
                      ),
                    ),
                    // pw.Image(
                    //   pw.MemoryImage(File(aadharFrontImagePath).readAsBytesSync()),
                    //   height: 100,
                    //   width: 200,
                    // ),
                  pw.SizedBox(width: 10), // Spacing
                  if (aadharBackImagePath != null && aadharBackImagePath.isNotEmpty)
                    pw.Transform.rotate(
                      angle: 3.14 / 2, // Rotate 90 degrees (in radians)
                      child: pw.Image(
                        pw.MemoryImage(File(aadharBackImagePath).readAsBytesSync()),
                        height: 100,
                        width: 200,
                      ),
                    ),
                    // pw.Image(
                    //   pw.MemoryImage(File(aadharBackImagePath).readAsBytesSync()),
                    //   height: 100,
                    //   width: 200,
                    // ),
                  pw.SizedBox(width: 10),
                ],
              ),
              pw.SizedBox(height: 10),
              // Footer with signature and created date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Created At: $formattedDate',
                    style: pw.TextStyle(
                      fontSize: 18,
                      font: font,
                      color: lightGreyColor, // Custom lighter color
                    ),
                  ),
                  pw.Text(
                    'Student Signature',
                    style: pw.TextStyle(
                      fontSize: 18,
                      font: font,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildDetailsTable({
    required String studentName,
    required String serialNo,
    required String contact,
    required String aadharNo,
    required String address,
    required String startDate,
    required String endDate,
    required String fee,
    required String feeWord,
    required String userId,
    required String seatNo,
    required String paymentMode,
    required String empCode,
    required pw.Font font,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        _buildTableRow('Student Name', studentName, font),
        _buildTableRow('Serial Number', serialNo, font),
        _buildTableRow('Contact Details', contact, font),
        _buildTableRow('Aadhar Number', aadharNo, font),
        _buildTableRow('Address', address, font),
        _buildTableRow('Start Date', startDate, font),
        _buildTableRow('End Date', endDate, font),
        _buildTableRow('Fees', fee, font),
        _buildTableRow('Fees Word', feeWord, font),
        //_buildTableRow('User ID', userId, font),
        _buildTableRow('Seat No', seatNo, font),
        _buildTableRow('Payment Mode', paymentMode, font),
        _buildTableRow('Device  Code', empCode, font),
      ],
    );
  }

  pw.TableRow _buildTableRow(String title, String value, pw.Font font) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(title, style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(value, style: pw.TextStyle(font: font)),
        ),
      ],
    );
  }
}

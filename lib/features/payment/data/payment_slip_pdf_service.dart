import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart'; // For date formatting

class PaymentSlipPdfService {
  Future<Uint8List> generatePaymentSlipPdf({
    required String studentName,
    required String startDate,
    required String endDate,
    required String fee,
    required String feeWord,
    required String payment_mode,
  }) async {
    final pdf = pw.Document();

    // Load the Poppins font and logo image
    final fontData = await rootBundle.load('assets/fonts/Poppins/Poppins-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final logoData = await rootBundle.load('assets/images/login-img.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    // Get current date formatted
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Define a custom light grey color
    final lightGreyColor = PdfColor.fromInt(0xFFB0B0B0); // Light grey color

    // Add payment slip page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Image(logoImage, height: 100),
                    pw.SizedBox(height: 50),
                    pw.Text(
                      'Student Payment Slip Details',
                      style: pw.TextStyle(fontSize: 30, font: font, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 50),
                    _buildPaymentSlipTable(
                      studentName: studentName,
                      startDate: startDate,
                      endDate: endDate,
                      fee: fee,
                      feeWord: feeWord,
                      payment_mode : payment_mode,
                      font: font,
                    ),
                    pw.SizedBox(height: 200),
                    // Footer with created date
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Created At: $formattedDate',
                          style: pw.TextStyle(fontSize: 18, font: font, color: lightGreyColor),
                        ),
                        pw.Text(
                          'Student Signature ',
                          style: pw.TextStyle(fontSize: 18, font: font),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Utility method to build details table for payment slip
  pw.Widget _buildPaymentSlipTable({
    required String studentName,
    required String startDate,
    required String endDate,
    required String fee,
    required String feeWord,
    required String payment_mode,
    required pw.Font font,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1, color: PdfColors.black),
      columnWidths: {
        0: pw.FractionColumnWidth(0.4),
        1: pw.FractionColumnWidth(0.6),
      },
      children: [
        _buildTableRow('Student Name', studentName, font),
        _buildTableRow('Start Date', startDate, font),
        _buildTableRow('End Date', endDate, font),
        _buildTableRow('Fees', fee, font),
        _buildTableRow('Fees Word', feeWord, font),
        _buildTableRow('Payment mode', payment_mode, font),
      ],
    );
  }

  // Utility method to build a table row
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

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/text_style.dart';
import '../../utils/logger.dart';
import '../payment/data/payment_slip_pdf_service.dart';
import 'pdf/pdf_service_registration.dart';
import '../records/student_record/data/student_record_model.dart';

class SuccessRegistrationScreen extends StatefulWidget {
  final String? studentId;
  final Map<String, dynamic>? requestBody;
  final Map<String, String>? images;


  const SuccessRegistrationScreen({
    super.key,
    this.studentId,
    this.requestBody,
    this.images,
  });

  @override
  _SuccessRegistrationScreenState createState() => _SuccessRegistrationScreenState();
}

class _SuccessRegistrationScreenState extends State<SuccessRegistrationScreen> {
  StudentRecord? _studentRecord;

  @override
  void initState() {
    super.initState();
    logDebug('Received Student ID: ${widget.studentId}');

    // Format and log the request body with each key-value pair on a new line
    final requestBodyLog = widget.requestBody?.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n') ?? 'No request body available';

    logDebug('Received Request Body:\n$requestBodyLog');
    logDebug('Received Images: ${widget.images}');


    final studentId = widget.studentId ?? '';
    if (studentId.isNotEmpty) {
      _fetchStudentDetails(int.parse(studentId));
    }

  }

  Future<void> _printPdf() async {
    if (widget.requestBody == null) {
      logDebug('No request body available to generate PDF.');
      return;
    }

    logDebug('Starting PDF generation for student: ${widget.requestBody!['name']}');

    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generatePdf(
        studentName: widget.requestBody!['name'] ?? 'N/A',
        serialNo: widget.requestBody!['serial_no'] ?? 'N/A',
        contact: widget.requestBody!['contact'] ?? 'N/A',
        aadharNo: widget.requestBody!['aadhar_no'] ?? 'N/A',
        address: widget.requestBody!['address'] ?? 'N/A',
        startDate: widget.requestBody!['start_date'] ?? 'N/A',
        endDate: widget.requestBody!['end_date'] ?? 'N/A',
        fee: widget.requestBody!['fee'] ?? 'N/A',
        feeWord: widget.requestBody!['fees_in_word'] ?? 'N/A',
        userId: widget.requestBody!['user_id'] ?? 'N/A',
        seatNo: widget.requestBody!['seat_no'] ?? 'N/A',
        paymentMode: widget.requestBody!['payment_mode'] ?? 'N/A',
        empCode: widget.requestBody!['Empcode'] ?? 'N/A',
        profileImagePath: widget.images?['profileImage'],
        aadharFrontImagePath: widget.images?['aadharFrontImage'],
        aadharBackImagePath: widget.images?['aadharBackImage'],
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
      logDebug('Print job sent successfully for student: ${widget.requestBody!['name']}');
    } catch (e) {
      logDebug('Error occurred during PDF generation or printing: $e');
    }
  }

  Future<void> _generatePaymentSlipPdf() async {
    if (_studentRecord == null) {
      logDebug('No student record available to generate payment slip PDF.'); // Log if no record is available
      return;
    }

    logDebug('Starting Payment Slip PDF generation for student: ${_studentRecord!.feeWord}'); // Log start of PDF generation

    try {
      final paymentSlipPdfService = PaymentSlipPdfService(); // Correct service
      final pdfBytes = await paymentSlipPdfService.generatePaymentSlipPdf(
        studentName: _studentRecord!.name,
        startDate: _studentRecord!.startDate,
        endDate: _studentRecord!.endDate,
        fee: _studentRecord!.fee,
        feeWord: _studentRecord!.feeWord,
        //feeWord: _studentRecord!.feeWord,
        payment_mode: _studentRecord!.payment_mode,
      );

      logDebug('Payment Slip PDF generated successfully for student: ${_studentRecord!.name}'); // Log successful PDF generation

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          logDebug('Preparing to print Payment Slip PDF for student: ${_studentRecord!.name}'); // Log before printing
          return pdfBytes;
        },
      );

      logDebug('Print job sent successfully for student: ${_studentRecord!.name}'); // Log successful print job
    } catch (e) {
      logDebug('Error occurred during Payment Slip PDF generation or printing: $e'); // Log any errors
    }
  }

  void _fetchStudentDetails(int studentId) async {
    try {
      final url = '${AppUrl.recordApi}';
      final requestBody = {'user_id': studentId.toString()};

      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> data = responseData['data'];
          if (data.isNotEmpty) {
            final filteredData = data.where((json) => json['student_id'] == studentId.toString()).toList();
            if (filteredData.isNotEmpty) {
              StudentRecord studentRecord = StudentRecord.fromJson(filteredData[0]);
              logDebug('Filtered Student Name: ${studentRecord.name}');
              logDebug('Filtered Student ID: ${studentRecord.studentId}');
              logDebug('Filtered Student Fee: ${studentRecord.fee}');
              logDebug('Filtered Student FeeWord: ${studentRecord.feeWord}');
              logDebug('Filtered Student Start Date: ${studentRecord.startDate}');
              logDebug('Filtered Student End Date: ${studentRecord.endDate}');
              logDebug('Filtered Student Serial No: ${studentRecord.serialNo}');
              logDebug('Filtered Student Contact: ${studentRecord.contact}');
              logDebug('Filtered Student Aadhar No: ${studentRecord.aadharNo}');
              logDebug('Filtered Student Address: ${studentRecord.address}');
              logDebug('Filtered Student Address: ${studentRecord.payment_mode}');

              setState(() {
                _studentRecord = studentRecord; // Update the state with the student record
              });
            } else {
              logDebug('No record found for student ID: $studentId');
            }
          } else {
            logDebug('No data found for student ID: $studentId');
          }
        } else {
          logDebug('Error in fetchStudentDetails: ${responseData['message']}');
        }
      } else {
        logDebug('Failed to fetch student details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logDebug('Exception occurred while fetching student details: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/icons/success-icon.png", height: 84.h, width: 84.w),
                SizedBox(height: 20.h),
                Text(
                  'Student Details Submitted\nSuccessfully',
                  style: LexendtextFont500.copyWith(fontSize: 20.sp, color: AppColor.textcolorBlack),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _printPdf,
                      child: Container(
                        width: 160.w,
                        height: 60.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: AppColor.textcolorBlack,
                        ),
                        child: Center(
                          child: Text('Print Form', style: LexendtextFont700.copyWith(fontSize: 16.sp, color: AppColor.whiteColor)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _generatePaymentSlipPdf,
                      child: Container(
                        width: 160.w,
                        height: 60.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: AppColor.textcolor_gold,
                        ),
                        child: Center(
                          child: Text('Payment Slip', style: LexendtextFont700.copyWith(fontSize: 16.sp, color: AppColor.whiteColor)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: AppColor.btncolor,
                    ),
                    child: Center(
                      child: Text('Go To Dashboard', style: LexendtextFont700.copyWith(fontSize: 16.sp, color: AppColor.whiteColor)),
                    ),
                  ),
                ),

                // // Display request body data in a column format
                // if (widget.requestBody != null)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: widget.requestBody!.entries.map((entry) {
                //       return Text(
                //         '${entry.key}: ${entry.value}',
                //         style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack),
                //       );
                //     }).toList(),
                //   ),
                //
                // Column(
                //   children: [
                //     Text('Name: ${widget.requestBody?['name'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Serial No: ${widget.requestBody?['serial_no'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Contact: ${widget.requestBody?['contact'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Aadhar No: ${widget.requestBody?['aadhar_no'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Address: ${widget.requestBody?['address'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Start Date: ${widget.requestBody?['start_date'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('End Date: ${widget.requestBody?['end_date'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Fee: ${widget.requestBody?['fee'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Fee: ${widget.requestBody?['fees_in_word'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('User ID: ${widget.requestBody?['user_id'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Seat No: ${widget.requestBody?['seat_no'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Payment Mode: ${widget.requestBody?['payment_mode'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //     Text('Employee Code: ${widget.requestBody?['Empcode'] ?? 'N/A'}', style: LexendtextFont500.copyWith(fontSize: 16.sp, color: AppColor.textcolorBlack)),
                //
                //     Image(
                //       image: FileImage(
                //         File(widget.images?['profileImage'] ?? 'assets/default_image.png'), // Fallback to default if null
                //       ),
                //       width: 100, // Set your desired width
                //       height: 100, // Set your desired height
                //     ),
                //
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image(
                //           image: FileImage(
                //             File(widget.images?['aadharFrontImage'] ?? 'assets/default_image.png'), // Fallback to default if null
                //           ),
                //           width: 100,
                //           height: 100,
                //         ),
                //         Image(
                //           image: FileImage(
                //             File(widget.images?['aadharBackImage'] ?? 'assets/default_image.png'), // Fallback to default if null
                //           ),
                //           width: 100,
                //           height: 100,
                //         ),
                //       ],
                //     ),
                //
                //
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


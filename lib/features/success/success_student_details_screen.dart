import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/text_style.dart';
import '../../../../res/routes/app_routes.dart';
import '../../utils/logger.dart';
import '../payment/data/payment_slip_pdf_service.dart';

class SuccessStudentDetailsScreen extends StatelessWidget {
  final int studentId;
  final String studentName;
  final String startDate;
  final String endDate;
  final String fees;
  final String feeWord;
  final String payment_mode;


  const SuccessStudentDetailsScreen({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.startDate,
    required this.endDate,
    required this.fees,
    required this.feeWord,
    required this.payment_mode,
  });

  @override
  Widget build(BuildContext context) {
    logDebug('Building SuccessStudentDetailsScreen');
    logDebug('$studentId');
    logDebug('$studentName');
    logDebug('$startDate');
    logDebug('$endDate');
    logDebug('$fees');
    logDebug('$feeWord');
    logDebug('$payment_mode');

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/icons/success-icon.png",
                height: 84.h,
                width: 84.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Subscription updated \nsuccessfully',
                style: LexendtextFont500.copyWith(
                  fontSize: 20.sp,
                  color: AppColor.textcolorBlack,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () async {
                  print('Generating PDF...');

                  // Generate PDF
                  final pdfService = PaymentSlipPdfService();
                  final pdfData = await pdfService.generatePaymentSlipPdf(
                    studentName: studentName,
                    startDate: startDate,
                    endDate: endDate,
                    fee: fees,
                    feeWord: feeWord,
                    payment_mode: payment_mode,
                  );

                  // Print statements for debugging
                  print('PDF generated. Showing preview...');

                  // Display PDF preview
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdfData,
                  );

                  // Print statements for debugging
                  print('PDF preview closed.');

                  // // Navigate back to previous pages
                  //  Navigator.pop(context);
                  //  Navigator.pop(context);

                  // Ensure navigation happens after UI updates
                  // Future.microtask(() {
                  //   print('Navigating to studentsdetails page...');
                  //
                  //   logDebug('Navigating to student details for $studentId');
                  //   Navigator.pushNamed(
                  //     context,
                  //     AppRoutes.studentsdetails,
                  //     arguments: studentId, // Pass necessary arguments if needed
                  //   );
                  //
                  //   // Print statement for debugging
                  //   print('Navigating to studentsdetails redirecting...');
                  // });

                //  Clear the navigation stack and go back to the StudentRecordDetailsPage
                //   Navigator.popUntil(context,
                //       ModalRoute.withName(AppRoutes.studentRecordScreen));
                //   logDebug('Navigating to student details for $studentId');
                //   Navigator.pushNamed(
                //     context,
                //     AppRoutes.studentsdetails,
                //     arguments: studentId, // Pass necessary arguments if needed
                //   );


                  // Ensure navigation happens after UI updates
                  Future.microtask(() {
                    // Clear the navigation stack and navigate to StudentRecordScreen
                    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.studentRecordScreen));

                    logDebug('Navigating to student details for $studentId');
                    Navigator.pushNamed(
                      context,
                      AppRoutes.studentsdetails,
                      arguments: studentId, // Pass necessary arguments if needed
                    );

                    // Print statement for debugging
                    print('Navigating to studentsdetails redirecting...');
                  });

                },
                child: Container(
                  width: double.infinity,
                  height: 60.h,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(),
                    color: Colors.transparent,
                  ),
                  child: DecoratedBox(
                    child: Center(
                      child: Text('Print Payment Slip',
                          style: LexendtextFont700.copyWith(
                            fontSize: 16.sp,
                            color: AppColor.whiteColor,
                          )),
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColor.textcolor_gold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  // Redirect to Home page
                  // Navigator.pushNamed(context, AppRoutes.home);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  // Navigator.pushNamed(
                  //   context,
                  //   AppRoutes.studentsdetails,
                  //   arguments: record.id, // Pass the student ID as an argument
                  // );
                  // Future.microtask(() {
                  //   Navigator.pop(context); // Close the current dialog or page
                  //   Navigator.pop(context); // Navigate back to the previous page
                  // });
                },
                child: Container(
                  width: double.infinity,
                  height: 60.h,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(),
                    color: Colors.transparent,
                  ),
                  child: DecoratedBox(
                    child: Center(
                      child: Text('Go To Dashbord',
                          style: LexendtextFont700.copyWith(
                            fontSize: 16.sp,
                            color: AppColor.whiteColor,
                          )),
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColor.btncolor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

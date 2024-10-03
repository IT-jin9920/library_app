import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:library_app/utils/logger.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';
import '../../../../res/routes/app_routes.dart';
import '../../../registration/presentation/widgets/registration_form.dart';
import 'ViewModel/subscription_view_model.dart';

class CustomSubscriptionDialog extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController feesController;
  final TextEditingController feesInWordsController;

  final int studentId;
  final String studentName;

  final FocusNode startDateFocusNode = FocusNode();
  final FocusNode endDateFocusNode = FocusNode();
  final FocusNode feesFocusNode = FocusNode();
  final FocusNode feesInWordsFocusNode = FocusNode();

  CustomSubscriptionDialog({
    required this.startDateController,
    required this.endDateController,
    required this.feesController,
    required this.studentId,
    required this.studentName,
    required this.feesInWordsController,
  });

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _paymentMode = 'Cash';

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final viewModel = Provider.of<SubscriptionViewModel>(context);

        return Dialog(
          backgroundColor: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'New Subscription',
                    style: montserratfont600.copyWith(
                      fontSize: 15.sp,
                      color: AppColor.textcolor_blue,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  // Row for date fields
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, startDateController),
                          child: AbsorbPointer(
                            child: RegistrationTextFormField(
                              controller: startDateController,
                              hintText: 'Start Date',
                              focusNode: startDateFocusNode,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the start date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, endDateController),
                          child: AbsorbPointer(
                            child: RegistrationTextFormField(
                              controller: endDateController,
                              hintText: 'End Date',
                              focusNode: endDateFocusNode,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the end date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Numeric input field
                  RegistrationTextFormField(
                    controller: feesController,
                    hintText: 'Fees',
                    focusNode: feesFocusNode,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the fees';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  RegistrationTextFormField(
                    controller: feesInWordsController,
                    hintText: 'Fees Amount in Words',
                    focusNode: feesInWordsFocusNode,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter the fees amount in words.'
                        : null,
                    maxLength: 80,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Payment Mode:',
                    style: LexendtextFont500.copyWith(
                      fontSize: 14.sp,
                      color: AppColor.textcolorBlack,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'Cash',
                        groupValue: _paymentMode,
                        onChanged: (value) => setState(() => _paymentMode = value!),
                      ),
                      Text('Cash'),
                      Radio<String>(
                        value: 'Online',
                        groupValue: _paymentMode,
                        onChanged: (value) => setState(() => _paymentMode = value!),
                      ),
                      Text('Online'),
                    ],
                  ),
                  // Submit button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate form fields
                          if (_formKey.currentState!.validate()) {
                            // Get input data
                            final startDate = startDateController.text;
                            final endDate = endDateController.text;
                            final fees = feesController.text;
                            final feesInWords = feesInWordsController.text; // Get fees in words

                            // Print the input data for debugging
                            logDebug('Form Validated');
                            logDebug('Student ID: $studentId');
                            logDebug('Student Name: $studentName');
                            logDebug('Start Date: $startDate');
                            logDebug('End Date: $endDate');
                            logDebug('Fees: $fees');
                            logDebug('Fees in Words: $feesInWords');
                            logDebug('Payment Mode: $_paymentMode');

                            try {
                              // Call the ViewModel to submit the subscription
                              await viewModel.submitSubscription(
                                studentId: studentId,
                                startDate: startDate,
                                endDate: endDate,
                                fee: fees,
                                feesInWords: feesInWords, // Pass fees in words
                                payment_mode: _paymentMode,
                              );

                              // Handle response
                              if (viewModel.response != null) {
                                logDebug('Response Status: ${viewModel.response!.status}');
                                if (viewModel.response!.status == 'success') {
                                  logDebug('Subscription submitted successfully.');

                                  // Clear the form fields
                                  startDateController.clear();
                                  endDateController.clear();
                                  feesController.clear();
                                  feesInWordsController.clear(); // Clear fees in words

                                  // Navigate to the next page with the necessary data
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.studentDetailsSuccess,
                                    arguments: {
                                      'studentId': studentId,
                                      'studentName': studentName,
                                      'startDate': startDate,
                                      'endDate': endDate,
                                      'fees': fees,
                                      'fees_in_word': feesInWords, // Pass fees in words
                                      'payment_mode': _paymentMode,
                                    },
                                  );
                                } else {
                                  logDebug('Subscription submission failed. Error: ${viewModel.error}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.error ?? 'Failed to submit subscription. Please try again.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } else {
                                logDebug('No response from ViewModel.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No response from the server. Please try again.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              logDebug('Exception caught: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('An error occurred. Please try again.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            logDebug('Form validation failed.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.btncolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          'Submit',
                          style: LexendtextFont700.copyWith(
                            color: AppColor.whiteColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.btncolor,
              onPrimary: AppColor.whiteColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.whiteColor,
                backgroundColor: AppColor.btncolor,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(selectedDate);

      controller.text = formattedDate;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected date: $formattedDate'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No date selected'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';
import '../../../../res/routes/app_routes.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/shared_preferences_helper.dart';
import '../../../registration/presentation/widgets/registration_form.dart';
import '../../../registration/presentation/widgets/submit_button.dart';
import '../../data/PrintStudentRecordRepository.dart';
import '../../data/payment_slip_pdf_service.dart';
import '../widgets/custom_dropdown_student.dart';
import '../widgets/custom_dropdown_subscription.dart';

class PrintPaymentScreen extends StatefulWidget {
  const PrintPaymentScreen({super.key});

  @override
  State<PrintPaymentScreen> createState() => _PrintPaymentScreenState();
}

class _PrintPaymentScreenState extends State<PrintPaymentScreen> {
  final PrintStudentRecordRepository _repository =
      PrintStudentRecordRepository();

  List<String> _studentNames = [];
  Map<String, String> _studentMap = {};
  String? _selectedStudentId;
  List<Map<String, String>> _studentsubscription = [];
  String? _selectedStudent;
  String? _selectedSubscription;

  String _paymentMode = 'Cash';

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchSubscriptionController =
      TextEditingController();
  List<String> _filteredStudentNames = [];
  List<Map<String, String>> _filteredSubscriptions = [];

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _feesWordController = TextEditingController();
  final FocusNode _startDateFocusNode = FocusNode();
  final FocusNode _endDateFocusNode = FocusNode();
  final FocusNode _feesFocusNode = FocusNode();
  final FocusNode _feesWordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchStudentRecords();
    _filteredStudentNames = List.from(_studentNames);

    _searchController.addListener(() {
      setState(() {
        _filteredStudentNames = _studentNames
            .where((name) => name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });

    _searchSubscriptionController.addListener(() {
      setState(() {
        _filteredSubscriptions = _studentsubscription
            .where((subscription) =>
                subscription['subscriptionPeriod']?.toLowerCase().contains(
                    _searchSubscriptionController.text.toLowerCase()) ??
                false)
            .toList();
      });
    });
  }

  Future<void> _fetchStudentRecords() async {
    try {
      final userIdString = await SharedPreferencesHelper.getUserId();
      final userId = userIdString != null ? int.tryParse(userIdString) : null;

      if (userId != null) {
        print('Fetching student records for User ID: $userId');
        final records = await _repository.fetchStudentRecord(userId);
        print('Fetched student records: $records');

        setState(() {
          _studentMap = {
            for (var record in records) record.name: record.studentId
          };
          _studentNames = _studentMap.keys.toList();
          _filteredStudentNames = _studentNames;
        });
      } else {
        print('User ID is null or invalid');
      }
    } catch (e) {
      print('Error fetching student records: $e');
    }
  }

  Future<void> _fetchSubscriptions() async {
    // Ensure we have a selected student ID
    if (_selectedStudentId != null) {
      // Attempt to parse the selected student ID to an integer
      final selectedStudentId = int.tryParse(_selectedStudentId!);

      if (selectedStudentId != null) {
        // Log the start of the fetch process
        logDebug(
            'Fetching subscription details for Student ID: $selectedStudentId');

        try {
          // Fetch subscription details from the repository
          final records =
              await _repository.fetchSubscriptionDetails(selectedStudentId);

          // Log the fetched records
          logDebug('Fetched subscription records: \n$records');

          if (records.isNotEmpty) {
            // Process and log the records if not empty
            final processedRecords = records.map((record) {
              return {
                'start_date': record.startDate ?? 'N/A',
                'end_date': record.endDate ?? 'N/A',
                'fee': record.fee ?? 'N/A',
                'fees_in_word': record.feeWord ?? 'N/A',
                'payment_mode': record.payment_mode ?? 'N/A',
                'created_at': record.createdAt ?? 'N/A',
              };
            }).toList();

            // Update state and log the processed records
            setState(() {
              _studentsubscription = processedRecords;
              _filteredSubscriptions = _studentsubscription;
            });
            logDebug('Processed subscription records: $_studentsubscription');
          } else {
            // Log when no records are found
            logDebug(
                'No subscription records found for Student ID: $selectedStudentId');
            setState(() {
              _studentsubscription = [];
              _filteredSubscriptions = [];
            });
          }
        } catch (e) {
          // Log any exceptions encountered during the fetch process
          logDebug('Error fetching subscription details: $e');
          setState(() {
            _studentsubscription = [];
            _filteredSubscriptions = [];
          });
        }
      } else {
        // Log when the selected student ID is invalid
        logDebug(
            'Selected Student ID ($selectedStudentId) is not a valid integer.');
      }
    } else {
      // Log when no student ID is selected
      logDebug('Selected Student ID is null.');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchSubscriptionController.dispose();
    super.dispose();
  }

  void _openBottomSheetStudent() {
    // Reset the filtered student names to all names when the bottom sheet opens
    _filteredStudentNames = List.from(_studentNames);
    _searchController.clear(); // Clear the search field

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        print('Search Value: $value'); // Debugging print
                        setState(() {
                          if (value.isEmpty) {
                            _filteredStudentNames = List.from(_studentNames);
                          } else {
                            _filteredStudentNames = _studentNames
                                .where((studentName) =>
                                studentName.toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          }
                          print('Filtered Names: $_filteredStudentNames'); // Debugging print
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search, color: AppColor.textcolorSilver),
                        ),
                        hintText: 'Search student...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredStudentNames.length,
                      itemBuilder: (context, index) {
                        final studentName = _filteredStudentNames[index];
                        return ListTile(
                          title: Text(studentName),
                          onTap: () {
                            setState(() {
                              _selectedStudent = studentName;
                              print('Selected Student: $_selectedStudent');
                            });

                            Navigator.pop(context); // Close the bottom sheet
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openBottomSheetSubscription() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  "Select Subscription",
                  style: LexendtextFont500.copyWith(
                    color: AppColor.textcolor_blue,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: _filteredSubscriptions.isNotEmpty
                    ? ListView(
                  padding: EdgeInsets.zero,
                  children: _filteredSubscriptions.map((subscription) {
                    return ListTile(
                      title: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColor.bglightgray,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        width: double.infinity,
                        height: 70.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      subscription['start_date'] ?? '',
                                      style: LexendtextFont500.copyWith(
                                        color: AppColor.textcolorBlack,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      'TO',
                                      style: LexendtextFont500.copyWith(
                                        color: AppColor.textcolorBlack,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      subscription['end_date'] ?? '',
                                      style: LexendtextFont500.copyWith(
                                        color: AppColor.textcolorBlack,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Upgraded At ${subscription['created_at']}',
                                  style: mulishRegularFont300.copyWith(
                                    color: AppColor.textcolor_gray,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${subscription['fee']}',
                              style: LexendtextFont500.copyWith(
                                color: AppColor.textcolorBlack,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedSubscription =
                          '${subscription['start_date']} TO ${subscription['end_date']}';

                          // Update the date and fee fields
                          _startDateController.text =
                              subscription['start_date'] ?? '';
                          _endDateController.text =
                              subscription['end_date'] ?? '';
                          _feesController.text =
                              subscription['fee'] ?? '';
                          _feesWordController.text =
                              subscription['fees_in_word'] ?? '';
                          _paymentMode =
                              subscription['payment_mode'] ?? 'Cash';

                          // Optionally log or perform other actions here
                          print('Selected Subscription tap : $_selectedSubscription');
                          print('Start Date: ${_startDateController.text}');
                          print('End Date: ${_endDateController.text}');
                          print('Fees: ${_feesController.text}');
                          print('Fees Word: ${_feesWordController.text}');
                          print('Payment Mode: $_paymentMode');
                        });

                        Navigator.pop(context); // Close the bottom sheet
                      },
                    );
                  }).toList(),
                )
                    : Center(child: Text('No subscriptions found')),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
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
      setState(() {
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formattedDate = formatter.format(selectedDate);
        controller.text = formattedDate;
      });
    }
  }

  void _generateAndPrintPdf() async {
    // Validate input fields
    if (_selectedStudent == null || _selectedStudent!.isEmpty) {
      _showErrorSnackbar('Please select a student.');
      return;
    }
    if (_startDateController.text.isEmpty) {
      _showErrorSnackbar('Start date cannot be empty.');
      return;
    }
    if (_endDateController.text.isEmpty) {
      _showErrorSnackbar('End date cannot be empty.');
      return;
    }
    if (_feesController.text.isEmpty) {
      _showErrorSnackbar('Fees cannot be empty.');
      return;
    }

    // Proceed with PDF generation
    final pdfService = PaymentSlipPdfService();
    final pdfData = await pdfService.generatePaymentSlipPdf(
      studentName: _selectedStudent!,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      fee: _feesController.text,
      feeWord: _feesWordController.text,
      payment_mode:_paymentMode,

    );

    // Display the PDF to the user for preview and printing
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

// Method to show error Snackbar using ScaffoldMessenger
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white), // Customize text color here
        ),
        backgroundColor: Colors.red, // Customize background color here
        duration: Duration(seconds: 3), // Duration of the Snackbar
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.02),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColor.whiteColor,
            title: Text(
              'Print Payment Slip',
              style: LexendtextFont500.copyWith(
                fontSize: 16.sp,
                color: AppColor.textcolorBlack,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Text(
                      "Go Back",
                      style: LexendtextFont500.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.btncolor,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColor.btncolor,
                      size: 17.sp,
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomDropdownStuden(
                value: _selectedStudent,
                hint: 'Select Student',
                onTap: _openBottomSheetStudent,
              ),
              SizedBox(height: 20.h),
              CustomDropdownSubscription(
                value: _selectedSubscription,
                hint: 'Select Subscription',
                onTap: _openBottomSheetSubscription,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(_startDateController),
                      child: AbsorbPointer(
                        child: RegistrationTextFormField(
                          controller: _startDateController,
                          hintText: 'Start Date',
                          focusNode: _startDateFocusNode,
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
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(_endDateController),
                      child: AbsorbPointer(
                        child: RegistrationTextFormField(
                          controller: _endDateController,
                          hintText: 'End Date',
                          focusNode: _endDateFocusNode,
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
              RegistrationTextFormField(
                controller: _feesController,
                hintText: 'Fees',
                focusNode: _feesFocusNode,
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
                controller: _feesWordController,
                hintText: 'Fees Amount in Words',
                focusNode: _feesWordFocus,
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
                mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(height: 20.h),
              Container(
                height: 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  color: AppColor.btncolor,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: () {
                    // Print all the information to the console
                    print('--- Payment Slip Information ---');
                    print('Selected Student: $_selectedStudent');
                    print('Selected Student ID: $_selectedStudentId');
                    print('Selected Subscription: $_selectedSubscription');
                    print('Start Date: ${_startDateController.text}');
                    print('End Date: ${_endDateController.text}');
                    print('Fees: ${_feesController.text}');
                    print('Fees Word : ${_feesWordController.text}');
                    print('Paymnt mode  : $_paymentMode');
                    print('----------------------------------');
                   // Navigator.pushNamed(context, AppRoutes.home);
          
                    // Generate and print the PDF
                    _generateAndPrintPdf();
          
                  },
                  child: Center(
                    child: Text(
                      'Print Payment Slip',
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
  }
}

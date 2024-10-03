import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/fonts/text_style.dart';
import '../../../res/routes/app_routes.dart';
import '../../../utils/logger.dart';
import '../student_record_edit/data/student_service.dart';
import 'Widgets/CustomSubscriptionDialog.dart';
import 'student_details_view_model/student_details_view_model.dart';

class StudentDetailsPage extends StatefulWidget {
  final int studentId;

  StudentDetailsPage({required this.studentId});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentDetails();
      _fetchSubscriptionDetails();
    });
  }

  Future<void> _fetchStudentDetails() async {
    final viewModel = Provider.of<StudentDetailsViewModel>(context, listen: false);

    logDebug('Fetching details for student ID: ${widget.studentId}');
    try {
      await viewModel.fetchStudentDetails(widget.studentId);
      logDebug('Student details fetched successfully for ID: ${widget.studentId}');
    } catch (e) {
      logDebug('Error fetching student details for ID: ${widget.studentId}, Error: $e');
    }
  }

  Future<void> _fetchSubscriptionDetails() async {
    final viewModel = Provider.of<StudentDetailsViewModel>(context, listen: false);
    try {
      await viewModel.fetchSubscriptionDetails(widget.studentId);
      logDebug('Subscription details fetched successfully for ID: ${widget.studentId}');
    } catch (e) {
      logDebug('Error fetching subscription details for ID: ${widget.studentId}, Error: $e');
    }
  }

  Future<void> _handleDelete() async {
    final shouldDelete = await _showDeleteConfirmationDialog();
    if (shouldDelete == true) {
      try {
        final studentService = StudentService();
        await studentService.deleteStudent(widget.studentId);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student deleted successfully')),
        );

        // Navigate back and indicate that the data has changed
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.studentRecordScreen);
      } catch (e) {
        logDebug('Error deleting student: $e');
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting student: $e')),
        );
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog() async {
    if (!mounted) return false;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this student?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    width: 100.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColor.btncolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: LexendtextFont300.copyWith(
                          color: AppColor.whiteColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Container(
                    width: 100.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColor.btncolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Delete',
                        style: LexendtextFont300.copyWith(
                          color: AppColor.whiteColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showCustomDialog(BuildContext context, int studentId, String studentName) {
    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _endDateController = TextEditingController();
    final TextEditingController _feesController = TextEditingController();
    final TextEditingController _feesInWordsController = TextEditingController(); // Initialize the fees in words controller

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomSubscriptionDialog(
          startDateController: _startDateController,
          endDateController: _endDateController,
          feesController: _feesController,
          studentId: studentId,
          studentName: studentName,
          feesInWordsController: _feesInWordsController, // Pass the initialized controller
        );
      },
    );
  }


  Widget _buildDetailRow(String label, String value, {bool isMultiline = false}) {
    return Row(
      children: [
        Text(
          label,
          style: LexendtextFont500.copyWith(
            color: AppColor.textcolor_gray,
            fontSize: 12.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: LexendtextFont400.copyWith(
              color: AppColor.textcolor_gray,
              fontSize: 12.sp,
            ),
            maxLines: isMultiline ? null : 1,
            overflow: isMultiline ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
      ],
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
              'Student Details',
              style: LexendtextFont500.copyWith(
                fontSize: 16.sp,
                color: AppColor.textcolorBlack,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  try {
                    print('Go Back button tapped');
                    // Ensure the navigation stack is intact
                     Navigator.pop(context);
                    // Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.studentRecordScreen,
                    // );
                    // Navigator.pushReplacementNamed(
                    //   context,
                    //   AppRoutes.studentRecordScreen,
                    // );
                    // Additional checks if needed
                  } catch (e) {
                    print('Navigation error: $e');
                  }
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
      body: Consumer<StudentDetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.btncolor,
              ),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          }

          final student = viewModel.student;
          final subscriptions = viewModel.subscriptions;

          if (student == null) {
            return Center(child: Text('No student data available'));
          }

          // Retrieve studentName from the viewModel
          final studentName = student.name;

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Info Container
                Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.05),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: LexendtextFont500.copyWith(
                                color: AppColor.textcolor_blue,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              "Register At ${student.date}",
                              style: mulishRegularFont300.copyWith(
                                color: AppColor.textcolor_gray,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: _handleDelete,
                              child: Image.asset(
                                "assets/icons/dlt-icon.png",
                                height: 25.h,
                                width: 25.w,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.studentDetailsEdit,
                                  arguments: widget.studentId,
                                );
                                logDebug('Navigating to student details to edit ${widget.studentId}');
                              },
                              child: Image.asset(
                                "assets/icons/edit-icon.png",
                                height: 25.h,
                                width: 25.w,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Student Details Container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.05),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        _buildDetailRow("Student Name : ", student.name),
                        SizedBox(height: 10.h),
                        _buildDetailRow("Serial Number : ", student.serialNo),
                        SizedBox(height: 10.h),
                        _buildDetailRow("Contact Details: ", student.contact),
                        SizedBox(height: 10.h),
                        _buildDetailRow("Aadhar number : ", student.aadharNo),
                        SizedBox(height: 10.h),
                        _buildDetailRow("Address : ", student.address, isMultiline: true),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Subscription Records Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Records",
                    style: LexendtextFont500.copyWith(
                      color: AppColor.textcolor_blue,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                subscriptions.isEmpty
                    ? Center(child: Text('No subscription records available'))
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SizedBox(
                    height: 300.h, // Adjust height as needed
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: subscriptions.length,
                      itemBuilder: (context, index) {
                        final subscription = subscriptions[index];
                        return InkWell(
                          onTap: () {
                            logDebug('Subscription tapped: ${subscription.startDate} To ${subscription.endDate}');
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.r),
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
                                    Text(
                                      '${subscription.startDate} To ${subscription.endDate}',
                                      style: LexendtextFont500.copyWith(
                                        color: AppColor.textcolorBlack,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      "Upgraded At ${subscription.createdAt}",
                                      style: mulishRegularFont300.copyWith(
                                        color: AppColor.textcolor_gray,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "₹${subscription.fee}",
                                  style: LexendtextFont500.copyWith(
                                    color: AppColor.textcolorBlack,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Consumer<StudentDetailsViewModel>(
        builder: (context, viewModel, child) {
          final student = viewModel.student;
          if (student == null) {
            return SizedBox.shrink();
          }

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                _showCustomDialog(context, widget.studentId, student.name); // Pass studentName here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.btncolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: Text(
                'Add New Subscription',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

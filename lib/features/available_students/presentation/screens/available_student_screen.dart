import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';
import '../../domain/student_view_model.dart';

class AvailableStudentScreen extends StatefulWidget {
  const AvailableStudentScreen({super.key});

  @override
  State<AvailableStudentScreen> createState() => _AvailableStudentScreenState();
}

class _AvailableStudentScreenState extends State<AvailableStudentScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   // Initialize ViewModel
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<StudentViewModel>(context, listen: false).fetchAvailableStudents(1);
  //   });
  //
  //
  // }

  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        print('SharedPreferences instance obtained.');

        final userIdString = prefs.getString('user_id');
        print('Retrieved user ID as String: $userIdString');

        final userId = userIdString != null ? int.tryParse(userIdString) : 0;
        print('Parsed user ID: $userId');

        if (userId != null && userId != 0) {
          print('Valid user ID found. Loading notifications...');
          // final notificationViewModel = Provider.of<NotificationViewModel>(context, listen: false);
          // await notificationViewModel.loadNotifications(userId);

          final viewModel = Provider.of<StudentViewModel>(context, listen: false);
          await viewModel.fetchAvailableStudents(userId);

        } else {
          print('User ID not found in SharedPreferences or invalid.');
        }
      } catch (e) {
        print('Error loading data: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StudentViewModel>(context);

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
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Available Students',
                  style: LexendtextFont500.copyWith(
                    fontSize: 16.sp,
                    color: AppColor.textcolorBlack,
                  ),
                ),
                SizedBox(width: 20.w),
                CircleAvatar(
                  backgroundColor: AppColor.btncolor,
                  radius: 15.r,
                  child: Center(
                    child: Text(
                      "${viewModel.studentCount}",
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ],
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            if (viewModel.isLoading)
              Center(child: CircularProgressIndicator(
                color: AppColor.btncolor,
              ))
            else if (viewModel.errorMessage.isNotEmpty)
              Center(child: Text(viewModel.errorMessage))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.students.length,
                  itemBuilder: (context, index) {
                    final student = viewModel.students[index];
                    return InkWell(
                      onTap: () {
                        // Redirect to studentsdetails page
                      },
                      child: Container(
                        // padding: EdgeInsets.all(16.w),
                        //  margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          color: AppColor.bglightgray,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        width: double.infinity,
                        height: 70.h,
                        child: Row(
                          children: [
                            SizedBox(width: 30.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: LexendtextFont500.copyWith(
                                    color: AppColor.textcolorBlack,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "In Time:",
                                      style: PoppinstextFont400.copyWith(
                                        color: AppColor.textcolorBlack,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    SizedBox(width: 2.w,),
                                    Text(
                                      "${student.lastSignInTime}",
                                      style: PoppinstextFont400.copyWith(
                                        color: AppColor.textcolor_gray,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
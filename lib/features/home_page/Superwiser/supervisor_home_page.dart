import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../res/colors/app_color.dart';
import '../../../../../res/fonts/text_style.dart';
import '../../../res/routes/app_routes.dart';
import '../../../utils/logger.dart';
import '../../../utils/custom_navigator_observer.dart';
import '../../available_students/domain/student_view_model.dart';
import '../../login/view_models/login_usecase.dart';
import 'ViewModel/superwiser_student_dashboard_viewmodel.dart';

class SupervisorHomePage extends StatefulWidget {
  @override
  _SupervisorHomePageState createState() => _SupervisorHomePageState();
}

class _SupervisorHomePageState extends State<SupervisorHomePage> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userIdString = prefs.getString('user_id');
      final userId = int.tryParse(userIdString ?? '') ?? 0;

      if (userId > 0) {
        final dashboardViewModel = Provider.of<SupervisorStudentDashboardViewModel>(context, listen: false);
        await dashboardViewModel.loadDashboardData(userId);

        final studentViewModel = Provider.of<StudentViewModel>(context, listen: false);
        await studentViewModel.fetchAvailableStudents(userId);
      } else {
        logDebug('User ID not found in SharedPreferences or invalid.');
      }
    } catch (e) {
      logDebug('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    final dashboardViewModel = Provider.of<SupervisorStudentDashboardViewModel>(context);
    final studentViewModel = Provider.of<StudentViewModel>(context);

    if (dashboardViewModel.isLoading || studentViewModel.isLoading) {
      return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          title: Image.asset(
            "assets/images/login-img.png",
            height: 40.h,
            width: 109.w,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(child: CircularProgressIndicator(color: AppColor.btncolor)),
      );
    }

    if (dashboardViewModel.error.isNotEmpty || studentViewModel.errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          title: Image.asset(
            "assets/images/login-img.png",
            height: 40.h,
            width: 109.w,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(child: Text('Error loading data. Please try again later.')),
      );
    }

    Future<void> _logout(BuildContext context) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('user_type');
        logDebug('User session cleared.');

        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } catch (e) {
        logDebug('Logout error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }

    return WillPopScope(
      onWillPop: () async {
       // final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

        final shouldLogout = await showLogoutConfirmationDialog(context);

        if (shouldLogout == true) {
          await _logout(context);
         // await loginViewModel.logout(context);
          return false; // Prevent back navigation since logout should handle it
        }
        return false; // Prevent back navigation if user cancels
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: AppColor.whiteColor,
              title: Image.asset(
                "assets/images/login-img.png",
                height: 40.h,
                width: 109.w,
              ),
              actions: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.availableStudents);
                      },
                      child: Text(
                        "View Available Students",
                        style: LexendtextFont500.copyWith(
                          fontSize: 16.sp,
                          color: AppColor.textcolor_gold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColor.textcolor_gold,
                    ),
                  ],
                ),
              ],
              automaticallyImplyLeading: false,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Dashboard",
                style: LexendtextFont500.copyWith(
                  fontSize: 14.sp,
                  color: AppColor.textcolorSilver,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  _buildDashboardCard(
                    title: 'Available',
                    value: dashboardViewModel.availableCount,
                    borderColor: AppColor.btncolor,
                    textColor: AppColor.btncolor,
                  ),
                  SizedBox(width: 10.w),
                  _buildDashboardCard(
                    title: 'Left Library',
                    value: dashboardViewModel.leftLibraryCount,
                    borderColor: AppColor.textcolor_gold,
                    textColor: AppColor.textcolor_gold,
                  ),
                  SizedBox(width: 10.w),
                  _buildDashboardCard(
                    title: 'Present Today',
                    value: dashboardViewModel.presentTodayCount,
                    borderColor: AppColor.green,
                    textColor: AppColor.green,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                "Available Students",
                style: LexendtextFont500.copyWith(
                  fontSize: 14.sp,
                  color: AppColor.textcolorSilver,
                ),
              ),
            //  SizedBox(height: 20.h),
              Expanded(
                child: studentViewModel.students.isEmpty
                    ? Center(child: Text('No available students'))
                    : ListView.builder(
                  itemCount: studentViewModel.students.length,
                  itemBuilder: (context, index) {
                    final student = studentViewModel.students[index];
                    return InkWell(
                      onTap: () {
                        // Redirect to students details page
                        //Navigator.pushNamed(context, AppRoutes.studentsDetails, arguments: student);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
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
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      width: 100.w,
      height: 65.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: LexendtextFont600.copyWith(
              fontSize: 12.sp,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: LexendtextFont700.copyWith(
              fontSize: 20.sp,
              color: AppColor.textcolorBlack,
            ),
          ),
        ],
      ),
    );
  }
}

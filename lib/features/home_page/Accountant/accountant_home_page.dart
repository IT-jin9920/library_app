import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../res/colors/app_color.dart';
import '../../../../../res/fonts/text_style.dart';
import '../../../res/routes/app_routes.dart';
import '../../../utils/custom_navigator_observer.dart';
import '../../../utils/logger.dart'; // Ensure this path is correct
import '../../login/view_models/login_usecase.dart';
import '../../notification/ViewModel/home_notification_viewmodel.dart';

class AccountantHomePage extends StatefulWidget {
  @override
  State<AccountantHomePage> createState() => _AccountantHomePageState();
}

class _AccountantHomePageState extends State<AccountantHomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        logDebug('Initializing AccountantHomePage...');

        final prefs = await SharedPreferences.getInstance();
        logDebug('SharedPreferences instance obtained.');

        final userIdString = prefs.getString('user_id');
        logDebug('Retrieved user ID as String: $userIdString');

        final userId = userIdString != null ? int.tryParse(userIdString) : 0;
        logDebug('Parsed user ID: $userId');

        if (userId != null && userId != 0) {
          logDebug('Valid user ID found. Loading notifications...');

          final notificationViewModel =
              Provider.of<HomeNotificationViewModel>(context, listen: false);
          logDebug('Loading notifications...');
          await notificationViewModel.loadNotifications(userId);
          logDebug('Notifications loaded.');
        } else {
          logDebug('User ID not found in SharedPreferences or invalid.');
        }
      } catch (e) {
        logDebug('Error loading data: $e');
      }
    });
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

  @override
  Widget build(BuildContext context) {
    logDebug('Building AccountantHomePage');

    // Initialize ScreenUtil to adapt to different screen sizes
    ScreenUtil.init(context);

    // Get the screen width using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    final notificationViewModel =
        Provider.of<HomeNotificationViewModel>(context);

    // Filter today's notifications
    final today = DateTime.now();
    final todayNotifications =
        notificationViewModel.notifications.where((notification) {
      final notificationDate = DateTime.parse(
          notification.endDate); // Assuming endDate is in ISO 8601 format
      return notificationDate.year == today.year &&
          notificationDate.month == today.month &&
          notificationDate.day == today.day;
    }).toList();

    return WillPopScope(
        onWillPop: () async {
          // final loginViewModel =
          //     Provider.of<LoginViewModel>(context, listen: false);

          final shouldLogout = await showLogoutConfirmationDialog(context);

          if (shouldLogout == true) {
            logDebug('User confirmed logout.');
          //  await loginViewModel.logout(context);
            await _logout(context);
            logDebug('User logged out.');
            return false; // Prevent back navigation since logout should handle it
          }
          logDebug('User canceled logout.');
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
                  InkWell(
                    onTap: () {
                      logDebug('Navigating to Student Registration page...');
                      Navigator.pushNamed(context, AppRoutes.registration);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Student registration",
                          style: LexendtextFont500.copyWith(
                            fontSize: 16.sp,
                            color: AppColor.textcolor_gold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColor.textcolor_gold,
                        ),
                      ],
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {
                      logDebug('Navigating to Student Record Screen...');
                      Navigator.pushNamed(
                          context, AppRoutes.studentRecordScreen);
                    },
                    child: Container(
                      height: 70.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.btncolor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/cap-icon.png",
                              width: 40.w,
                              height: 50.h,
                            ),
                            SizedBox(width: screenWidth * 0.020),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Students Record Portal",
                                    style: LexendtextFont600.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    "You Can Check All Student Details here",
                                    style: LexendtextFont600.copyWith(
                                      fontSize: 10.sp,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.020),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.only(
                      left: 18.w,
                      right: 42.w,
                      top: 20.h,
                      bottom: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.bglightgray,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionItem(context, "Print Payment Slip",
                            AppRoutes.printPaymentScreen),
                        SizedBox(height: 26.h),
                        _buildActionItem(context, "Students Report",
                            AppRoutes.studentReportScreen),
                        SizedBox(height: 26.h),
                        _buildActionItem(
                            context, "Notification", AppRoutes.notification),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Today's Notifications",
                    style: LexendtextFont500.copyWith(
                      fontSize: 14.sp,
                      color: AppColor.textcolorSilver,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  notificationViewModel.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: AppColor.btncolor))
                      : notificationViewModel.notifications.isEmpty
                          ? Center(child: Text('No notifications for today'))
                          :ListView.builder(
                    itemCount: todayNotifications.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final notification = todayNotifications[index];
                      logDebug('Displaying notification: ${notification.studentName}');

                      String expirationText;
                      switch (notification.endingOn) {
                        case 'Today':
                          expirationText = 'Subscription expiring today';
                          break;
                        case 'Soon':
                          expirationText = 'Subscription expiring soon';
                          break;
                        default:
                          expirationText = 'Subscription Ending On: ${notification.endDate}';
                      }

                      return GestureDetector(
                        onTap: () {
                          logDebug('Notification tapped: ${notification.studentName}');
                          Navigator.pushNamed(
                            context,
                            AppRoutes.studentsdetails,
                            arguments: notification.studentId,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.notification_important),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          notification.studentName,
                                          style: LexendtextFont400.copyWith(
                                            color: AppColor.textcolor_red,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          expirationText,
                                          style: LexendtextFont400.copyWith(
                                            color: AppColor.textcolorBlack,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Subscription End :",
                                          style: LexendtextFont400.copyWith(
                                            color: AppColor.textcolorBlack,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          '${notification.endDate}',
                                          style: LexendtextFont400.copyWith(
                                            color: AppColor.textcolor_gray,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildActionItem(BuildContext context, String title, String route) {
    logDebug('Building Action Item: $title');
    return InkWell(
      onTap: () {
        logDebug('Navigating to route: $route');
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        // Adds vertical padding for better click area
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: LexendtextFont600.copyWith(
                fontSize: 14.sp,
                color: AppColor.textcolorBlack,
              ),
            ),
            Image.asset(
              "assets/icons/right-icon.png",
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildActionItem(BuildContext context, String title, String route) {
  logDebug('Building Action Item: $title');
  return InkWell(
    onTap: () {
      logDebug('Navigating to route: $route');
      Navigator.pushNamed(context, route);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      // Adds vertical padding for better click area
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: LexendtextFont600.copyWith(
              fontSize: 14.sp,
              color: AppColor.textcolorBlack,
            ),
          ),
          Image.asset(
            "assets/icons/right-icon.png",
          ),
        ],
      ),
    ),
  );
}

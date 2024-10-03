import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../res/colors/app_color.dart';
import '../../res/fonts/text_style.dart';
import '../../res/routes/app_routes.dart';
import '../../utils/logger.dart';
import 'ViewModel/NotificationViewModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    logDebug('Fetching notifications');
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id'); // Adjust key if needed

      if (userId != null && userId.isNotEmpty) {
        final viewModel = Provider.of<NotificationViewModel>(context, listen: false);
        logDebug('User ID retrieved: $userId');
        final int parsedUserId = int.parse(userId); // Assuming userId is a number
        logDebug('Fetching notifications for user ID: $parsedUserId');
        await viewModel.loadNotifications(parsedUserId);
      } else {
        logDebug('User ID is empty or not found in shared preferences');
      }
    } catch (e) {
      logDebug('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotificationViewModel>(context);

    // Helper method to format the date
    String _formatDate(String dateStr) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(dateStr);
        final currentYear = DateTime.now().year;
        final dateFormat = date.year == currentYear
            ?  DateFormat('d MMMM yyyy')
            : DateFormat('d MMMM yyyy');

        return dateFormat.format(date);
      } catch (e) {
        logDebug('Date formatting error: $e');
        return dateStr; // Return the original string if formatting fails
      }
    }


    // Helper method to sort notifications and filter out empty dates
    List<MapEntry<String, List<NotificationData>>> _getSortedNotifications() {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Filter out dates with no notifications
      final filteredEntries = viewModel.notificationsByDate.entries
          .where((entry) => entry.value.isNotEmpty)
          .toList();

      // Sort notifications by date
      final sortedEntries = filteredEntries
        ..sort((a, b) {
          if (a.key == today) return -1;
          if (b.key == today) return 1;
          return b.key.compareTo(a.key);
        });

      return sortedEntries;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.02),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColor.whiteColor,
            title: Text(
              'Notification',
              style: LexendtextFont500.copyWith(
                fontSize: 16.sp,
                color: AppColor.textcolorBlack,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
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
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : viewModel.error.isNotEmpty
          ? Center(child: Text(viewModel.error))
          : viewModel.notificationsByDate.isEmpty
          ? Center(child: Text('No notifications available'))
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _getSortedNotifications().length,
        itemBuilder: (context, index) {
          final entry = _getSortedNotifications()[index];
          final date = entry.key;
          final notifications = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  date == DateFormat('yyyy-MM-dd').format(DateTime.now())
                      ? 'Today'
                      : _formatDate(date), // Format the date
                  style: LexendtextFont500.copyWith(
                    fontSize: 10.sp,
                    color: AppColor.textcolorSilver,
                  ),
                ),
              ),
              notifications.isEmpty
                  ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No notifications for this date',
                  style: LexendtextFont400.copyWith(
                    fontSize: 14.sp,
                    color: AppColor.textcolor_gray,
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, notificationIndex) {
                  final notification = notifications[notificationIndex];
                  logDebug('Displaying notification: ${notification.studentName}');

                  // String expirationText;
                  // switch (notification.endingOn) {
                  //   case 'Today':
                  //     expirationText = 'Subscription expiring today';
                  //     break;
                  //   case 'Soon':
                  //     expirationText = 'Subscription expiring soon';
                  //     break;
                  //   default:
                  //     expirationText = 'Subscription Ending On: ${notification.endDate}';
                  // }

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
                          Image.asset(
                            'assets/icons/ball-icon.png',
                            width: 24.w,
                            height: 24.h,
                            color: AppColor.textcolor_red,
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Text(
                                  //   notification.studentName,
                                  //   style: TextStyle(color: Colors.red, fontSize: 11.sp),
                                  // ),
                                  Text(
                                    notification.studentName.length > 10
                                        ? '${notification.studentName.substring(0, 10)}...'
                                        : notification.studentName,
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolor_red,
                                      fontSize: 11.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(width: 4.w),
                                 //  Text(
                                 //    expirationText,
                                 //    style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                 //  ),
                                  Text(
                                    // expirationText,
                                    'Subscription expiring',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    '${notification.endingOn}',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 10.sp,
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

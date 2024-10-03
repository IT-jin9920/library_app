import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_app/res/colors/app_color.dart';
import 'package:library_app/res/fonts/text_style.dart';

Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Align(
            alignment: Alignment.center,
            child: Text('Logout')),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).pop(false); // User does not want to logout
          //   },
          //   child: Text('Cancel'),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                  width: 100.w,
                  // width: double.infinity,
                  height: 40.h, // Adjust height as needed
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
                  // width: double.infinity,
                  width: 100.w,
                  height: 40.h, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: AppColor.btncolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Logout',
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

          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).pop(true); // User wants to logout
          //   },
          //   child: Text('Logout'),
          // ),
        ],
      );
    },
  );
}

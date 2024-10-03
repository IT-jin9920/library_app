import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_app/res/colors/app_color.dart';
import 'package:library_app/res/fonts/text_style.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPressed,
        child: Center(
          child: Text(
            'Login',
            style: LexendtextFont400.copyWith(
              fontSize: 16.sp,
              color:AppColor.whiteColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

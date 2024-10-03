import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_app/res/colors/app_color.dart';
import 'package:library_app/res/fonts/text_style.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  SubmitButton({required this.onPressed});

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
            'Submit',
            style: LexendtextFont700.copyWith(
              color: AppColor.whiteColor,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

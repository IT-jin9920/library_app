import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';

class CustomDropdownStuden extends StatefulWidget {
  final String? value;
  final String hint;
  final VoidCallback onTap;

  CustomDropdownStuden({
    this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  State<CustomDropdownStuden> createState() => _CustomDropdownStudenState();
}

class _CustomDropdownStudenState extends State<CustomDropdownStuden> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: widget.value != null ? AppColor.BorderColorblue : AppColor.BorderColorsilver),
          borderRadius: BorderRadius.circular(7.0),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.value ?? widget.hint,
              style: LexendtextFont300.copyWith(
                color: widget.value != null ? AppColor.textcolorBlack : AppColor.BorderColorsilver,
                fontSize: 14.sp,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColor.textcolorBlack,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart'; // Adjust the import path as needed

class RegistrationTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode focusNode;
  final VoidCallback? toggleObscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;

  RegistrationTextFormField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    required this.focusNode,
    this.toggleObscureText,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        maxLength: maxLength,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
          hintStyle: LexendtextFont300.copyWith(
            fontSize: 14.sp,
            color: AppColor.textcolorSilver,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              color: focusNode.hasFocus ? AppColor.BorderColorblue : AppColor.BorderColorsilver,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:AppColor.BorderColorblue,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        validator: validator,
      ),
    );
  }
}

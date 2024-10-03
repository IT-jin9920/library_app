import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';

class LoginTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode focusNode;
  final VoidCallback? toggleObscureText;
  final VoidCallback? onFieldSubmittedCallback;

  LoginTextFormField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    required this.focusNode,
    this.toggleObscureText,
    this.onFieldSubmittedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: LexendtextFont300.copyWith(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              color: focusNode.hasFocus
                  ? AppColor.BorderColorblue
                  : AppColor.BorderColorsilver,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.BorderColorblue,
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
          suffixIcon: hintText.toLowerCase().contains("password")
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.BorderColorsilver,
                  ),
                  onPressed: toggleObscureText,
                )
              : null,
        ),
        validator: validator,
        onFieldSubmitted: (value) {
          // Call the provided callback if available
          if (onFieldSubmittedCallback != null) {
            onFieldSubmittedCallback!();
          }
        },
      ),
    );
  }
}

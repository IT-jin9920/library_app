import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_app/res/colors/app_color.dart';
import '../../res/fonts/text_style.dart';
import '../../res/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userRole = 'Accountant';

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to adapt to different screen sizes
    ScreenUtil.init(context);

    // Get the screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05), // Shadow color
                spreadRadius: 1, // Spread radius
                blurRadius: 4, // Blur radius
                offset: Offset(0, 4), // Shadow offset (bottom side)
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColor.whiteColor,
          //  elevation: 0, // Disable default elevation shadow
            title: Image.asset(
              "assets/images/login-img.png",
              height: 40.h,
              width: 109.w,
            ),
            actions: [
              userRole == 'Accountant'
                  ? InkWell(
                onTap: () {
                  // Redirect to Registration page
                  Navigator.pushNamed(context, AppRoutes.registration);
                },
                child: Row(
                  children: [
                    Text(
                      "Student registration",
                      style: LexendtextFont500.copyWith(
                        fontSize: 16.sp, // Scalable font size
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
              )
                  : Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "View Available Student",
                      style: LexendtextFont500.copyWith(
                        fontSize: 16.sp, // Scalable font size
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
            automaticallyImplyLeading: false, // Hides the back button
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
                  // Redirect to student Record Screen
                  Navigator.pushNamed(context, AppRoutes.studentRecordScreen);
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

              // Dashbord
              SizedBox(height: 20.h),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        Container(
                          width: 100.w,
                          height: 65.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: AppColor.btncolor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Available ',
                                style: LexendtextFont600.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.btncolor,
                                ),
                              ),
                              Text(
                                '10',
                                style: LexendtextFont700.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColor.textcolorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 100.w,
                          height: 65.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: AppColor.textcolor_gold,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Left Library',
                                style: LexendtextFont600.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.textcolor_gold,
                                ),
                              ),
                              Text(
                                '5',
                                style: LexendtextFont700.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColor.textcolorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 100.w,
                          height: 65.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: AppColor.green,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Available ',
                                style: LexendtextFont600.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.green,
                                ),
                              ),
                              Text(
                                '15',
                                style: LexendtextFont700.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColor.textcolorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // // print
              // Container(
              //   padding: EdgeInsets.only(
              //     left: 18.w,
              //     right: 42.w,
              //     top: 20.h,
              //     bottom: 20.h,
              //   ),
              //   decoration: BoxDecoration(
              //     color: AppColor.bglightgray,
              //     //color: Color(0xfff7f7f7), // F5F5F5CC
              //     //color: Color(0xffF5F5F5).withOpacity(0.80),
              //     borderRadius: BorderRadius.circular(12.0),
              //   ),
              //   width: double.infinity,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           // Handle tap here
              //           Navigator.pushNamed(context, AppRoutes.printPaymentScreen);
              //         },
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Print Payment Slip",
              //               style: LexendtextFont600.copyWith(
              //                 fontSize: 14.sp,
              //                 color: AppColor.textcolorBlack,
              //               ),
              //             ),
              //             Image.asset(
              //               "assets/icons/right-icon.png",
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(height: 26.h),
              //       GestureDetector(
              //         onTap: (){
              //           Navigator.pushNamed(context, AppRoutes.studentReportScreen);
              //         },
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Students Report",
              //               style: LexendtextFont600.copyWith(
              //                 fontSize: 14.sp,
              //                 color: AppColor.textcolorBlack,
              //               ),
              //             ),
              //             Image.asset(
              //               "assets/icons/right-icon.png",
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(height: 26.h),
              //       GestureDetector(
              //         onTap: (){
              //           Navigator.pushNamed(context, AppRoutes.notification);
              //         },
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Notification",
              //               style: LexendtextFont600.copyWith(
              //                 fontSize: 14.sp,
              //                 color: AppColor.textcolorBlack,
              //               ),
              //             ),
              //             Image.asset(
              //               "assets/icons/right-icon.png",
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20.h),

              Container(
                padding: EdgeInsets.only(
                  left: 18.w,
                  right: 42.w,
                  top: 20.h,
                  bottom: 20.h,
                ),
                decoration: BoxDecoration(
                  color: AppColor.bglightgray,
                //  color: Color(0xffF5F5F5F5).withOpacity(0.80),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle tap here
                        Navigator.pushNamed(context, AppRoutes.availableStudents);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Available Student",
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
                    SizedBox(height: 26.h),
                    GestureDetector(
                      onTap: () {
                        // Handle tap here
                        Navigator.pushNamed(context, AppRoutes.printPaymentScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Print Payment Slip",
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
                    SizedBox(height: 26.h),
                    GestureDetector(
                      onTap: () {
                        // Handle tap here
                        Navigator.pushNamed(context, AppRoutes.studentReportScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Students Report",
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
                    SizedBox(height: 26.h),
                    GestureDetector(
                      onTap: () {
                        // Handle tap here
                        Navigator.pushNamed(context, AppRoutes.notification);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Notification",
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
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Notification
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notification",
                    style: LexendtextFont500.copyWith(
                      fontSize: 14.sp,
                      color: AppColor.textcolorSilver,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                       // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.studentsdetails);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.bglightgray,
                        // color: Color(0xffF5F5F5F5).withOpacity(0.80),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      width: double.infinity,
                      height: 70.h,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ball-icon.png",
                            width: 28.w,
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "$name’s ",
                                    'Chetan Parmar',
                                    style: LexendtextFont400.copyWith(
                                      color: Colors.red,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'Subscription expiring soon',
                                    style: LexendtextFont400.copyWith(
                                      color: AppColor.textcolorBlack,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Subscription End : 22/12/2025",
                                // "Subscription End : $endDate",
                                style: PoppinstextFont200.copyWith(
                                  color: AppColor.textcolorBlack,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

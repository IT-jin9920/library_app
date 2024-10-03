import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';
import '../ViewModel/seat_viewmodel.dart';
import '../data/seat_model.dart';

class SeatViewModel {
  Future<SeatDetails> fetchSeatDetailsForBoys() async {
    final response = await http.get(Uri.parse('https://library.mechodal.com/seat_detail.php'));
    if (response.statusCode == 200) {
      return SeatDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load seat details');
    }
  }

  Future<SeatDetails> fetchSeatDetailsForGirls() async {
    final response = await http.get(Uri.parse('https://library.mechodal.com/seat_detail_female.php'));
    if (response.statusCode == 200) {
      return SeatDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load seat details');
    }
  }
}

class AvailableStudentRecordPage extends StatefulWidget {
  const AvailableStudentRecordPage({super.key});

  @override
  State<AvailableStudentRecordPage> createState() => _AvailableStudentRecordPageState();
}

class _AvailableStudentRecordPageState extends State<AvailableStudentRecordPage> {
  late Future<SeatDetails> futureSeatDetails;
  String selectedGender = '';
  final SeatViewModel seatViewModel = SeatViewModel();

  @override
  void initState() {
    super.initState();
    fetchInitialSeatDetails();
    loadUserId();
  }

  Future<void> fetchInitialSeatDetails() async {
    setState(() {
      futureSeatDetails = seatViewModel.fetchSeatDetailsForBoys(); // Default to boys
    });
  }

  Future<void> loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userIdString = prefs.getString('user_id');
      final userId = userIdString != null ? int.tryParse(userIdString) : 0;

      if (userId != null && userId != 0) {
        print('Valid user ID found: $userId');
      } else {
        print('User ID not found or invalid.');
      }
    } catch (e) {
      print('Error loading user ID: $e');
    }
  }

  void updateSeatDetails(String gender) {
    setState(() {
      selectedGender = gender;
      futureSeatDetails = gender == 'boys'
          ? seatViewModel.fetchSeatDetailsForBoys()
          : seatViewModel.fetchSeatDetailsForGirls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        title: Text(
          'Seat Record',
          style: LexendtextFont500.copyWith(
            fontSize: 16.sp,
            color: AppColor.textcolorBlack,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
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
                Icon(Icons.arrow_forward_ios, color: AppColor.btncolor, size: 17.sp),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<SeatDetails>(
        future: futureSeatDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: AppColor.btncolor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final seatDetails = snapshot.data!;
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => updateSeatDetails('boys'),
                      child: Container(
                        height: 45.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedGender == 'boys' ? AppColor.btncolor : AppColor.whiteColor,
                          border: Border.all(
                            color: selectedGender == 'boys' ? Colors.transparent : Color(0xFFACAFB5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Boys',
                            style: selectedGender == 'boys'
                                ? LexendtextFont600.copyWith(fontSize: 16.sp, color: AppColor.whiteColor)
                                : LexendtextFont300.copyWith(fontSize: 16.sp, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => updateSeatDetails('girls'),
                      child: Container(
                        height: 45.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedGender == 'girls' ? AppColor.btncolor : AppColor.whiteColor,
                          border: Border.all(
                            color: selectedGender == 'girls' ? Colors.transparent : Color(0xFFACAFB5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Girls',
                            style: selectedGender == 'girls'
                                ? LexendtextFont600.copyWith(fontSize: 16.sp, color: AppColor.whiteColor)
                                : LexendtextFont300.copyWith(fontSize: 16.sp, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              // Display reserved, available, and available soon counts
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xffBDBDC2),
                          radius: 15.r,
                          child: Center(
                            child: Text(
                              "${seatDetails.totalReserved}",
                              style: poppinsRegular.copyWith(
                                fontSize: 10.sp,
                                color: AppColor.textcolorBlack,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Reserved",
                          style: poppinsRegular.copyWith(
                            fontSize: 13,
                            color: AppColor.textcolorBlack,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5.w),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColor.whiteColor,
                            radius: 15.r,
                            child: Center(
                              child: Text(
                                "${seatDetails.totalAvailable}",
                                style: poppinsRegular.copyWith(
                                  fontSize: 10.sp,
                                  color: AppColor.textcolorBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Available",
                          style: poppinsRegular.copyWith(
                            fontSize: 13,
                            color: AppColor.textcolorBlack,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5.w),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.btncolor,
                          radius: 15.r,
                          child: Center(
                            child: Text(
                              "${seatDetails.totalAvailableSoon}",
                              style: poppinsRegular.copyWith(
                                fontSize: 10.sp,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Available Soon",
                          style: poppinsRegular.copyWith(
                            fontSize: 13,
                            color: AppColor.textcolorBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                ),
                itemCount: seatDetails.seats.length,
                itemBuilder: (context, index) {
                  final seat = seatDetails.seats[index];
                  Color bgColor;
                  Color textColor;

                  switch (seat.status) {
                    case "Available":
                      bgColor = AppColor.whiteColor;
                      textColor = Colors.black;
                      break;
                    case "Reserved":
                      bgColor = Color(0xffBDBDC2);
                      textColor = Colors.black;
                      break;
                    case "Available Soon":
                      bgColor = AppColor.btncolor;
                      textColor = Colors.white;
                      break;
                    default:
                      bgColor = Colors.red[300]!;
                      textColor = Colors.white;
                  }

                  return Container(
                    margin: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Color(0xffBDBDC2), width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      seat.seatNo,
                      style: TextStyle(fontSize: 16.sp, color: textColor),
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

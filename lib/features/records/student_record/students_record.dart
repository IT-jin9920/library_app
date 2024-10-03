import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_app/utils/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/fonts/text_style.dart';
import '../../../res/routes/app_routes.dart';
import '../../../utils/logger.dart';
import 'view_modal_studentrecord/student_record_view_model.dart';

class StudentsRecord extends StatefulWidget {
  const StudentsRecord({Key? key}) : super(key: key);

  @override
  State<StudentsRecord> createState() => _StudentsRecordState();
}

class _StudentsRecordState extends State<StudentsRecord> {
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentRecord();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  // In the StudentsRecord screen

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final result = ModalRoute.of(context)?.settings.arguments as bool?;
    if (result == true) {
      _fetchStudentRecord(); // Refresh data if necessary
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudentRecord() async {
    try {
      logDebug('Fetching student records...');
      final userIdString = await SharedPreferencesHelper.getUserId();
      final userId = userIdString != null ? int.tryParse(userIdString) : null;

      if (userId != null) {
        logDebug('User ID: $userId');
        final viewModel =
            Provider.of<StudentRecordViewModel>(context, listen: false);
        await viewModel.fetchStudentRecord(userId);
      } else {
        logDebug('User ID is either null or not a valid integer.');
      }
    } catch (e) {
      logDebug('Failed to fetch student records: $e');
    }
  }

  Future<void> _fetchStudentRecords(DateTime date) async {
    try {
      logDebug('Fetching student records for date: ${date.toIso8601String()}');
      final userIdString = await SharedPreferencesHelper.getUserId();
      final userId = userIdString != null ? int.tryParse(userIdString) : null;

      if (userId != null) {
        final formattedDate = date.toIso8601String().split('T')[0];
        logDebug('User ID: $userId, Date: $formattedDate');
        final viewModel =
            Provider.of<StudentRecordViewModel>(context, listen: false);
        await viewModel.fetchStudentRecords(userId, formattedDate);
      } else {
        logDebug('User ID is either null or not a valid integer.');
      }
    } catch (e) {
      logDebug('Failed to fetch student records: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      logDebug('Showing date picker...');
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColor.btncolor,
                onPrimary: AppColor.whiteColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.whiteColor,
                  backgroundColor: AppColor.btncolor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate;
        });

        logDebug('Selected date: ${pickedDate.toIso8601String()}');

        // Fetch records for the selected date
        await _fetchStudentRecords(pickedDate);
      } else {
        logDebug('No date selected or date is the same as the previous one.');
      }
    } catch (e) {
      logDebug('Failed to select date or fetch student records: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StudentRecordViewModel>(context);

    // Filter records based on the search query
    final filteredRecords = viewModel.studentRecords.where((record) {
      return record.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    logDebug('Student Records Count: ${viewModel.studentRecords.length}');

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.02),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColor.whiteColor,
            title: Text(
              'Student Record',
              style: LexendtextFont500.copyWith(
                fontSize: 16.sp,
                color: AppColor.textcolorBlack,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  logDebug('Navigating back...');

                  // if (_isFirstTime) {
                  //   // If it's the first visit, just pop the navigation stack
                  //   Navigator.pop(context);
                  //   logDebug('First visit - popping once.');
                  // } else {
                  //   // If returning from detail page, pop twice
                  //   Navigator.pop(context); // Pop current screen
                  //   Navigator.pop(context); // Pop previous screen
                  //   logDebug('Not first visit - popping twice.');
                  // }

                  if (_isFirstTime) {
                    Navigator.pop(context); // First time, pop once
                    logDebug('First visit - popping once.');
                    _isFirstTime = false; // Set to false after the first pop
                  } else {
                    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.studentRecordScreen));
                    logDebug('Subsequent visit - navigating back to records screen.');
                  }
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/search-icon.png',
                          color: AppColor.textcolorSilver,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      hintText: 'Search...',
                      hintStyle: LexendtextFont300.copyWith(
                        color: AppColor.textcolorSilver,
                        fontSize: 14.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColor.textcolorSilver,
                          width: 1.w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColor.textcolorSilver,
                          width: 1.w,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 60.w,
                  height: 45.h,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      width: 60.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColor.textcolorSilver),
                      ),
                      child: Image.asset("assets/icons/calender-icon.png"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: viewModel.isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(color: AppColor.btncolor))
                  : viewModel.errorMessage != null
                      ? Center(child: Text(viewModel.errorMessage!))
                      : viewModel.studentRecords.isEmpty
                          ? Center(child: Text('No student records available'))
                          : ListView.builder(
                              itemCount: filteredRecords.length,
                              itemBuilder: (context, index) {
                                final record = filteredRecords[index];
                                return InkWell(
                                  onTap: () {
                                    logDebug(
                                        'Navigating to student details for ${record.studentId}');
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.studentsdetails,
                                      arguments: record.studentId,
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5.r),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: AppColor.bglightgray,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    width: double.infinity,
                                    height: 70.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              record.name,
                                              style: LexendtextFont500.copyWith(
                                                color: AppColor.textcolorBlack,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Subscription End:",
                                                  style: PoppinstextFont400
                                                      .copyWith(
                                                    color:
                                                        AppColor.textcolorBlack,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  "${record.endDate}",
                                                  style: PoppinstextFont400
                                                      .copyWith(
                                                    color:
                                                        AppColor.textcolor_gray,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                            "assets/icons/right-icon.png"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

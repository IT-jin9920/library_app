import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';
import '../../../../res/routes/app_routes.dart';
import '../../data/report_model.dart';
import '../../domain/student_report_view_model.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  // Variables to store selected dates
  String _startDate = '';
  String _endDate = '';

  // Variables to store fetched and filtered reports
  List<StudentReport> _reports = [];
  List<StudentReport> _filteredReports = [];

  // Controller for the search field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterReports);

    // Set default dates to today
    _startDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Fetch reports for today's date
    _fetchReports();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterReports);
    _searchController.dispose();
    super.dispose();
  }

  // Function to filter reports based on search query
  void _filterReports() {
    final query = _searchController.text.toLowerCase();
    final filtered = _reports.where((report) {
      return report.studentName.toLowerCase().contains(query);
    }).toList();
    if (mounted) {
      setState(() {
        _filteredReports = filtered;
      });
    }
  }

  // Function to show date picker and update the selected date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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

    if (selectedDate != null) {
      setState(() {
        final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        if (isStartDate) {
          _startDate = formattedDate;
        } else {
          _endDate = formattedDate;
        }
        // Trigger report fetching if end date is selected
        if (!isStartDate) {
          _fetchReports();
        }
      });
    }
  }

  Future<void> _fetchReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';

      final startDateFormatted = _formatDate(_startDate);
      final endDateFormatted = _formatDate(_endDate);

      if (startDateFormatted.isEmpty || endDateFormatted.isEmpty) {
        return;
      }

      final viewModel = Provider.of<StudentReportViewModel>(context, listen: false);

      await viewModel.fetchReports(
        userId: userId,
        startDate: startDateFormatted,
        endDate: endDateFormatted,
      );

      if (mounted) {
        setState(() {
          _reports = viewModel.reports;
          _filterReports(); // Update the filtered reports based on the new data
        });
      }
    } catch (e) {
      print('API Request Error: $e');
    }
  }

  String _formatDate(String date) {
    try {
      final inputFormat = DateFormat('dd-MM-yyyy');
      final outputFormat = DateFormat('yyyy-MM-dd');
      final parsedDate = inputFormat.parse(date);
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Date formatting error: $e');
      return '';
    }
  }

  void _handleTap(String studentId) {
    print('Student ID: $studentId');
    // Navigate to the student details page
    Navigator.pushNamed(
      context,
      AppRoutes.studentsdetails,
      arguments: studentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.btncolor,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120.h),
          child: Container(
            color: AppColor.btncolor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColor.whiteColor,
                    ),
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
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColor.whiteColor,
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/cal-icon.png',
                                  color: AppColor.btncolor,
                                  height: 18.h,
                                  width: 19.w,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    _startDate.isEmpty ? 'Start Date' : _startDate,
                                    style: LexendtextFont300.copyWith(
                                      color: AppColor.textcolorSilver,
                                      fontSize: 13.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.textcolorSilver,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'TO',
                        style: LexendtextFont500.copyWith(
                          color: AppColor.whiteColor,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColor.whiteColor,
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/cal-icon.png',
                                  color: AppColor.btncolor,
                                  height: 18.h,
                                  width: 19.w,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    _endDate.isEmpty ? 'End Date' : _endDate,
                                    style: LexendtextFont300.copyWith(
                                      color: AppColor.textcolorSilver,
                                      fontSize: 13.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.textcolorSilver,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Consumer<StudentReportViewModel>(builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.error.isNotEmpty) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          // Update reports and filteredReports only if viewModel.reports has changed
          if (_reports != viewModel.reports) {
            _reports = viewModel.reports;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _filterReports();
            });
          }

          return ListView.builder(
            itemCount: _filteredReports.length,
            itemBuilder: (context, index) {
              final report = _filteredReports[index];
              return InkWell(
                onTap: () {
                  _handleTap(report.studentId);
                },
                child: Container(
                  margin: EdgeInsets.all(5.r),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColor.bglightgray,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  width: double.infinity,
                  height: 70.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.studentName,
                            style: LexendtextFont500.copyWith(
                              color: AppColor.textcolorBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            "Subscription End: ${report.endDate}",
                            style: PoppinstextFont400.copyWith(
                              color: AppColor.textcolorBlack,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/icons/right-icon.png",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

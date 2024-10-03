import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/fonts/text_style.dart';
import '../../../res/routes/app_routes.dart';
import '../../registration/presentation/widgets/image_picker_Widget.dart';
import '../../registration/presentation/widgets/registration_form.dart';
import '../../registration/presentation/widgets/submit_button.dart';
import 'data/student_service.dart';

class StudentRecordEdit extends StatefulWidget {
  final int? studentId;

  const StudentRecordEdit({Key? key, this.studentId}) : super(key: key);

  @override
  State<StudentRecordEdit> createState() => _StudentRecordEditState();
}

class _StudentRecordEditState extends State<StudentRecordEdit> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _aadharFrontImageFile, _aadharBackImageFile;
  File? _profileImageFile;

  // Add these if you need to handle the new fields
  final TextEditingController _photoController = TextEditingController(); // For Profile Photo URL
  final TextEditingController _aadharFrontController = TextEditingController(); // For Aadhar Front Image URL
  final TextEditingController _aadharBackController = TextEditingController(); // For Aadhar Back Image URL

  // Controllers for form fields
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _feesWordController = TextEditingController();
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _contactDetailsController =
      TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _setNumberController = TextEditingController();

  // Focus nodes for each field
  final FocusNode _studentNameFocus = FocusNode();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();
  final FocusNode _feesFocus = FocusNode();
  final FocusNode _employeeCodeFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _contactDetailsFocus = FocusNode();
  final FocusNode _aadharNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _setNumberFocus = FocusNode();

  final StudentService _studentService = StudentService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final int? studentId = widget.studentId;
    print('Received student ID on edit page init call: $studentId');

    if (widget.studentId != null) {
      _fetchStudentDetails();
    }
  }

  Future<void> _fetchStudentDetails() async {
    setState(() => _isLoading = true);
    try {
      if (widget.studentId != null) {
        print('Fetching details for student ID: ${widget.studentId}'); // Debugging output
        final studentDetailsResponse = await _studentService.getStudentDetails(widget.studentId!);

        // Check the response status
        if (studentDetailsResponse.status == 'success') {
          final studentData = studentDetailsResponse.data;

          // Print student details to console
          print('_fetchStudentDetails call....');
          print('Student ID: ${studentData.id}');
          // print('Employee Code: ${studentData.empCode}');
          // print('User ID: ${studentData.userId}');
          // print('Photo URL: ${studentData.photo}');
          // print('Aadhar Front URL: ${studentData.aadharFront}');
          // print('Aadhar Back URL: ${studentData.aadharBack}');
          // print('Seat Number: ${studentData.seatNo}');
          print('Name: ${studentData.name}');
          print('Serial Number: ${studentData.serialNo}');
          print('Contact: ${studentData.contact}');
          print('Aadhar Number: ${studentData.aadharNo}');
          print('Address: ${studentData.address}');
          // print('Date: ${studentData.date}');
          // print('Updated At: ${studentData.updatedAt}');
          // print('Start Date: ${studentData.startDate}'); // New print statement
          // print('End Date: ${studentData.endDate}'); // New print statement
          // print('Fees: ${studentData.fees}'); // New print statement
          // print('Fees Amount in Words: ${studentData.feesAmountInWords}'); // New print statement

          setState(() {
            _studentNameController.text = studentData.name;
            _serialNumberController.text = studentData.serialNo;
            _contactDetailsController.text = studentData.contact;
            _aadharNumberController.text = studentData.aadharNo;
            _addressController.text = studentData.address;
             _employeeCodeController.text = studentData.empCode;
             _setNumberController.text = studentData.seatNo;
             _photoController.text = studentData.photo;
             _aadharFrontController.text = studentData.aadharFront;
             _aadharBackController.text = studentData.aadharBack;
            // Set additional fields if necessary
            // _startDateController.text = studentData.startDate; // Example
            // _endDateController.text = studentData.endDate; // Example
            // _feesController.text = studentData.fees; // Example
            // _feesWordController.text = studentData.feesAmountInWords; // Example
          });
        } else {
          throw Exception(studentDetailsResponse.message);
        }
      }
    } catch (e) {
      print('Error fetching student details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching student details: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStudentDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        print('Updating student details for ID: ${widget.studentId}'); // Debugging output
        print('Name: ${_studentNameController.text}');
        print('Serial No: ${_serialNumberController.text}');
        print('Contact: ${_contactDetailsController.text}');
        print('Aadhar No: ${_aadharNumberController.text}');
        print('Address: ${_addressController.text}');
        print('Employee Code: ${_employeeCodeController.text}');
        print('Seat No: ${_setNumberController.text}');
        print('Photo URL: ${_photoController.text}');
        print('Aadhar Front URL: ${_aadharFrontController.text}');
        print('Aadhar Back URL: ${_aadharBackController.text}');
        // Print additional fields if added
         print('Start Date: ${_startDateController.text}');
         print('End Date: ${_endDateController.text}');
         print('Fees: ${_feesController.text}');
         print('Fees Amount in Words: ${_feesWordController.text}');

        final response = await _studentService.updateStudentDetails(
          studentId: widget.studentId ?? 0,
          name: _studentNameController.text,
          serialNo: _serialNumberController.text,
          contact: _contactDetailsController.text,
          aadharNo: _aadharNumberController.text,
          address: _addressController.text,
          empCode: _employeeCodeController.text, // Include employee code
           seatNo: _setNumberController.text, // Include seat number
         //  photo: _photoController.text, // Include profile photo URL
           photo:_profileImageFile, // Include profile photo URL
           aadharFront: _aadharFrontImageFile, // Include Aadhar front image URL
          // aadharFront: _aadharFrontController.text, // Include Aadhar front image URL
           aadharBack: _aadharBackImageFile, // Include Aadhar back image URL
          // aadharBack: _aadharBackController.text, // Include Aadhar back image URL
          // Add additional parameters if needed
          // startDate: _startDateController.text,
          // endDate: _endDateController.text,
          // fees: _feesController.text,
          // feesAmountInWords: _feesWordController.text,
        );

        print('Update response: ${response.message}'); // Debugging output
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        if (response.status == 'success') {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.studentsdetails,
            arguments: widget.studentId,
          );
        }
      } catch (e) {
        print('Error updating student details: $e'); // Debugging output
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating student details: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage(bool isFront) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
        );
        if (pickedFile != null) {
          setState(() {
            if (isFront) {
              _aadharFrontImageFile = File(pickedFile.path);
            } else {
              _aadharBackImageFile = File(pickedFile.path);
            }
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required to take photos')),
      );
    }
  }

  // Widget _buildImageWidget(
  //     File? imageFile, String assetPath, VoidCallback onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(12),
  //       child: imageFile != null
  //           ? Image.file(imageFile,
  //               height: 150.h, width: 150.w, fit: BoxFit.fill)
  //           : Image.asset(assetPath,
  //               height: 150.h, width: 150.w, fit: BoxFit.fill),
  //     ),
  //   );
  // }

  Widget _buildImageWidget(
      File? imageFile, String assetPath, VoidCallback onTap, {String? initialImageUrl}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageFile != null
            ? Image.file(imageFile,
            height: 150.h, width: 150.w, fit: BoxFit.fill)
            : initialImageUrl != null
            ? Image.network(initialImageUrl,
            height: 150.h, width: 150.w, fit: BoxFit.fill)
            : Image.asset(assetPath,
            height: 150.h, width: 150.w, fit: BoxFit.fill),
      ),
    );
  }


  @override
  void dispose() {
    _studentNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _feesController.dispose();
    _feesWordController.dispose();
    _employeeCodeController.dispose();
    _serialNumberController.dispose();
    _contactDetailsController.dispose();
    _aadharNumberController.dispose();
    _addressController.dispose();
    _setNumberController.dispose();
    _studentNameFocus.dispose();
    _startDateFocus.dispose();
    _endDateFocus.dispose();
    _feesFocus.dispose();
    _employeeCodeFocus.dispose();
    _serialNumberFocus.dispose();
    _contactDetailsFocus.dispose();
    _aadharNumberFocus.dispose();
    _addressFocus.dispose();
    _setNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.02),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColor.whiteColor,
            title: Text(
              'Edit Details',
              style: LexendtextFont500.copyWith(
                fontSize: 16.sp,
                color: AppColor.textcolorBlack,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: AppColor.btncolor,
            ))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Image Picker
                    // ImagePickerWidget(
                    //   initialImageUrl: _photoController.text,
                    //   onImagePicked: (file) {
                    //     setState(() {
                    //       _profileImageFile =
                    //           file; // Update the profile image file
                    //     });
                    //     print('Profile Image: ${file?.path}');
                    //   },
                    // ),
                    ImagePickerWidget(
                      initialImageUrl: _photoController.text, // Pass the current image URL
                      onImagePicked: (file) {
                        setState(() {
                          _profileImageFile = file; // Update the profile image file
                          _photoController.text = file?.path ?? ''; // Update the photo controller text
                        });
                        print('Profile Image: ${file?.path}');
                      },
                    ),

                    SizedBox(height: 20.h),
                    RegistrationTextFormField(
                      controller: _employeeCodeController,
                      hintText: 'Device Code',
                      focusNode: _employeeCodeFocus,
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter the device code'
                          : null,
                      maxLength: 4,
                    ),
                    SizedBox(height: 16.h),
                    RegistrationTextFormField(
                      controller: _studentNameController,
                      hintText: 'Student Name',
                      focusNode: _studentNameFocus,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter the student name'
                          : null,
                      maxLength: 30,
                    ),
                    SizedBox(height: 16.h),

                    RegistrationTextFormField(
                      controller: _setNumberController,
                      hintText: 'Set a number',
                      focusNode: _setNumberFocus,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // Check if the input is null or empty
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Set number';
                        }

                        // Check if the input is a valid integer in string form
                        final isValidNumber = RegExp(r'^\d+$').hasMatch(value);

                        if (!isValidNumber) {
                          return 'Please enter a valid number';
                        }

                        final numberValue = int.parse(
                            value); // Parse here since we've validated it as a number

                        // Validate the parsed number
                        if (numberValue < 1 || numberValue > 200) {
                          return 'Number must be between 1 and 200';
                        }

                        return null; // Validation passed
                      },
                      maxLength: 3,
                    ),
                    SizedBox(height: 16.h),

                    RegistrationTextFormField(
                      controller: _serialNumberController,
                      hintText: 'Serial Number',
                      focusNode: _serialNumberFocus,
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter the serial number'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    RegistrationTextFormField(
                      controller: _contactDetailsController,
                      hintText: 'Contact Details',
                      focusNode: _contactDetailsFocus,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter contact details';
                        final numericRegex = RegExp(r'^\d+$');
                        if (!numericRegex.hasMatch(value))
                          return 'Please enter a valid number';
                        if (value.length < 10)
                          return 'Please enter a valid mobile number ';
                        return null;
                      },
                      maxLength: 10,
                    ),
                    SizedBox(height: 16.h),
                    RegistrationTextFormField(
                      controller: _aadharNumberController,
                      hintText: 'Aadhar Number',
                      focusNode: _aadharNumberFocus,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter the Aadhar number';
                        final digitsOnly = RegExp(r'^\d+$');
                        if (!digitsOnly.hasMatch(value))
                          return 'Aadhar number must be numeric';
                        if (value.length != 12)
                          return 'Aadhar number must be 12 digits long';
                        return null;
                      },
                      maxLength: 12,
                    ),
                    SizedBox(height: 16.h),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _buildImageWidget(
                    //         _aadharFrontImageFile,
                    //         'assets/images/front-adhacard.jpg',
                    //         () => _pickImage(true)),
                    //     _buildImageWidget(
                    //         _aadharBackImageFile,
                    //         'assets/images/back-adhacard.jpg',
                    //         () => _pickImage(false)),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImageWidget(
                          _aadharFrontImageFile,
                          'assets/images/front-adhacard.jpg',
                              () => _pickImage(true),
                          initialImageUrl: _aadharFrontController.text, // Pass the current image URL if available
                        ),
                        _buildImageWidget(
                          _aadharBackImageFile,
                          'assets/images/back-adhacard.jpg',
                              () => _pickImage(false),
                          initialImageUrl: _aadharBackController.text, // Pass the current image URL if available
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    RegistrationTextFormField(
                      controller: _addressController,
                      hintText: 'Address',
                      focusNode: _addressFocus,
                      maxLines: 3,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter the address'
                          : null,
                    ),
                    SizedBox(height: 20.h),
                    SubmitButton(onPressed: _updateStudentDetails),
                  ],
                ),
              ),
            ),
    );
  }
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this line for MediaType
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:library_app/utils/shared_preferences_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../res/app_url/app_url.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/fonts/text_style.dart';
import '../../../res/routes/app_routes.dart';
import '../../../utils/logger.dart';
import '../../registration/data/device_code_model.dart';
import '../../registration/presentation/widgets/image_picker_Widget.dart';
import '../../registration/presentation/widgets/registration_form.dart';
import '../../registration/presentation/widgets/submit_button.dart';
import 'package:image/image.dart' as img;

class StudentRegisterDemo extends StatefulWidget {
  const StudentRegisterDemo({super.key});

  @override
  State<StudentRegisterDemo> createState() => _StudentRegisterDemoState();
}

class _StudentRegisterDemoState extends State<StudentRegisterDemo> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _aadharFrontImageFile, _aadharBackImageFile;
  File? _profileImageFile;

  // Controllers for form fields
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _feesWordController = TextEditingController();
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _contactDetailsController = TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _setNumberController = TextEditingController();

  // Focus nodes for each field
  final FocusNode _studentNameFocus = FocusNode();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();
  final FocusNode _feesFocus = FocusNode();
  final FocusNode _feesWordFocus = FocusNode();
  final FocusNode _employeeCodeFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _contactDetailsFocus = FocusNode();
  final FocusNode _aadharNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _setNumberFocus = FocusNode();

  String _paymentMode = 'Cash'; // Default payment mode
  String? _deviceCode;

  @override
  void initState() {
    super.initState();
   // _fetchDeviceCode();
  }

  // Future<void> _fetchDeviceCode() async {
  //   final response = await http.get(Uri.parse(AppUrl.deviceCodeApi));
  //
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     final deviceCodeResponse = DeviceCodeResponse.fromJson(jsonResponse);
  //
  //     if (deviceCodeResponse.status == 'success') {
  //       setState(() {
  //         _deviceCode = deviceCodeResponse.newDeviceCode;
  //         _employeeCodeController.text = _deviceCode ?? '';
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: ${deviceCodeResponse.message}')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to fetch device code')),
  //     );
  //   }
  // }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (context, child) {
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
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formattedDate = formatter.format(selectedDate);
        controller.text = formattedDate;
      });
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
          setState(() async {
            if (isFront) {
              _aadharFrontImageFile = File(pickedFile.path);
              // Crop the image after picking
              await _cropImage(pickedFile.path, isFront);
            } else {
              _aadharBackImageFile = File(pickedFile.path);
              await _cropImage(pickedFile.path, isFront);
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

  Future<void> _cropImage(String imagePath, bool isFront) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor:AppColor.btncolor,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        if (isFront) {
          _aadharFrontImageFile = File(croppedFile.path);
        } else {
          _aadharBackImageFile = File(croppedFile.path);
        }
      });
    }
  }

  Widget _buildImageWidget(File? imageFile, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageFile != null
            ? Image.file(imageFile, height: 150.h, width: 150.w, fit: BoxFit.fill)
            : Image.asset(assetPath, height: 150.h, width: 150.w, fit: BoxFit.fill),
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

  // void _validateAndSubmit() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Processing Data...')),
  //     );
  //
  //     // Prepare the data
  //     final name = _studentNameController.text;
  //     final serialNo = _serialNumberController.text;
  //     final contact = _contactDetailsController.text;
  //     final aadharNo = _aadharNumberController.text;
  //     final address = _addressController.text;
  //     final startDate = _startDateController.text; // Keep as string for API
  //     final endDate = _endDateController.text; // Keep as string for API
  //     final fee = _feesController.text;
  //     final feeWord = _feesWordController.text;
  //     final seatNo = _setNumberController.text.toString();
  //     final paymentMode = _paymentMode;
  //     final empCode = _employeeCodeController.text;
  //     //final empCode = '0000';
  //
  //     // Retrieve userId from SharedPreferences
  //     final userId = await SharedPreferencesHelper.getUserId();
  //
  //     logDebug('User ID retrieved: $userId');
  //
  //     if (userId == null) {
  //       logDebug('User ID is null, cannot proceed with registration.');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('User ID is missing. Registration cannot proceed.')),
  //       );
  //       return;
  //     }
  //
  //     // Check if images are provided
  //     if (_profileImageFile == null || _aadharFrontImageFile == null || _aadharBackImageFile == null) {
  //       logDebug('Image files are missing. Please provide all images.');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Please upload all required images.')),
  //       );
  //       return;
  //     }
  //
  //     // Log all data before API call
  //     logDebug('Registration Data:');
  //     logDebug('Name: $name');
  //     logDebug('Serial No: $serialNo');
  //     logDebug('Contact: $contact');
  //     logDebug('Aadhar No: $aadharNo');
  //     logDebug('Address: $address');
  //     logDebug('Start Date: $startDate');
  //     logDebug('End Date: $endDate');
  //     logDebug('Fee: $fee');
  //     logDebug('Fee in words: $feeWord');
  //     logDebug('User ID: $userId');
  //     logDebug('Seat No: $seatNo');
  //     logDebug('Payment Mode: $paymentMode');
  //     logDebug('Employee Code: $empCode');
  //     logDebug('Profile Image Path: ${_profileImageFile?.path}');
  //     logDebug('Aadhar Front Image Path: ${_aadharFrontImageFile?.path}');
  //     logDebug('Aadhar Back Image Path: ${_aadharBackImageFile?.path}');
  //
  //     // Create a Map for the request body
  //     final requestBody = {
  //       'name': name,
  //       'serial_no': serialNo,
  //       'contact': contact,
  //       'aadhar_no': aadharNo,
  //       'address': address,
  //       'start_date': startDate,
  //       'end_date': endDate,
  //       'fee': fee.toString(), // Convert fee to string
  //       'user_id': userId.toString(),
  //       'seat_no': seatNo,
  //       'payment_mode': paymentMode,
  //       'Empcode': empCode,
  //       'fees_in_word': feeWord,
  //     };
  //
  //     // Log the request body
  //     logDebug('Request Body: ${requestBody.toString()}');
  //
  //     // API call to register student using multipart request
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(AppUrl.demoregisterApi),
  //     );
  //
  //     // Add form fields
  //     request.fields.addAll(requestBody);
  //     logDebug('Form fields added to request.');
  //
  //     // Add image files
  //     if (_profileImageFile != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'photo',
  //         _profileImageFile!.path,
  //         contentType: MediaType('image', 'png'),
  //       ));
  //       logDebug('Profile image added to request.');
  //     }
  //     if (_aadharFrontImageFile != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'aadhar_front',
  //         _aadharFrontImageFile!.path,
  //         contentType: MediaType('image', 'png'),
  //       ));
  //       logDebug('Aadhar front image added to request.');
  //     }
  //     if (_aadharBackImageFile != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'aadhar_back',
  //         _aadharBackImageFile!.path,
  //         contentType: MediaType('image', 'png'),
  //       ));
  //       logDebug('Aadhar back image added to request.');
  //     }
  //
  //     // Send the request
  //     final response = await request.send();
  //     logDebug('API request sent, waiting for response.');
  //
  //     // Log the response status code
  //     logDebug('Response status code on registration page: ${response.statusCode}');
  //
  //     // Handle response
  //     if (response.statusCode == 200) {
  //       final responseData = await http.Response.fromStream(response);
  //       logDebug('Response received from server.');
  //
  //       // Log the response body for debugging
  //       logDebug('Response body on demo registration page: ${responseData.body}');
  //
  //       try {
  //         // Attempt to parse JSON after stripping out HTML
  //         var responseBody = responseData.body;
  //         if (responseBody.contains('<')) {
  //           // If the response contains HTML, clean it up
  //           responseBody = responseBody.replaceAll(RegExp(r'<[^>]*>'), '');
  //           logDebug('Response body cleaned of HTML.');
  //         }
  //         logDebug('Parsed response body: $responseBody');
  //
  //         final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
  //
  //         if (jsonResponse['status'] == 'success') {
  //           final studentId = jsonResponse['student_id'];
  //           logDebug('Registration successful: Student ID = $studentId');
  //
  //           // Navigator.pushNamed(
  //           //   context,
  //           //   AppRoutes.registrationSuccess,
  //           //   arguments: {
  //           //     'studentId': studentId,
  //           //     'requestBody': requestBody,
  //           //     'images': {
  //           //       'profileImage': _profileImageFile!.path,
  //           //       'aadharFrontImage': _aadharFrontImageFile!.path,
  //           //       'aadharBackImage': _aadharBackImageFile!.path,
  //           //     },
  //           //   },
  //           // );
  //           try {
  //             Navigator.pushNamed(
  //               context,
  //               AppRoutes.demoSuccessRegistration,
  //               arguments: {
  //                 'studentId': studentId,
  //                 'requestBody': requestBody,
  //                 'images': {
  //                   'profileImage': _profileImageFile!.path,
  //                   'aadharFrontImage': _aadharFrontImageFile!.path,
  //                   'aadharBackImage': _aadharBackImageFile!.path,
  //                 },
  //               },
  //             );
  //             logDebug('Navigated to registration success page.');
  //           } catch (e) {
  //             logDebug('Error during navigation: $e');
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text('Navigation failed: $e')),
  //             );
  //           }
  //
  //
  //         } else {
  //           logDebug('Registration failed: ${jsonResponse['message']}');
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Registration Failed: ${jsonResponse['message']}')),
  //           );
  //         }
  //       } catch (e) {
  //         logDebug('Error parsing JSON: $e');
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Unexpected response format from server.')),
  //         );
  //       }
  //     } else {
  //       logDebug('Server error: ${response.statusCode}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Server error, please try again later.')),
  //       );
  //     }
  //   } else {
  //     logDebug('Form validation failed. Please correct the errors.');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please fix the errors in the form')),
  //     );
  //   }
  // }

  // Future<File> _processImage(File imageFile) async {
  //   // Read the image file
  //   final bytes = await imageFile.readAsBytes();
  //   final image = img.decodeImage(bytes);
  //
  //   if (image != null) {
  //     // If the image is in portrait mode, rotate it to landscape
  //     if (image.height > image.width) {
  //       // Rotate the image 90 degrees clockwise
  //       final rotatedImage = img.copyRotate(image, angle: 90);
  //       // Encode the rotated image back to bytes
  //       final newBytes = img.encodePng(rotatedImage);
  //       // Write the new image back to the file
  //       await imageFile.writeAsBytes(newBytes);
  //       logDebug('Image converted to landscape mode.');
  //     }
  //   }
  //
  //   return imageFile; // Return the original or processed file
  // }

  void _validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data...')),
      );

      // Prepare the data
      final name = _studentNameController.text;
      final serialNo = _serialNumberController.text;
      final contact = _contactDetailsController.text;
      final aadharNo = _aadharNumberController.text;
      final address = _addressController.text;
      final startDate = _startDateController.text; // Keep as string for API
      final endDate = _endDateController.text; // Keep as string for API
      final fee = _feesController.text;
      final feeWord = _feesWordController.text;
      final seatNo = _setNumberController.text.toString();
      final paymentMode = _paymentMode;
      final empCode = _employeeCodeController.text;

      // Retrieve userId from SharedPreferences
      final userId = await SharedPreferencesHelper.getUserId();
      logDebug('User ID retrieved: $userId');

      if (userId == null) {
        logDebug('User ID is null, cannot proceed with registration.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID is missing. Registration cannot proceed.')),
        );
        return;
      }

      // Check if images are provided
      if (_profileImageFile == null || _aadharFrontImageFile == null || _aadharBackImageFile == null) {
        logDebug('Image files are missing. Please provide all images.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload all required images.')),
        );
        return;
      }

      // Process images for orientation
      // _profileImageFile = await _processImage(_profileImageFile!);
      // _aadharFrontImageFile = await _processImage(_aadharFrontImageFile!);
      // _aadharBackImageFile = await _processImage(_aadharBackImageFile!);

      // Log all data before API call
      logDebug('Registration Data:');
      logDebug('Name: $name');
      logDebug('Serial No: $serialNo');
      logDebug('Contact: $contact');
      logDebug('Aadhar No: $aadharNo');
      logDebug('Address: $address');
      logDebug('Start Date: $startDate');
      logDebug('End Date: $endDate');
      logDebug('Fee: $fee');
      logDebug('Fee in words: $feeWord');
      logDebug('User ID: $userId');
      logDebug('Seat No: $seatNo');
      logDebug('Payment Mode: $paymentMode');
      logDebug('Employee Code: $empCode');
      logDebug('Profile Image Path: ${_profileImageFile?.path}');
      logDebug('Aadhar Front Image Path: ${_aadharFrontImageFile?.path}');
      logDebug('Aadhar Back Image Path: ${_aadharBackImageFile?.path}');

      // Parse the input dates from 'dd-MM-yyyy' to DateTime
      DateTime parsedStartDate = DateFormat('dd-MM-yyyy').parse(startDate);
      DateTime parsedEndDate = DateFormat('dd-MM-yyyy').parse(endDate);

      // Format the dates to 'yyyy-MM-dd'
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(parsedStartDate);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(parsedEndDate);

      // Create a Map for the request body
      final requestBody = {
        'name': name,
        'serial_no': serialNo,
        'contact': contact,
        'aadhar_no': aadharNo,
        'address': address,
        'start_date': formattedStartDate, // Use formatted date
        'end_date': formattedEndDate,       // Use formatted date
        'fee': fee.toString(),
        'user_id': userId.toString(),
        'seat_no': seatNo,
        'payment_mode': paymentMode,
        'Empcode': empCode,
        'fees_in_word': feeWord,
      };

      // Log the request body
      logDebug('Request Body: ${requestBody.toString()}');

      // API call to register student using multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.demoregisterApi),
      );

      // Add form fields
      request.fields.addAll(requestBody);
      logDebug('Form fields added to request.');

      // Add image files
      if (_profileImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          _profileImageFile!.path,
          contentType: MediaType('image', 'png'),
        ));
        logDebug('Profile image added to request.');
      }
      if (_aadharFrontImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'aadhar_front',
          _aadharFrontImageFile!.path,
          contentType: MediaType('image', 'png'),
        ));
        logDebug('Aadhar front image added to request.');
      }
      if (_aadharBackImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'aadhar_back',
          _aadharBackImageFile!.path,
          contentType: MediaType('image', 'png'),
        ));
        logDebug('Aadhar back image added to request.');
      }

      // Send the request
      final response = await request.send();
      logDebug('API request sent, waiting for response.');

      // Log the response status code
      logDebug('Response status code on registration page: ${response.statusCode}');

      // Handle response
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        logDebug('Response received from server.');

        // Log the response body for debugging
        logDebug('Response body on demo registration page: ${responseData.body}');

        try {
          // Attempt to parse JSON after stripping out HTML
          var responseBody = responseData.body;
          if (responseBody.contains('<')) {
            responseBody = responseBody.replaceAll(RegExp(r'<[^>]*>'), '');
            logDebug('Response body cleaned of HTML.');
          }
          logDebug('Parsed response body: $responseBody');

          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

          if (jsonResponse['status'] == 'success') {
            final studentId = jsonResponse['student_id'];
            logDebug('Registration successful: Student ID = $studentId');

            try {
              Navigator.pushNamed(
                context,
                AppRoutes.demoSuccessRegistration,
                arguments: {
                  'studentId': studentId,
                  'requestBody': requestBody,
                  'images': {
                    'profileImage': _profileImageFile!.path,
                    'aadharFrontImage': _aadharFrontImageFile!.path,
                    'aadharBackImage': _aadharBackImageFile!.path,
                  },
                },
              );
              logDebug('Navigated to registration success page.');
            } catch (e) {
              logDebug('Error during navigation: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navigation failed: $e')),
              );
            }
          } else {
            logDebug('Registration failed: ${jsonResponse['message']}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration Failed: ${jsonResponse['message']}')),
            );
          }
        } catch (e) {
          logDebug('Error parsing JSON: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unexpected response format from server.')),
          );
        }
      } else {
        logDebug('Server error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error, please try again later.')),
        );
      }
    } else {
      logDebug('Form validation failed. Please correct the errors.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fix the errors in the form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(
          'Student Registration',
          style: LexendtextFont500.copyWith(
            fontSize: 16.sp,
            color: AppColor.textcolorBlack,
          ),
        ),
        backgroundColor: AppColor.whiteColor,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              ],
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Image Picker
              ImagePickerWidget(
                onImagePicked: (file) {
                  setState(() {
                    _profileImageFile = file; // Update the profile image file
                  });
                  print('Profile Image: ${file?.path}');
                },
              ),
              // if (_profileImageFile != null)
              //   Image.file(
              //     _profileImageFile!,
              //     // width: 100,
              //     // height: 100,
              //     // fit: BoxFit.cover,
              //   )
              // else
              //   const Text('No image selected.'),

              SizedBox(height: 20.h),
              RegistrationTextFormField(
                controller: _employeeCodeController,
                hintText: 'Device Code',
                focusNode: _employeeCodeFocus,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter the device code' : null,
                maxLength: 4,
              ),
              SizedBox(height: 16.h),
              RegistrationTextFormField(
                controller: _studentNameController,
                hintText: 'Student Name',
                focusNode: _studentNameFocus,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter the student name' : null,
                maxLength: 30,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(_startDateController),
                      child: AbsorbPointer(
                        child: RegistrationTextFormField(
                          controller: _startDateController,
                          hintText: 'Start Date',
                          focusNode: _startDateFocus,
                          validator: (value) => (value == null || value.isEmpty) ? 'Please enter the start date' : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(_endDateController),
                      child: AbsorbPointer(
                        child: RegistrationTextFormField(
                          controller: _endDateController,
                          hintText: 'End Date',
                          focusNode: _endDateFocus,
                          validator: (value) => (value == null || value.isEmpty) ? 'Please enter the end date' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              RegistrationTextFormField(
                controller: _setNumberController,
                hintText: 'Seat number',
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

                  final numberValue = int.parse(value); // Parse here since we've validated it as a number

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
                controller: _feesController,
                hintText: 'Fees',
                focusNode: _feesFocus,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter the fees' : null,
                maxLength: 4,
              ),
              SizedBox(height: 16.h),
              RegistrationTextFormField(
                controller: _feesWordController,
                hintText: 'Fees Amount in Words',
                focusNode: _feesWordFocus,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter the fees amount in words.'
                    : null,
                maxLength: 80,
              ),
              SizedBox(height: 16.h),
              Text(
                'Payment Mode:',
                style: LexendtextFont500.copyWith(
                  fontSize: 14.sp,
                  color: AppColor.textcolorBlack,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'Cash',
                    groupValue: _paymentMode,
                    onChanged: (value) => setState(() => _paymentMode = value!),
                  ),
                  Text('Cash'),
                  Radio<String>(
                    value: 'Online',
                    groupValue: _paymentMode,
                    onChanged: (value) => setState(() => _paymentMode = value!),
                  ),
                  Text('Online'),
                ],
              ),
              SizedBox(height: 16.h),
              RegistrationTextFormField(
                controller: _serialNumberController,
                hintText: 'Serial Number',
                focusNode: _serialNumberFocus,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter the serial number' : null,
                maxLength: 10,
              ),
              SizedBox(height: 16.h),
              RegistrationTextFormField(
                controller: _contactDetailsController,
                hintText: 'Contact Details',
                focusNode: _contactDetailsFocus,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter contact details';
                  final numericRegex = RegExp(r'^\d+$');
                  if (!numericRegex.hasMatch(value)) return 'Please enter a valid number';
                  if (value.length < 10 ) return 'Please enter a valid mobile number ';
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
                  if (value == null || value.isEmpty) return 'Please enter the Aadhar number';
                  final digitsOnly = RegExp(r'^\d+$');
                  if (!digitsOnly.hasMatch(value)) return 'Aadhar number must be numeric';
                  if (value.length != 12) return 'Aadhar number must be 12 digits long';
                  return null;
                },
                maxLength: 12,
              ),
              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageWidget(_aadharFrontImageFile, 'assets/images/front-adhacard.jpg', () => _pickImage(true)),
                  _buildImageWidget(_aadharBackImageFile, 'assets/images/back-adhacard.jpg', () => _pickImage(false)),
                ],
              ),

              SizedBox(height: 16.h),
              RegistrationTextFormField(
                controller: _addressController,
                hintText: 'Address',
                focusNode: _addressFocus,
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter the address' : null,
              ),
              SizedBox(height: 20.h),
              SubmitButton(onPressed: _validateAndSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

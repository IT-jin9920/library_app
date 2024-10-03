import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_app/res/app_url/app_url.dart';
import 'package:library_app/res/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'demo.dart';
import 'features/available_students/data/student_repository.dart';
import 'features/available_students/domain/student_view_model.dart';
import 'features/home_page/Superadmin/ViewModel/student_dashboard_viewmodel.dart';
import 'features/home_page/Superadmin/data/student_dashboard_repository.dart';
import 'features/home_page/Superwiser/ViewModel/superwiser_student_dashboard_viewmodel.dart';
import 'features/home_page/Superwiser/data/SuperwiserStudentDashboardRepository.dart';
import 'features/login/data/login_repository.dart';
import 'features/login/view_models/login_usecase.dart';

import 'features/notification/ViewModel/NotificationViewModel.dart';
import 'features/notification/ViewModel/home_notification_viewmodel.dart';
import 'features/payment/ViewModal/PrintPaymentViewModel.dart';
import 'features/records/student_record/view_modal_studentrecord/student_record_view_model.dart';
import 'features/records/student_record_details/Widgets/data/subscription_repository.dart';
import 'features/records/student_record_details/Widgets/ViewModel/subscription_view_model.dart';
import 'features/records/student_record_details/student_details_view_model/student_details_view_model.dart';
import 'features/registration/data/registration_repository.dart';
import 'features/registration/presentation/viewmodels/registration_view_model.dart';
import 'features/report/domain/student_report_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => LoginViewModel(
        //       AuthRepository()), // Ensure AuthRepository is correctly implemented
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => RegistrationViewModel(
        //       RegistrationRepository()), // Ensure RegistrationRepository is correctly implemented
        // ),
        ChangeNotifierProvider(
          create: (context) =>
              StudentReportViewModel(), // Ensure StudentReportViewModel is correctly implemented
        ),
        ChangeNotifierProvider(
          create: (context) =>
              StudentRecordViewModel(), // Ensure StudentRecordViewModel is correctly implemented
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NotificationViewModel(), // Ensure NotificationViewModel is correctly implemented
        ),
        ChangeNotifierProvider(
          create: (context) =>
              HomeNotificationViewModel(), // Ensure NotificationViewModel is correctly implemented
        ),
        ChangeNotifierProvider(
          create: (context) => StudentViewModel(context.read<
              StudentRepository>()), // Ensure StudentViewModel is correctly implemented
        ),
        Provider(
          create: (_) =>
              StudentRepository(), // Ensure StudentRepository is correctly implemented
        ),
        ChangeNotifierProvider(
          create: (context) => StudentViewModel(context.read<
              StudentRepository>()), // Ensure StudentViewModel is correctly implemented
        ),
        ChangeNotifierProvider(
          create: (context) => StudentDashboardViewModel(),
        ),
        Provider<SupervisorStudentDashboardRepository>(
          create: (_) => SupervisorStudentDashboardRepository(),
        ),
        ChangeNotifierProvider<SupervisorStudentDashboardViewModel>(
          create: (context) => SupervisorStudentDashboardViewModel(
            Provider.of<SupervisorStudentDashboardRepository>(context,
                listen: false),
          ),
        ),

        ChangeNotifierProvider(create: (_) => StudentDetailsViewModel()),
        ChangeNotifierProvider(
          create: (context) => SubscriptionViewModel(
            SubscriptionRepository(),
          ),
        ),

        ChangeNotifierProvider(create: (_) => PrintPaymentViewModel()),

        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Library App',
           // initialRoute: AppRoutes.registration,
             initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.generateRoute,
            //home: Demo(),
          );
        },
      ),
    );
  }
}





// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:library_app/features/records/student_record_details/Widgets/data/subscription_repository.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         highlightColor: const Color(0xFFD0996F),
//         canvasColor: const Color(0xFFFDF5EC),
//         textTheme: TextTheme(
//           headlineSmall: ThemeData.light()
//               .textTheme
//               .headlineSmall!
//               .copyWith(color: const Color(0xFFBC764A)),
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.grey[600],
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xFFBC764A),
//           centerTitle: false,
//           foregroundColor: Colors.white,
//           actionsIconTheme: IconThemeData(color: Colors.white),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ButtonStyle(
//             backgroundColor: WidgetStateColor.resolveWith(
//                     (states) => const Color(0xFFBC764A)),
//             foregroundColor: WidgetStateColor.resolveWith(
//                   (states) => Colors.white,
//             ),
//           ),
//         ),
//         outlinedButtonTheme: OutlinedButtonThemeData(
//           style: ButtonStyle(
//             foregroundColor: WidgetStateColor.resolveWith(
//                   (states) => const Color(0xFFBC764A),
//             ),
//             side: WidgetStateBorderSide.resolveWith(
//                     (states) => const BorderSide(color: Color(0xFFBC764A))),
//           ),
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: ButtonStyle(
//             foregroundColor: WidgetStateColor.resolveWith(
//                   (states) => const Color(0xFFBC764A),
//             ),
//           ),
//         ),
//         iconButtonTheme: IconButtonThemeData(
//           style: ButtonStyle(
//             foregroundColor: WidgetStateColor.resolveWith(
//                   (states) => const Color(0xFFBC764A),
//             ),
//           ),
//         ),
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           background: const Color(0xFFFDF5EC),
//           primary: const Color(0xFFD0996F),
//         ),
//       ),
//       home: const HomePage(title: 'Image Cropper Demo'),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   final String title;
//
//   const HomePage({
//     Key? key,
//     required this.title,
//   }) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   XFile? _pickedFile;
//   CroppedFile? _croppedFile;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: !kIsWeb ? AppBar(title: Text(widget.title)) : null,
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (kIsWeb)
//             Padding(
//               padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
//               child: Text(
//                 widget.title,
//                 style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).highlightColor),
//               ),
//             ),
//           Expanded(child: _body()),
//         ],
//       ),
//     );
//   }
//
//   Widget _body() {
//     if (_croppedFile != null || _pickedFile != null) {
//       return _imageCard();
//     } else {
//       return _uploaderCard();
//     }
//   }
//
//   Widget _imageCard() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
//             child: Card(
//               elevation: 4.0,
//               child: Padding(
//                 padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
//                 child: _image(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24.0),
//           _menu(),
//         ],
//       ),
//     );
//   }
//
//   Widget _image() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     if (_croppedFile != null) {
//       final path = _croppedFile!.path;
//       return ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 0.8 * screenWidth,
//           maxHeight: 0.7 * screenHeight,
//         ),
//         child: kIsWeb ? Image.network(path) : Image.file(File(path)),
//       );
//     } else if (_pickedFile != null) {
//       final path = _pickedFile!.path;
//       return ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 0.8 * screenWidth,
//           maxHeight: 0.7 * screenHeight,
//         ),
//         child: kIsWeb ? Image.network(path) : Image.file(File(path)),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
//
//   Widget _menu() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FloatingActionButton(
//           onPressed: () {
//             _clear();
//           },
//           backgroundColor: Colors.redAccent,
//           tooltip: 'Delete',
//           child: const Icon(Icons.delete),
//         ),
//         if (_croppedFile == null)
//           Padding(
//             padding: const EdgeInsets.only(left: 32.0),
//             child: FloatingActionButton(
//               onPressed: () {
//                 _cropImage();
//               },
//               backgroundColor: const Color(0xFFBC764A),
//               tooltip: 'Crop',
//               child: const Icon(Icons.crop),
//             ),
//           ),
//         Padding(
//           padding: const EdgeInsets.only(left: 32.0),
//           child: FloatingActionButton(
//             onPressed: () {
//               //_saveImage();
//               logDebug('tap on sav img...');
//             },
//             backgroundColor: Colors.green,
//             tooltip: 'Save',
//             child: const Icon(Icons.save),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _uploaderCard() {
//     return Center(
//       child: Card(
//         elevation: 4.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: SizedBox(
//           width: kIsWeb ? 380.0 : 320.0,
//           height: 300.0,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: DottedBorder(
//                     radius: const Radius.circular(12.0),
//                     borderType: BorderType.RRect,
//                     dashPattern: const [8, 4],
//                     color: Theme.of(context).highlightColor.withOpacity(0.4),
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.image,
//                             color: Theme.of(context).highlightColor,
//                             size: 80.0,
//                           ),
//                           const SizedBox(height: 24.0),
//                           Text(
//                             'Upload an image to start',
//                             style: kIsWeb
//                                 ? Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).highlightColor)
//                                 : Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).highlightColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 24.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         _uploadImage(ImageSource.gallery);
//                       },
//                       style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
//                       child: const Text('Upload Gallery'),
//                     ),
//                     const SizedBox(width: 16.0),
//                     ElevatedButton(
//                       onPressed: () {
//                         _uploadImage(ImageSource.camera);
//                       },
//                       style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
//                       child: const Text('Take a Photo'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _cropImage() async {
//     if (_pickedFile != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: _pickedFile!.path,
//         compressFormat: ImageCompressFormat.jpg,
//         compressQuality: 100,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.square,
//             lockAspectRatio: false,
//             aspectRatioPresets: [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPresetCustom(),
//             ],
//           ),
//           IOSUiSettings(
//             title: 'Cropper',
//             aspectRatioPresets: [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPresetCustom(),
//             ],
//           ),
//           WebUiSettings(
//             context: context,
//             presentStyle: WebPresentStyle.dialog,
//             size: const CropperSize(
//               width: 520,
//               height: 520,
//             ),
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         setState(() {
//           _croppedFile = croppedFile;
//         });
//       }
//     }
//   }
//
//   Future<void> _uploadImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _pickedFile = pickedFile;
//       });
//     }
//   }
//
//   // Future<void> _saveImage() async {
//   //   if (_croppedFile != null) {
//   //     // Here, implement your API request using the cropped image
//   //     // Example:
//   //     try {
//   //       final request = http.MultipartRequest('POST', Uri.parse('YOUR_API_URL'));
//   //
//   //       request.files.add(await http.MultipartFile.fromPath(
//   //         'photo',
//   //         _croppedFile!.path,
//   //         contentType: MediaType('image', 'jpg'), // Adjust content type if needed
//   //       ));
//   //
//   //       // Send the request
//   //       final response = await request.send();
//   //       if (response.statusCode == 200) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(content: Text('Image uploaded successfully!')),
//   //         );
//   //       } else {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(content: Text('Failed to upload image.')),
//   //         );
//   //       }
//   //     } catch (e) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Error: $e')),
//   //       );
//   //     }
//   //   }
//   // }
//
//   void _clear() {
//     setState(() {
//       _pickedFile = null;
//       _croppedFile = null;
//     });
//   }
// }
//
// class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
//   @override
//   (int, int)? get data => (2, 3);
//
//   @override
//   String get name => '2x3 (customized)';
// }

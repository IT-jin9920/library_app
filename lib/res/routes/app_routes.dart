// import 'package:flutter/material.dart';
// import '../../features/available_students/presentation/screens/available_student_screen.dart';
// import '../../features/home_page/Accountant/accountant_home_page.dart';
// import '../../features/home_page/home_page.dart';
// import '../../features/home_page/Superadmin/super_admin_home_page.dart';
// import '../../features/home_page/Superwiser/supervisor_home_page.dart';
// import '../../features/login/presentation/screens/login_screen.dart';
//
// import '../../features/notification/notification.dart';
// import '../../features/payment/presentation/screens/print_payment_screen.dart';
// import '../../features/records/student_record_details/student_details_page.dart';
// import '../../features/records/student_record_edit/student_record_edit.dart';
// import '../../features/records/student_record/students_record.dart';
// import '../../features/registration/presentation/screens/registration_screen.dart';
// import '../../features/report/presentation/screens/student_report_screen.dart';
// import '../../features/splash/presentation/screens/splash_screen.dart';
// import '../../features/student_record_page/presentation/available_student_record_page.dart';
// import '../../features/student_register_demo/Screen/student_register_demo.dart';
// import '../../features/success/success_registration_screen.dart';
// import '../../features/success/success_student_details_screen.dart';
//
// class AppRoutes {
//   static const String splash = '/splash';
//   static const String login = '/login';
//   static const String home = '/home';
//   static const String registration = '/registration';
//   static const String studentRegisterDemo = '/studentRegisterDemo';
//   static const String printPaymentScreen = '/printPaymentScreen';
//   static const String studentReportScreen = '/studentReportScreen';
//   static const String studentRecordScreen = '/studentRecordScreen';
//   static const String registrationSuccess = '/registrationSuccess';
//   static const String studentDetailsSuccess = '/studentDetailsSuccess';
//   static const String demoSuccessRegistration = '/demoSuccessRegistration';
//
//   static const String studentsdetails = '/studentsdetails';
//   static const String studentDetailsEdit = '/studentDetailsEdit';
//   static const String availableStudents = '/available_students';
//   static const String notification = '/Notification';
//   static const String availableStudentRecordPage = '/available_student_record_page';
//
//   static const String superAdminHome = '/super_admin_home';
//   static const String supervisorHome = '/supervisor_home';
//   static const String accountantHome = '/accountant_home';
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case splash:
//         return MaterialPageRoute(builder: (_) => SplashScreen());
//       case login:
//         return MaterialPageRoute(builder: (_) => LoginScreen());
//       case home:
//         return MaterialPageRoute(builder: (_) => HomePage());
//       case superAdminHome:
//         return MaterialPageRoute(builder: (_) => SuperAdminHomePage());
//       case supervisorHome:
//         return MaterialPageRoute(builder: (_) => SupervisorHomePage());
//       case accountantHome:
//         return MaterialPageRoute(builder: (_) => AccountantHomePage());
//       case notification:
//         return MaterialPageRoute(builder: (_) => NotificationPage());
//       case registration:
//         return MaterialPageRoute(builder: (_) => RegistrationScreen());
//       case studentRegisterDemo: // New case for StudentRegisterDemo
//         return MaterialPageRoute(builder: (_) => StudentRegisterDemo());
//
//       case registrationSuccess:
//         final args = settings.arguments as Map<String, dynamic>?; // Expecting a Map here
//         if (args != null) {
//           final studentId = args['studentId'] as String;
//           final requestBody = args['requestBody'] as Map<String, dynamic>;
//           final images = args['images'] as Map<String, String>;
//
//           return MaterialPageRoute(
//             builder: (_) => SuccessRegistrationScreen(
//               studentId: studentId,
//               requestBody: requestBody,
//               images: images,
//             ),
//           );
//         } else {
//           return _errorRoute();
//         }
//
//       case availableStudents:
//         return MaterialPageRoute(builder: (_) => AvailableStudentScreen());
//       case studentDetailsEdit:
//         final int? studentId = settings.arguments as int?;
//         return MaterialPageRoute(
//           builder: (_) => StudentRecordEdit(studentId: studentId),
//         );
//       case studentsdetails:
//         try {
//           final int studentId = settings.arguments is int
//               ? settings.arguments as int
//               : int.tryParse(settings.arguments as String ?? '') ?? 0;
//           return MaterialPageRoute(
//             builder: (_) => StudentDetailsPage(studentId: studentId),
//           );
//         } catch (e) {
//           // Handle any errors and return an error route
//           return _errorRoute();
//         }
//       case studentDetailsSuccess:
//       // Ensure arguments are passed correctly
//         final args = settings.arguments as Map<String, dynamic>?;
//         if (args != null) {
//           final studentId = args['studentId'] as int;
//           final studentName = args['studentName'] as String;
//           final startDate = args['startDate'] as String;
//           final endDate = args['endDate'] as String;
//           final fees = args['fees'] as String;
//           final feeWord = args['fees_in_word'] as String;
//           final paymentMode = args['payment_mode'] as String;
//
//           return MaterialPageRoute(
//             builder: (_) => SuccessStudentDetailsScreen(
//               studentId: studentId,
//               studentName: studentName,
//               startDate: startDate,
//               endDate: endDate,
//               fees: fees,
//               feeWord: feeWord,
//                 payment_mode: paymentMode,
//             ),
//           );
//         } else {
//           // Handle the case where arguments are null or invalid
//           return _errorRoute();
//         }
//       case printPaymentScreen:
//         return MaterialPageRoute(builder: (_) => PrintPaymentScreen());
//       case studentReportScreen:
//         return MaterialPageRoute(builder: (_) => StudentReportScreen());
//       case studentRecordScreen:
//         return MaterialPageRoute(builder: (_) => StudentsRecord());
//       case availableStudentRecordPage:
//         return MaterialPageRoute(builder: (_) => AvailableStudentRecordPage());
//       default:
//         return _errorRoute();
//     }
//   }
//
//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(
//       builder: (_) => Scaffold(
//         appBar: AppBar(
//           title: Text('Error'),
//         ),
//         body: Center(
//           child: Text('Page not found'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../features/available_students/presentation/screens/available_student_screen.dart';
import '../../features/home_page/Accountant/accountant_home_page.dart';
import '../../features/home_page/home_page.dart';
import '../../features/home_page/Superadmin/super_admin_home_page.dart';
import '../../features/home_page/Superwiser/supervisor_home_page.dart';
import '../../features/login/presentation/screens/login_screen.dart';
import '../../features/notification/notification.dart';
import '../../features/payment/presentation/screens/print_payment_screen.dart';
import '../../features/records/student_record_details/student_details_page.dart';
import '../../features/records/student_record_edit/student_record_edit.dart';
import '../../features/records/student_record/students_record.dart';
import '../../features/registration/presentation/screens/registration_screen.dart';
import '../../features/report/presentation/screens/student_report_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/student_record_page/presentation/available_student_record_page.dart';
import '../../features/student_register_demo/Screen/student_register_demo.dart';
import '../../features/success/demo_success_registration_screen.dart';
import '../../features/success/success_registration_screen.dart';
import '../../features/success/success_student_details_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String registration = '/registration';
  static const String studentRegisterDemo = '/studentRegisterDemo';
  static const String printPaymentScreen = '/printPaymentScreen';
  static const String studentReportScreen = '/studentReportScreen';
  static const String studentRecordScreen = '/studentRecordScreen';
  static const String registrationSuccess = '/registrationSuccess';
  static const String studentDetailsSuccess = '/studentDetailsSuccess';
  static const String demoSuccessRegistration = '/demoSuccessRegistration';
  static const String studentsdetails = '/studentsdetails';
  static const String studentDetailsEdit = '/studentDetailsEdit';
  static const String availableStudents = '/available_students';
  static const String notification = '/Notification';
  static const String availableStudentRecordPage = '/available_student_record_page';
  static const String superAdminHome = '/super_admin_home';
  static const String supervisorHome = '/supervisor_home';
  static const String accountantHome = '/accountant_home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(SplashScreen());
      case login:
        return _buildRoute(LoginScreen());
      case home:
        return _buildRoute(HomePage());
      case superAdminHome:
        return _buildRoute(SuperAdminHomePage());
      case supervisorHome:
        return _buildRoute(SupervisorHomePage());
      case accountantHome:
        return _buildRoute(AccountantHomePage());
      case notification:
        return _buildRoute(NotificationPage());
      case registration:
        return _buildRoute(RegistrationScreen());
      case studentRegisterDemo:
        return _buildRoute(StudentRegisterDemo());
      case demoSuccessRegistration:
        return _handleDemoSuccessRegistration(settings.arguments);
      case registrationSuccess:
        return _handleRegistrationSuccess(settings.arguments);
      case availableStudents:
        return _buildRoute(AvailableStudentScreen());
      case studentDetailsEdit:
        return _handleStudentDetailsEdit(settings.arguments);
      case studentsdetails:
        return _handleStudentDetails(settings.arguments);
      case studentDetailsSuccess:
        return _handleStudentDetailsSuccess(settings.arguments);
      case printPaymentScreen:
        return _buildRoute(PrintPaymentScreen());
      case studentReportScreen:
        return _buildRoute(StudentReportScreen());
      case studentRecordScreen:
        return _buildRoute(StudentsRecord());
      case availableStudentRecordPage:
        return _buildRoute(AvailableStudentRecordPage());
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  static Route<dynamic> _handleStudentDetailsEdit(dynamic arguments) {
    if (arguments is int?) {
      return _buildRoute(StudentRecordEdit(studentId: arguments));
    }
    return _errorRoute();
  }

  static Route<dynamic> _handleStudentDetails(dynamic arguments) {
    try {
      final int studentId = arguments is int
          ? arguments
          : int.tryParse(arguments as String) ?? 0;
      return _buildRoute(StudentDetailsPage(studentId: studentId));
    } catch (e) {
      return _errorRoute();
    }
  }

  static Route<dynamic> _handleRegistrationSuccess(dynamic arguments) {
    final args = arguments as Map<String, dynamic>?;
    if (args != null) {
      return MaterialPageRoute(
        builder: (_) => SuccessRegistrationScreen(
          studentId: args['studentId'],
          requestBody: args['requestBody'],
          images: args['images'],
        ),
      );
    }
    return _errorRoute();
  }

  static Route<dynamic> _handleDemoSuccessRegistration(dynamic arguments) {
    final args = arguments as Map<String, dynamic>?; // Ensure proper casting
    if (args != null) {
      return MaterialPageRoute(
        builder: (_) => DemoSuccessRegistrationScreen( // Replace with your actual screen
          studentId: args['studentId'],
          requestBody: args['requestBody'],
          images: args['images'],
        ),
      );
    }
    return _errorRoute();
  }

  static Route<dynamic> _handleStudentDetailsSuccess(dynamic arguments) {
    final args = arguments as Map<String, dynamic>?;
    if (args != null) {
      return MaterialPageRoute(
        builder: (_) => SuccessStudentDetailsScreen(
          studentId: args['studentId'],
          studentName: args['studentName'],
          startDate: args['startDate'],
          endDate: args['endDate'],
          fees: args['fees'],
          feeWord: args['fees_in_word'],
          payment_mode: args['payment_mode'],
        ),
      );
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}

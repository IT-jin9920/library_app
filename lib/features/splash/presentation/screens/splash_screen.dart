import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:library_app/res/colors/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after a delay
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(Duration(seconds: 3), () {
    //     Navigator.pushReplacementNamed(context, AppRoutes.login);
    //   });
    // });

    _checkUserSession();
  }

  // Function to check if the user is logged in
  Future<void> _checkUserSession() async {
    try {
      // Add a delay to simulate a splash screen effect
      await Future.delayed(Duration(seconds: 3));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      final String? userType = prefs.getString('user_type');

      // Check if the user is logged in and has a user type
      if (userId != null && userType != null) {
        String route;
        // Determine the page based on user type
        switch (userType) {
          case 'Superwiser':
            route = AppRoutes.supervisorHome;
            break;
          case 'Accountant':
            route = AppRoutes.accountantHome;
            break;
          case 'Superadmin':
            route = AppRoutes.superAdminHome;
            break;
          default:
            route = AppRoutes.availableStudents;
            break;
        }
        Navigator.pushReplacementNamed(context, route); // Navigate to the appropriate screen
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login); // Navigate to the login screen
      }
    } catch (e) {
      // Handle any errors that occur during the session check
      print('Error checking user session: $e');
      Navigator.pushReplacementNamed(context, AppRoutes.login); // Fallback to login screen on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 56,
          ),
          child: Image.asset(
            'assets/images/welcom-logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

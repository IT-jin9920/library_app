import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../res/fonts/text_style.dart';
import '../../../../res/routes/app_routes.dart';
import '../../../../utils/logger.dart';
import '../../data/login_repository.dart';
import '../widgets/login_button.dart';
import '../widgets/login_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false; // Local loading state
  String? _errorMessage; // Local error message
  String? _navigationRoute; // Local navigation route

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      setState(() {
        _isLoading = true; // Start loading
        _errorMessage = null; // Reset error message
      });

      print('Attempting to login with email: $email'); // Log email input
      try {
        final loginResponse = await AuthRepository().login(email, password);
        print('Login API response: ${loginResponse.toString()}'); // Log the entire response

        logDebug('Login successful: ${loginResponse.message}');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', loginResponse.data.id);
        await prefs.setString('user_type', loginResponse.data.type);

        print('User ID: ${loginResponse.data.id}, User Type: ${loginResponse.data.type}'); // Log user details

        // Set navigation route based on user type
        _navigationRoute = _getNavigationRoute(loginResponse.data.type);
        if (_navigationRoute == null) {
          _navigationRoute = AppRoutes.superAdminHome; // Fallback for unknown types
          print('Unknown user type. Defaulting to /super_admin_home');
        }

        print('Navigating to: $_navigationRoute'); // Log navigation route

        // Navigate to the next screen
        Navigator.pushNamedAndRemoveUntil(context, _navigationRoute!, (route) => false);
      } catch (e) {
        _errorMessage = e.toString();
        logDebug('Error during login: $e');
        print('Caught error during login: $_errorMessage'); // Log error message

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage!)));
        }
      } finally {
        setState(() {
          _isLoading = false; // End loading
        });
        print('Loading ended.'); // Log loading state
      }
    } else {
      print('Form validation failed.'); // Log validation failure
    }
  }

// Helper method to get the navigation route based on user type
  String? _getNavigationRoute(String userType) {
    switch (userType) {
      case 'Accountant':
        return AppRoutes.accountantHome;
      case 'Superadmin':
        return AppRoutes.superAdminHome;
      case 'Superwiser': // New case for Superwiser
        return AppRoutes.supervisorHome; // Update with the correct route
      default:
        return AppRoutes.availableStudents; // Return null for unknown user types
    }
  }


  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_type');
      logDebug('User session cleared.');

      // Navigate to the login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      logDebug('Logout error: $e');
      // Optionally show a Snackbar with the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Image.asset("assets/images/login-img.png"),
                    SizedBox(height: 20),
                    Text("Welcome Back!", style: LexendtextFont500.copyWith(fontSize: 20)),
                    SizedBox(height: 5),
                    Text("Sign in to your account using your ID and Password",
                        style: LexendtextFont300.copyWith(fontSize: 13, color: AppColor.textcolorSilver)),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoginTextFormField(
                            controller: _emailController,
                            hintText: 'User ID',
                            focusNode: _emailFocusNode,
                            onFieldSubmittedCallback: () {
                              FocusScope.of(context).requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          LoginTextFormField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: _obscurePassword,
                            focusNode: _passwordFocusNode,
                            toggleObscureText: _togglePasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          LoginButton(onPressed: _login),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator (
                    color: AppColor.btncolor,
                  ),
                 // child: SpinKitFadingCircle(color: AppColor.btncolor, size: 50.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

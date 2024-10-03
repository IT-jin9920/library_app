// models/login_model.dart
import 'dart:convert';

class LoginModel {
  final String status;
  final String message;
  final UserData data;

  LoginModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String password;
  final String type;

  UserData({
    required this.id,
    required this.email,
    required this.password,
    required this.type,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      type: json['type'],
    );
  }
}

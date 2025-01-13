import 'package:flutter/material.dart';

class AppColors {
  static const backgroundColor = Color(0xFF181C14);
  static const mainColor = Color(0xFFE94057);
  static const secondaryColor = Color.fromARGB(255, 143, 1, 44);
  static const textColor = Color(0xFFECDFCC);

  static const gradient = LinearGradient(
    colors: [
      Color(0xFFE94057),
      Color.fromARGB(255, 143, 1, 44),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class Validators {
  static String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w|.-]+@[\w-]+\.\w{2,3}(?:\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    } else if (phoneNumber.length != 11) {
      return 'Phone number must be 11 digits';
    } else if (!phoneNumber.startsWith('09')) {
      return 'Phone number must start with "09"';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Required';
    } else if (name.length < 2) {
      return 'Input must be at least 2 characters';
    }
    return null;
  }

  static String? validateBirth(String? birth) {
    if (birth == null || birth.isEmpty) {
      return 'Date of birth is required';
    }
    return null;
  }
}

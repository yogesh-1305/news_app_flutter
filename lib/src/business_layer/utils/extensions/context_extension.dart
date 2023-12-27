import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  void showFailureSnackBar({String message = "Something went wrong"}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  /// navigate to the route
  Future<dynamic> push(Widget screen) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// navigate to the route and replace the current screen
  Future<dynamic> pushReplacement(Widget screen) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void pop() {
    return Navigator.pop(this);
  }

  /// navigate to the route and remove all the previous screen
  Future<dynamic> pushAndRemoveUntil(Widget screen) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }
}

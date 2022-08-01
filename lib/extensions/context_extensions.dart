import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  /// Convenient extension method for showing a [SnackBar] with provided [message].
  void showSnackBar(String message) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(message),
      ));
}

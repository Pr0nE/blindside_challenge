import 'package:blindside_challenge/helpers/fade_page_route.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void showSnackBar(String message) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(message),
      ));
}

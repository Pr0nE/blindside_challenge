import 'package:flutter/material.dart';

import 'package:blindside_challenge/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

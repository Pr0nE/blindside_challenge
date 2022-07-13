import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:blindside_challenge/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

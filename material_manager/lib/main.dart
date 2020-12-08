import 'package:flutter/material.dart';
import 'package:material_manager/district/View.dart';

void main() {
  runApp(new HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material Manager',
      home: new LoginUser(),
    );
  }
}

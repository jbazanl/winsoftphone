import 'package:flutter/material.dart';
import 'screens/dialer_screen.dart';

void main() {
  runApp(SoftphoneApp());
}

class SoftphoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Softphone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DialerScreen(),
    );
  }
}

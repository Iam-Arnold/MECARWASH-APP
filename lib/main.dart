import 'package:flutter/material.dart';
import './theme/theme.dart';
import 'screens/home.dart';

void main() {
  runApp(eDrop());
}

class eDrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eDrop',
      theme: AppTheme.themeData, // Use the theme from theme.dart
      home: HomePage(),
    );
  }
}

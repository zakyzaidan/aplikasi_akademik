import 'package:aplikasi_akademik/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AkademikApp());
}

class AkademikApp extends StatelessWidget {
  const AkademikApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Akademik',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

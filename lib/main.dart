import 'package:flutter/material.dart';
import '././src/Auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logix CIS',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor:const Color(0xFF004e92), // Blue color matching the image
        accentColor: const Color(0xFF004e92), // Accent color
        backgroundColor: Colors.white, // Background color is white
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          headlineLarge: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004e92),
          ),
          bodyLarge : TextStyle(
            fontSize: 16.0,
            color: Colors.grey[600],
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF004e92), // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded button corners
          ),
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF0A77EC)),
          ),
        ),
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

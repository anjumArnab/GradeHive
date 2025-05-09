import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_page.dart';

void main() {
  runApp(const GradeHive());
}

class GradeHive extends StatelessWidget {
  const GradeHive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradeHive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

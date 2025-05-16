import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grade_hive/views/homepage.dart';

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
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

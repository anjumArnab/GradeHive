import 'dart:convert';
import 'dart:developer';

import 'package:grade_hive/models/student.dart';
import 'package:http/http.dart' as http;

class SheetAPI {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbxRkiYM-qSjLHRsE79Ni9ZtfkUk2sqCDBPZZmBJ9YuTZVmmtIu1qJtdn7hrqVnD9kxhbA/exec';

  // Create Student
  static Future<Student?> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'create',
          'name': student.name,
          'age': student.age,
          'grade': student.grade,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Assuming response returns the created student data
        return Student.fromJson(responseData['data'] ?? responseData);
      }
      return null;
    } catch (e) {
      log("Error creating student: $e");
      return null;
    }
  }

  // Read Students
  static Future<List<Student>?> getStudents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> studentsList = responseData['data'];
          return studentsList
              .map((student) => Student.fromJson(student))
              .toList();
        }
      }
      return null;
    } catch (e) {
      log("Error fetching students: $e");
      return null;
    }
  }

  // Update Student
  // IMPORTANT: you need to pass the row number (index in sheet) to update correctly
  static Future<bool> updateStudent(int row, Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'update',
          'row': row,
          'name': student.name,
          'age': student.age,
          'grade': student.grade,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      }
      return false;
    } catch (e) {
      log("Error updating student: $e");
      return false;
    }
  }

  // Delete Student
  // Also needs row number
  static Future<bool> deleteStudent(int row) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'delete', 'row': row}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      }
      return false;
    } catch (e) {
      log("Error deleting student: $e");
      return false;
    }
  }
}

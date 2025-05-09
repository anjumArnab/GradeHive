import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/sheets_api.dart';
import '../widgets/student_form.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _resultController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final student = Student(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        result: _resultController.text.trim(),
      );

      final response = await SheetsApi.createStudent(student);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Error adding student'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StudentForm(
          formKey: _formKey,
          idController: _idController,
          nameController: _nameController,
          resultController: _resultController,
          isLoading: _isLoading,
          onSubmit: _saveStudent,
          submitButtonText: 'Add Student',
        ),
      ),
    );
  }
}

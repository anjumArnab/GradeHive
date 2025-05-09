import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/sheets_api.dart';
import '../widgets/student_form.dart';

class UpdateStudentPage extends StatefulWidget {
  final Student student;

  const UpdateStudentPage({super.key, required this.student});

  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _resultController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.student.id);
    _nameController = TextEditingController(text: widget.student.name);
    _resultController = TextEditingController(text: widget.student.result);
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final updatedStudent = Student(
        id: widget.student.id, // ID cannot be changed
        name: _nameController.text.trim(),
        result: _resultController.text.trim(),
      );

      final response = await SheetsApi.updateStudent(updatedStudent);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Error updating student'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StudentForm(
          formKey: _formKey,
          idController: _idController,
          nameController: _nameController,
          resultController: _resultController,
          isLoading: _isLoading,
          onSubmit: _updateStudent,
          submitButtonText: 'Update Student',
          idEditable: false, // ID field should not be editable when updating
        ),
      ),
    );
  }
}

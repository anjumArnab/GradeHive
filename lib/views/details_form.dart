import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_text_field.dart';

class DetailsForm extends StatefulWidget {
  final Student? student; // Optional student for editing mode

  const DetailsForm({super.key, this.student});

  @override
  State<DetailsForm> createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    // Check if we're in edit mode
    if (widget.student != null) {
      isEditMode = true;
      _nameController.text = widget.student!.name;
      _ageController.text = widget.student!.age.toString();
      _gradeController.text = widget.student!.grade;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }

    if (age < 5 || age > 100) {
      return 'Age must be between 5 and 100';
    }

    return null;
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final provider = context.read<StudentProvider>();
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final grade = _gradeController.text.trim();

    bool success = false;

    if (isEditMode && widget.student?.id != null) {
      // Create updated student with same ID
      final updatedStudent = Student(
        id: widget.student!.id,
        name: name,
        age: age,
        grade: grade,
      );
      success = await provider.updateStudent(
        widget.student!.id!,
        updatedStudent,
      );
    } else {
      // Create new student
      final student = Student(name: name, age: age, grade: grade);
      success = await provider.createStudent(student);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'Student updated successfully'
                : 'Student created successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                (isEditMode
                    ? 'Failed to update student'
                    : 'Failed to create student'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(isEditMode ? 'Edit Student' : 'Add Student'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Student name',
                      labelText: 'Name',
                      validator: _validateRequired,
                      enabled: !isEditMode,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _ageController,
                      hintText: 'Student age',
                      labelText: 'Age',
                      keyboardType: TextInputType.number,
                      validator: _validateAge,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _gradeController,
                      hintText: 'Student grade',
                      labelText: 'Grade',
                      validator: _validateRequired,
                    ),
                    const SizedBox(height: 24),
                    ActionButton(
                      label: isEditMode ? 'Update' : 'Save',
                      onPressed: _saveStudent,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

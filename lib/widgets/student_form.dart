import 'package:flutter/material.dart';

class StudentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController resultController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitButtonText;
  final bool idEditable;

  const StudentForm({
    super.key,
    required this.formKey,
    required this.idController,
    required this.nameController,
    required this.resultController,
    required this.isLoading,
    required this.onSubmit,
    required this.submitButtonText,
    this.idEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                hintText: 'Enter student ID',
                border: OutlineInputBorder(),
              ),
              enabled: idEditable,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a student ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                hintText: 'Enter student name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a student name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: resultController,
              decoration: const InputDecoration(
                labelText: 'Result',
                hintText: 'Enter student result',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a result';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: const BorderSide(color: Colors.black),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child:
                  isLoading
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("Please wait..."),
                        ],
                      )
                      : Text(
                        submitButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

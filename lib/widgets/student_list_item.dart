import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentListItem extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const StudentListItem({
    super.key,
    required this.student,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(student.name),
        subtitle: Text('ID: ${student.id} | Result: ${student.result}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Delete Student'),
                    content: Text(
                      'Are you sure you want to delete ${student.name}?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}

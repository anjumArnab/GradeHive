class Student {
  String name;
  int age;
  String grade;

  Student({required this.name, required this.age, required this.grade});

  // Factory constructor to create a Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      grade: json['grade'] ?? '',
    );
  }

  // Method to convert Student instance to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age, 'grade': grade};
  }
}

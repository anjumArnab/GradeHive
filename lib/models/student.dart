class Student {
  final int? id;
  final String name;
  final int age;
  final String grade;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.grade,
  });

  // Safer fromJson method with explicit type checking and conversion
  factory Student.fromJson(Map<String, dynamic> json) {
    // Handle ID - could be int or String
    int? idValue;
    if (json['id'] != null) {
      if (json['id'] is int) {
        idValue = json['id'];
      } else if (json['id'] is String) {
        idValue = int.tryParse(json['id']);
      }
    }

    // Handle age - could be int or String
    int ageValue = 0;
    if (json['age'] != null) {
      if (json['age'] is int) {
        ageValue = json['age'];
      } else if (json['age'] is String) {
        ageValue = int.tryParse(json['age'] as String) ?? 0;
      }
    }

    return Student(
      id: idValue,
      name: json['name']?.toString() ?? '',
      age: ageValue,
      grade: json['grade']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age, 'grade': grade};
  }

  // This is a workaround to maintain compatibility with existing code
  int? get row => id;
}

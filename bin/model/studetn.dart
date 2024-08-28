import 'dart:convert';
import 'dart:io';

class Course {
  final String courseName;
  final List<double> marks;

  Course(this.courseName, this.marks);

  // Chuyển đổi đối tượng Course thành JSON
  Map<String, dynamic> toJson() => {
        'course_name': courseName,
        'marks': marks,
      };

  // Khôi phục đối tượng Course từ JSON
  factory Course.fromJson(Map<String, dynamic> json) => Course(
        json['course_name'],
        List<double>.from(json['marks']),
      );
}

// Lớp Student
class Student {
  final String studentCode;
  final String id;
  final String studentName;
  final DateTime createdAt;
  final List<Course> courses;

  Student({
    required this.studentName,
    required this.id,
    required this.studentCode,
    required this.createdAt,
    required this.courses,
  });

  // Chuyển đổi đối tượng Student thành JSON
  Map<String, dynamic> toJson() => {
        'student_code': studentCode,
        'id': id,
        'student_name': studentName,
        'created_at': createdAt.toIso8601String(),
        'courses': courses.map((course) => course.toJson()).toList(),
      };

  // Khôi phục đối tượng Student từ JSON
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        studentName: json['student_name'],
        id: json['id'],
        studentCode: json['student_code'],
        createdAt: DateTime.parse(json['created_at']),
        courses: (json['courses'] as List<dynamic>)
            .map((courseJson) => Course.fromJson(courseJson))
            .toList(),
      );
}

// Hàm nhập thông tin một môn học từ người dùng
Course inputCourse() {
  stdout.write('Nhập tên môn học: ');
  String courseName = stdin.readLineSync() ?? '';

  stdout.write('Nhập số lượng điểm thi: ');
  int marksCount = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  List<double> marks = [];
  for (int i = 0; i < marksCount; i++) {
    stdout.write('Nhập điểm thi ${i + 1}: ');
    double mark = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
    marks.add(mark);
  }

  return Course(courseName, marks);
}

// Hàm nhập thông tin sinh viên từ người dùng
Student inputStudent() {
  stdout.write('Nhập tên sinh viên: ');
  String studentName = stdin.readLineSync() ?? '';

  stdout.write('Nhập ID sinh viên: ');
  String id = stdin.readLineSync() ?? '';

  stdout.write('Nhập mã sinh viên: ');
  String studentCode = stdin.readLineSync() ?? '';

  stdout.write('Nhập ngày tạo (YYYY-MM-DD): ');
  DateTime createdAt =
      DateTime.parse(stdin.readLineSync() ?? DateTime.now().toIso8601String());

  stdout.write('Nhập số lượng môn học: ');
  int coursesCount = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  List<Course> courses = [];
  for (int i = 0; i < coursesCount; i++) {
    print('Nhập thông tin cho môn học ${i + 1}:');
    courses.add(inputCourse());
  }

  return Student(
    studentName: studentName,
    id: id,
    studentCode: studentCode,
    createdAt: createdAt,
    courses: courses,
  );
}

Future<List<Student>> readStudents(String filePath) async {
  final file = File(filePath);
  final contents = await file.readAsString();
  final jsonData = jsonDecode(contents) as List<dynamic>;

  return jsonData.map((studentJson) => Student.fromJson(studentJson)).toList();
}

Future<void> writeStudents(String filePath, List<Student> students) async {
  final file = File(filePath);
  final jsonData = students.map((student) => student.toJson()).toList();
  final contents = jsonEncode(jsonData);

  await file.writeAsString(contents);
}

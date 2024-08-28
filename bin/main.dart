import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'model/studetn.dart';

void main(List<String> args) async {
  while (true) {
    print("Please choose an option:");
    print("1. Add Student");
    print("2. Display All Students");
    print("3. Update Student Information");
    print("4. Search Student by Name or ID");
    print("5. Exit");

    int choice = int.parse(stdin.readLineSync() ?? '5');

    switch (choice) {
      case 1:
        print('Add Student');

        List<Student> students = [];

        Student student = inputStudent();
        students.add(student);
        await writeStudents("student.json", students);
        break;
      case 2:
        print("Display All Students");
        List<Student> students = await readStudents("student.json");
        print(students);
        break;
      case 3:
        print("Updating student information:");
        List<Student> allStudents = await readStudents("student.json");
        print("Enter student ID to update:");
        String idToUpdate = stdin.readLineSync() ?? '';
        Student? studentToUpdate =
            allStudents.firstWhere((student) => student.id == idToUpdate);
        if (studentToUpdate != null) {
          print("Enter new name for student (leave blank to keep current):");
          String newName = stdin.readLineSync() ?? '';
          if (newName.isNotEmpty) {
            studentToUpdate = Student(
              studentName: newName,
              id: studentToUpdate.id,
              studentCode: studentToUpdate.studentCode,
              createdAt: studentToUpdate.createdAt,
              courses: studentToUpdate.courses,
            );
          }
          await writeStudents("student.json", allStudents);
        } else {
          print("Student not found.");
        }
        break;

      case 4:
        print("Search student by Name or ID:");
        String query = stdin.readLineSync() ?? '';
        List<Student> students = await readStudents("student.json");
        students
            .where((student) =>
                student.studentName.contains(query) ||
                student.id.contains(query))
            .forEach((student) => print(student));
        break;
      case 5:
        print("Exiting...");
        return;
      default:
        print("Invalid option. Please try again.");
    }
  }
}

import 'package:smart_bus/get_students/model/students_model.dart';

abstract class GetStudentState {}

class GetStudentInitial extends GetStudentState {}

class GetStudentLoading extends GetStudentState {}

class GetStudentSuccess extends GetStudentState {
   final List<StudentModel> students;
  GetStudentSuccess(this.students);
}

class GetStudentError extends GetStudentState {
  final String message;
  GetStudentError(this.message);
}



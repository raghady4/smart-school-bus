abstract class AddStudentState {}

class AddStudentInitial extends AddStudentState {}

class AddStudentLoading extends AddStudentState {}

class AddStudentSuccess extends AddStudentState {}

class AddStudentError extends AddStudentState {
  final String message;
  AddStudentError(this.message);
}

class DeleteStudentLoading extends AddStudentState {}

class DeleteStudentSuccess extends AddStudentState {
  final String studentId;
  DeleteStudentSuccess(this.studentId);
}

class DeleteStudentError extends AddStudentState {
  final String message;
  DeleteStudentError(this.message);
}

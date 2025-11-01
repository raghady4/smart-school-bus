import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_student_state.dart';
import '../server/add_student_server.dart';
// import 'dart:io';

class AddStudentCubit extends Cubit<AddStudentState> {
  AddStudentCubit(this.addStudentServer) : super(AddStudentInitial());
  final AddStudentServer addStudentServer;
  Future<void> addStudent({
    required String name,
    required String address,
    required String nfcLogsId,
    required String schoolId,
    required String areaId,
      String? busId,
  }) async {
    emit(AddStudentLoading());
    print("here are cubit");

    final success = await addStudentServer.addStudent(
      name: name,
      address: address,
      nfcLogsId: nfcLogsId,
      schoolId: schoolId,
      busId: busId,
      areaId: areaId
    );
  

    if (success) {
      emit(AddStudentSuccess());
    } else {
      emit(AddStudentError('فشل في إرسال البيانات'));
    }
  }


    Future<void> deleteStudent({
    required String studentId,
  }) async {
    emit(DeleteStudentLoading());
    print("here are cubit");

    final success = await addStudentServer.deleteStudent(
  
    studentId: studentId,
          );

    if (success) {
      emit(DeleteStudentSuccess(studentId));
    } else {
      emit(DeleteStudentError('فشل في إرسال البيانات'));
    }
  }
}
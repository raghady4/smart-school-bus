import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';

import 'package:smart_bus/get_students/get_student_bloc/get_student_state.dart';
import 'package:smart_bus/get_students/model/students_model.dart';
import 'package:smart_bus/get_students/server/get_student_server.dart';

class GetStudentCubit extends Cubit<GetStudentState> {
  GetStudentCubit(this.getStudentServer) : super(GetStudentInitial());
  final GetStudentServer getStudentServer;

  Future<void> getMyStudent() async {
    emit(GetStudentLoading());
    print("here are  get cubit");

    final data = await getStudentServer.getMyStudents();
    if (data['success'] == true) {
      List<StudentModel> myStudents =   (data['data'] as List)
      .map((studentJson) => StudentModel.fromJson(studentJson))
      .toList();
      emit(GetStudentSuccess(myStudents));
    } else {
      emit(GetStudentError('فشل في إرسال البيانات'));
    }
  }
}
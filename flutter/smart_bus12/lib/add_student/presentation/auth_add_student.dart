import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/add_student/presentation/page11.dart';
import 'package:smart_bus/add_student/server/add_student_server.dart';
import '../bloc/add_student_cubit.dart';

class AuthAddStudent extends StatelessWidget {
  const AuthAddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddStudentCubit(
        AddStudentServer(baseUrl: 'http://192.168.186.176:8000/api'),
      ),
      child: const AddStudentPage(),
    );
  }
}

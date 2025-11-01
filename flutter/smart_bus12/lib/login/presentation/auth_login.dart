import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/login/presentation/register.dart';
import 'package:smart_bus/login/bloc/login_cubit.dart';
import 'package:smart_bus/login/server/login_server.dart';

class RegisterAuthPage extends StatelessWidget {
  const RegisterAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoginCubit(LoginServer(baseUrl: 'http://192.168.186.176:8000/api')),
      child: Register(),
    );
  }
}

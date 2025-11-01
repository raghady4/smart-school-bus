import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';
import '../server/forgot_password_server.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> sendResetLink(String email) async {
    emit(ForgotPasswordLoading());
    try {
      final message = await ForgotPasswordServer.sendResetEmail(email: email);
      emit(ForgotPasswordSuccess(message));
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }
}

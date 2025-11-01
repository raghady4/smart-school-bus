import 'package:flutter_bloc/flutter_bloc.dart';
import '../server/reset_password_server.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final message = await ResetPasswordServer.resetPassword(
        email: email,
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(ResetPasswordSuccess(message));
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class EmailVerifiedSuccess extends LoginState {}

class EmailVerifiedFailure extends LoginState {}

class LoginSuccess extends LoginState {
  final String name;
  final String role;

  LoginSuccess({required this.name, required this.role, required fullName});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// abstract class RegisterState {}

// class RegisterInitial extends LoginState {}

// class RegisterLoading extends LoginState {}

// class RegisterSuccess extends LoginState {
//   final Map<String, dynamic> userData;
//     final String name;
//   final String role;
//   RegisterSuccess(this.userData, this.name,  this.role);
// }

// class RegisterError extends LoginState {
//   final String message;
//   RegisterError(this.message);
// }

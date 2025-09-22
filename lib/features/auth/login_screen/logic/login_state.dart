part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
 final LoginResponse loginResponse;

  LoginSuccessState({required this.loginResponse});
}

final class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState({required this.error});
}

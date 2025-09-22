part of 'change_password_cubit.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}


final class ChangePasswordLoadingState extends ChangePasswordState {}

final class ChangePasswordSuccessState extends ChangePasswordState {
  final ChangePasswordResponse changePasswordResponse;

  ChangePasswordSuccessState({required this.changePasswordResponse});
}

final class ChangePasswordErrorState extends ChangePasswordState {
  final String error;

  ChangePasswordErrorState({required this.error});
}

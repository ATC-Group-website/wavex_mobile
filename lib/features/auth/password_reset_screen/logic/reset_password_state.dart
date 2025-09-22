part of 'reset_password_cubit.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}
final class ForgetPasswordLoadingState extends ResetPasswordState {}
final class ForgetPasswordSuccessState extends ResetPasswordState {
  final ResetPasswordResponse resetPasswordResponse;

  ForgetPasswordSuccessState({required this.resetPasswordResponse});
}
final class ForgetPasswordErrorState extends ResetPasswordState {
  final String error;

  ForgetPasswordErrorState({required this.error});
}

final class VerifyOtpLoadingState extends ResetPasswordState {}
final class VerifyOtpSuccessState extends ResetPasswordState {
  final VerifyOTPResponse verifyOTPResponse;

  VerifyOtpSuccessState({required this.verifyOTPResponse});
}
final class VerifyOtpErrorState extends ResetPasswordState {
  final String error;

  VerifyOtpErrorState({required this.error});
}



final class ChangePasswordLoadingState extends ResetPasswordState {}

final class ChangePasswordSuccessState extends ResetPasswordState {
  final ChangePasswordResponse changePasswordResponse;

  ChangePasswordSuccessState({required this.changePasswordResponse});
}

final class ChangePasswordErrorState extends ResetPasswordState {
  final String error;

  ChangePasswordErrorState({required this.error});
}

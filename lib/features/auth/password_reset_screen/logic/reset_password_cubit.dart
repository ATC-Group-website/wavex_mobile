import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/auth/password_reset_screen/data/models/reset_password_response.dart';
import 'package:wavex/features/auth/password_reset_screen/data/models/verify_OTP_response.dart';

import '../../../change_password_screen/data/models/change_password_response.dart';
import '../data/repository/reset_password_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordRepository repository;

  ResetPasswordCubit(this.repository) : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  forgetPassword({
    required String email,
  }) {
    emit(ForgetPasswordLoadingState());
    repository
        .forgetPassword(
      email: email,
    )
        .then((value) {
      emit(
        ForgetPasswordSuccessState(
          resetPasswordResponse: ResetPasswordResponse.fromJson(
            jsonDecode(value!.data),
          ),
        ),
      );
    }).catchError((error) {
      print(error.toString());
      emit(ForgetPasswordErrorState(error: error.toString()));
    });
  }

  verifyOtp({
    required String otp,
    required String email,
  }) {
    emit(VerifyOtpLoadingState());
    repository
        .verifyOtp(
      otp: otp,
      email: email,
    )
        .then((value) {
      print("data: " + value!.data);
      if (value!.statusCode == 200 || value!.statusCode == 201) {
        emit(
          VerifyOtpSuccessState(
            verifyOTPResponse: VerifyOTPResponse.fromJson(
              jsonDecode(value.data),
            ),
          ),
        );
      } else {
        // هنا السيرفر راجع error زي 422
        final errorMsg =
            jsonDecode(value.data)["message"] ?? "Registration failed";
        emit(VerifyOtpErrorState(error: errorMsg));
      }
    }).catchError((error) {
      print(error.toString());
      emit(VerifyOtpErrorState(error: error.toString()));
    });
  }

  changePassword({required String confirmPassword, required String password}) {
    emit(ChangePasswordLoadingState());
    repository
        .changePassword(
      password: password,
      confirmPassword: confirmPassword,
    )
        .then((value) {
      print("data: " + value!.data);
      emit(
        ChangePasswordSuccessState(
          changePasswordResponse: ChangePasswordResponse.fromJson(
            jsonDecode(value.data),
          ),
        ),
      );
    }).catchError((error) {
      print(error.toString());
      emit(ChangePasswordErrorState(error: error.toString()));
    });
  }
}

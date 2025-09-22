import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wavex/features/change_password_screen/data/repository/change_password_repository.dart';

import '../../../core/networks/api_manager.dart';
import '../data/models/change_password_response.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordRepository repository;

  ChangePasswordCubit(this.repository) : super(ChangePasswordInitial());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  changePassword({required String confirmPassword, required String password}) {
    emit(ChangePasswordLoadingState());

    repository.changePassword(
      password: password,
      confirmPassword: confirmPassword,
    ).then((value) {
      print("data: " + value!.data);
      emit(
        ChangePasswordSuccessState(
          changePasswordResponse: ChangePasswordResponse.fromJson(
            jsonDecode(value.data),
          ),
        ),
      );
    }).catchError((error) {
      print("error: $error");

      String errorMessage = "حدث خطأ غير متوقع";

      if (error is ApiException) {
        errorMessage = error.message ?? "خطأ في السيرفر";
      } else if (error is DioError) {
        errorMessage = ApiManager.getErrorMsg(error.response?.data);
      }

      emit(ChangePasswordErrorState(error: errorMessage));
    });
  }

}

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../data/models/login_response.dart';
import '../data/repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginRepository repository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginCubit(this.repository) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  login({
    required String email,
    required String password,
    String? deviceToken,
    String? orderId,
  }) async {
    emit(LoginLoadingState());

    try {
      final value = await repository.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
        orderId: orderId,
      );

      // parse only if value != null
      if (value != null && value.data != null) {
        final decoded = value.data is String
            ? jsonDecode(value.data)
            : value.data; // already a Map

        emit(LoginSuccessState(
          loginResponse: LoginResponse.fromJson(decoded),
        ));
      } else {
        emit(LoginErrorState(error: "Empty response from server"));
      }
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }

  // login({
  //   required String email,
  //   required String password,
  //   String? deviceToken,
  //   String? orderId,
  // }) {
  //   emit(LoginLoadingState());
  //   repository
  //       .login(email: email, password: password, deviceToken: deviceToken,orderId: orderId)
  //       .then((value) {
  //     // print("data: " + value.data);
  //
  //     emit(
  //       LoginSuccessState(
  //         loginResponse: LoginResponse.fromJson(
  //           jsonDecode(value?.data),
  //         ),
  //       ),
  //     );
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(LoginErrorState(error: error.toString()));
  //   });
  // }
}

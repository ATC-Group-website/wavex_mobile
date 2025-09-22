import 'package:dio/dio.dart';
import 'package:wavex/core/networks/request_body.dart';

import '../../../../../core/networks/api_manager.dart';
import '../../../../../core/networks/api_response.dart';

class ResetPasswordRepository {
  Future<ApiResponse?> forgetPassword({
    required String email,
  }) async {
    return await ApiManager.sendRequest(
      link: 'forgot-password',
      body: RequestBody({
        'email': email,
      }),
      method: Method.POST,
    );
  }

  Future<ApiResponse?> verifyOtp({
    required String otp,
    required String email,
  }) async {
    return await ApiManager.sendRequest(
      link: 'verify-otp',
      body: RequestBody({
        'otp': otp,
        'email': email,
      }),
      method: Method.POST,
    );
  }


  Future<ApiResponse?> changePassword({
    required String password,
    required String confirmPassword,
  }) async {
    return  await ApiManager.sendRequest(
      link: 'reset-password',
      body: RequestBody({
        'password': password,
        'password_confirmation': confirmPassword,
      }),
      method: Method.POST,
    );
  }

}

import 'package:dio/dio.dart';
import 'package:wavex/core/networks/request_body.dart';
import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class ChangePasswordRepository {
  Future<ApiResponse?> changePassword({
    required String password,
    required String confirmPassword,
  }) async {
    return await ApiManager.sendRequest(
      link: 'reset-password',
      body: RequestBody({
        'password': password,
        'password_confirmation': confirmPassword,
      }),
      method: Method.POST,
    );
  }
}

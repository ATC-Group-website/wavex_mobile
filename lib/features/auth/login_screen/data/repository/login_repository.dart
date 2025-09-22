import 'package:wavex/core/networks/request_body.dart';

import '../../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../../core/networks/api_manager.dart';
import '../../../../../core/networks/api_response.dart';

class LoginRepository {
  // Future<ApiResponse?> login({
  //   required String email,
  //   required String password,
  //   String? orderId,
  //   String? deviceToken,
  // }) async {
  //   try {
  //     Map<String, dynamic> data = {
  //       "email": email,
  //       "password": password,
  //       "device_token": deviceToken,
  //     };
  //
  //     if (orderId != null) {
  //       data.addAll({
  //         "order_id": orderId,
  //       });
  //     }
  //
  //     ApiResponse? response = await ApiManager.sendRequest(
  //       link: 'login',
  //       body: RequestBody(data),
  //       method: Method.POST,
  //     );
  //     return response;
  //   } catch (e) {
  //     print("error error: $e");
  //     return null;
  //   }
  // }

  Future<ApiResponse?> login({
    required String email,
    required String password,
    String? orderId,
    String? deviceToken,
  }) async {
    Map<String, dynamic> data = {
      "email": email,
      "password": password,
      "device_token": deviceToken,
    };

    if (orderId != null) {
      data["order_id"] = orderId;
    }

    return await ApiManager.sendRequest(
      link: 'login',
      body: RequestBody(data),
      method: Method.POST,
    );
  }

}

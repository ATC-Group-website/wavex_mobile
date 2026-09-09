import 'package:wavex/core/utils/app_logger.dart';
import 'package:wavex/core/networks/request_body.dart';

import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class PaymentOptionsRepository {
  Future<ApiResponse?> purchase(
      {required String orderId, required dynamic addressId}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'purchase',
        body: RequestBody({
          "order_id": orderId,
          "address_id": addressId,
        }),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      appLog("error error: $e");
      rethrow;
    }
  }
}

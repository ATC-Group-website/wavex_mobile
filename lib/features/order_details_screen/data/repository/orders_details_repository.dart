import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class OrdersDetailsRepository{

  Future<ApiResponse?> getOrders({
    required String orderId
}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'orders/$orderId',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
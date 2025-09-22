import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class OrdersRepository{

  Future<ApiResponse?> getOrders() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'orders/get-user-order',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }
}
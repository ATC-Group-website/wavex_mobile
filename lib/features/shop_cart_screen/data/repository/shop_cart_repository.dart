import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';
import '../../../../core/networks/request_body.dart';
import '../../../shop_screen/data/models/add_to_cart_request_body.dart';

class ShopCartRepository {
  Future<ApiResponse?> getCart({String? orderId}) async {
    Map<String, dynamic> queryParams = {};
    if (orderId != null) {
      queryParams.addAll({"order_id": orderId});
    }
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'users/cart',
        queryParams: queryParams,
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> addToCart(
      {required AddToCartRequestBody addToCartRequestBody}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'orders',
        body: RequestBody(addToCartRequestBody.toJson()),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> decreaseQuantity({required int orderItemId}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'orders/$orderItemId/decrease',
        method: Method.PATCH,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }
}

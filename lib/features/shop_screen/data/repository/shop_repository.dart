import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';
import '../../../../core/networks/request_body.dart';
import '../models/add_to_cart_request_body.dart';

class ShopRepository {
  Future<ApiResponse?> getProducts({
    int? pageNumber,
    String? q,
    double? priceFrom,
    double? priceTo,
    int? category,
    String? sortPrice,
  }) async {
    try {
      final queryParams = {
        "page": pageNumber.toString(),
      };

      if (q != null && q.isNotEmpty) queryParams["q"] = q;
      if (priceFrom != null) queryParams["price_from"] = priceFrom.toString();
      if (priceTo != null) queryParams["price_to"] = priceTo.toString();
      if (category != null) queryParams["category"] = category.toString();
      if (sortPrice != null && sortPrice.isNotEmpty) {
        queryParams["sort_price"] = sortPrice;
      }

      ApiResponse? response = await ApiManager.sendRequest(
        link: 'products',
        queryParams: queryParams,
        method: Method.GET,
      );
      return response;
    }catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> getCategories() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'categories',
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
    }catch (e) {
      print("error error: $e");
      rethrow;
    }
  }
}

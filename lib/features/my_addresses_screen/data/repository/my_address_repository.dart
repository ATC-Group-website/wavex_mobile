import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class MyAddressRepository {
  Future<ApiResponse?> getMyAddress() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'addresses',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> deleteAddress({required int addressId}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'addresses/$addressId',
        method: Method.DELETE,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }
}

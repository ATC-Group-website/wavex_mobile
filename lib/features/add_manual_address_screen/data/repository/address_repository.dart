import 'package:wavex/features/add_manual_address_screen/data/models/address_request_body.dart';

import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';
import '../../../../core/networks/request_body.dart';

class AddressRepository {
  Future<ApiResponse?> addAddress({
    required AddressRequestBody address,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'addresses',
        body: RequestBody(
          address.toJson(),
        ),

        method: Method.POST,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> updateAddress({
    required int addressId,
    required AddressRequestBody address,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'addresses/$addressId',
        body: RequestBody(
          address.toJson(),
        ),
        method: Method.PUT,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> getAddressById({
    required int addressId,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'addresses/$addressId',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }
}

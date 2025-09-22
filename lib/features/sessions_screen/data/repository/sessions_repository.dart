import 'package:wavex/core/networks/request_body.dart';

import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class SessionsRepository {
  Future<ApiResponse?> getSessions({
    int? page,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'my-sessions',
        queryParams: {
          "relations[location]": "",
          "relations[instructor]": "",
          "page": page,
        },
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> getReasons() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'refunds/available-reasons',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> makeRefund({
    required int sessionId,
    required String reason,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'refunds/request',
        body: RequestBody({"session_id": sessionId, "reason": reason}),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }
  Future<ApiResponse?> cancelSession({
    required int sessionId,
    required String reason,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'bookings/$sessionId/cancel',
        body: RequestBody({"cancellation_reason": reason,}),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      rethrow;
    }
  }
}

import 'package:wavex/core/utils/app_logger.dart';
import 'package:wavex/core/networks/request_body.dart';

import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class SessionsRepository {
  static const sessionRefundEndpoint = 'v2/refunds/request';

  static Map<String, dynamic> sessionRefundPayload({
    required int bookingId,
    required String reason,
  }) {
    return {
      'booking_id': bookingId,
      'reason': reason,
    };
  }

  static String cancellationEndpoint(int bookingId) =>
      'bookings/$bookingId/cancel';

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
      appLog("error error: $e");
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
      appLog("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> makeRefund({
    required int bookingId,
    required String reason,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: sessionRefundEndpoint,
        body: RequestBody(
          sessionRefundPayload(bookingId: bookingId, reason: reason),
        ),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      appLog("error error: $e");
      rethrow;
    }
  }

  Future<ApiResponse?> cancelSession({
    required int bookingId,
    required String reason,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: cancellationEndpoint(bookingId),
        body: RequestBody({
          "cancellation_reason": reason,
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

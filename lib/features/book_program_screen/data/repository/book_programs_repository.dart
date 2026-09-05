import 'package:wavex/core/networks/request_body.dart';

import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class BookProgramsRepository {
  Future<ApiResponse?> getProgramById({required int id}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'programs/$id',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> getLocations() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'locations',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> getPrograms() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'programs',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> getSessions({
    required String date,
    int? programId,
    int? locationId,
  }) async {
    try {
      Map<String, dynamic> query = {
        "session_date": date,
        "relations[instructor][fields]": "id,first_name,last_name",
        "relations[location][fields]":
            "id,area_name,venue_name,requires_form_submission",
        "relations[program][fields]": "id,name",
      };

      if (programId != null && programId != 0) {
        query.addAll({"program_id": programId});
      }

      if (locationId != null && locationId != 0) {
        query.addAll({"location_id": locationId});
      }

      ApiResponse? response = await ApiManager.sendRequest(
        link: 'sessions',
        queryParams: query,
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> payment({
    required int sessionId,
    required String idempotencyKey,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'v2/payment',
        body: RequestBody({
          "session_id": sessionId,
          "slots": 1,
          "idempotency_key": idempotencyKey,
        }),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }

  Future<ApiResponse?> paymentStatus({required int paymentId}) {
    return ApiManager.sendRequest(
      link: 'v2/payments/$paymentId/status',
      method: Method.GET,
    );
  }

  Future<ApiResponse?> bookFreeSession({required int sessionId}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'book_free_session',
        body: RequestBody({"session_id": sessionId}),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }
}

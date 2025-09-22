import 'package:dio/dio.dart';
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

  Future<ApiResponse?> getSessions({
    required String date,
    required int programId,
    int? locationId,
  }) async {
    try {
      Map<String, dynamic> query = {
        "session_date": date,
        "relations[instructor][fields]": "id,first_name,last_name",
        "program_id": programId,
        "relations[location][fields]": "id,area_name,venue_name"
      };

      if (locationId != 0) {
        query.addAll({
          "location_id": locationId,
        });
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
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'payment',
        body: RequestBody({
          "session_id": sessionId,
        }),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }  Future<ApiResponse?> bookFreeSession({
    required int sessionId,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'book_free_session',
        body: RequestBody({
          "session_id": sessionId,
        }),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }
}

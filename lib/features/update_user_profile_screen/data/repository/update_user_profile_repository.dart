import 'package:wavex/core/networks/request_body.dart';
import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class UpdateUserProfileRepository {
  Future<ApiResponse?> updateUserData({
    String? phone,
    String? firstName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    String? medical,
    String? emergencyNumber,
    String? gender,
  }) async {
    try {
      // Build request body only with non-null fields
      final Map<String, dynamic> body = {
        if (firstName != null) "first_name": firstName,
        if (lastName != null) "last_name": lastName,
        if (lastName != null) "last_name": lastName,
        if (dateOfBirth != null) "date_of_birth": dateOfBirth,
        if (gender != null) "gender": gender,
        if (medical != null) "medical_conditions": medical,
        if (phone != null) "phone": phone,
        if (emergencyNumber != null) "emergency_number": emergencyNumber ,
        if (email != null) "email": email,
      };

      ApiResponse? response = await ApiManager.sendRequest(
        link: 'users',
        body: RequestBody(body),
        method: Method.PUT,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }
  Future<ApiResponse?> getUserProfileData() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'user/profile',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }

}

import 'package:wavex/core/networks/request_body.dart';
import 'package:wavex/core/constants/cache_keys.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import '../../../../../core/networks/api_manager.dart';
import '../../../../../core/networks/api_response.dart';

class RegistrationRepository {
  Future<ApiResponse?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String password,
    required String dateOfBirth, // ex: "2025-08-16"
    String? phone,
    String? emergencyNumber,
    String? medicalConditions,
    String? deviceToken,
    String? image, // اختياري
  }) async {
    try {
      // تجهيز الـ FormData
      Map<String, dynamic> body = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "gender": "male",
        "password": password,
        "phone": phone ?? "",
        "date_of_birth": dateOfBirth,
        "emergency_number": emergencyNumber ?? "",
        "device_token": deviceToken ?? "",
        "medical_conditions": medicalConditions ?? "",
      };
      final selectedCountryId =
          CacheHelper.getdata(key: CacheKeys.selectedCountryId);
      if (selectedCountryId != null) {
        body["country_id"] = selectedCountryId;
      }
      if (image != null && image.isNotEmpty) {
        body["image"] = "data:image/jpg;base64,$image";
      }
      // استدعاء API Manager (لو بتستخدمه بداخل Dio)
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'users',
        body: RequestBody(
          body,
        ), // هنا هيكون FormData مش Map
        method: Method.POST,
      );

      return response;
    } catch (e) {
      print("Register error: $e");
      rethrow;
    }
  }
}

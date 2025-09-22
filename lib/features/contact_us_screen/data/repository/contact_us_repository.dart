import 'package:wavex/core/networks/request_body.dart';

import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class ContactUsRepository {

  Future<ApiResponse?> contactUs({
    required String name,
    required String email,
    required String phone,
     String? topic,
    required String body,
    required bool isSubscribedToEmails,
  }) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'get-in-touch',
        body: RequestBody({
          "name": name,
          "email": email,
          "phone": phone,
          "body": body,
          "topic": topic,
          "is_subscribed_to_emails": isSubscribedToEmails
        }),
        method: Method.POST,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }
  Future<ApiResponse?> socialLinks() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'social-links',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> getTopics() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'inquiries/topics',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }
}

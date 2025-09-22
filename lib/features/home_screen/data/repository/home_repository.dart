import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class HomeRepository{

  Future<ApiResponse?> getInstructors() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'instructors',
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


  Future<ApiResponse?> getNotification({
    required int pageNumber
}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'notifications',
        queryParams: {
          "page" : pageNumber
        },
        method: Method.GET,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }
  Future<ApiResponse?> markNotificationAsRead({
    required int notificationId
}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'notifications/$notificationId/read',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      // Don’t swallow the error
      rethrow;
    }
  }

}
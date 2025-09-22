import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class InstructorsRepository{
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

  Future<ApiResponse?> getInstructor({required int instructorId}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'instructors/$instructorId',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      print("error error: $e");
      return null;
    }
  }

}
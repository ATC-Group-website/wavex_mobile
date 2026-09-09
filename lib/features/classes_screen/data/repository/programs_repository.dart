import 'package:wavex/core/utils/app_logger.dart';
import '../../../../core/networks/api_manager.dart';
import '../../../../core/networks/api_response.dart';

class ProgramsRepository {
  Future<ApiResponse?> getPrograms() async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'programs',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      appLog("error error: $e");
      return null;
    }
  }

  Future<ApiResponse?> getProgramById({required int id}) async {
    try {
      ApiResponse? response = await ApiManager.sendRequest(
        link: 'programs/$id',
        method: Method.GET,
      );
      return response;
    } catch (e) {
      appLog("error error: $e");
      return null;
    }
  }
}

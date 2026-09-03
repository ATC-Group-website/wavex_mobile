import 'dart:convert';

import 'package:wavex/core/networks/api_manager.dart';
import 'package:wavex/features/branch_selection/data/models/branch.dart';

class BranchRepository {
  Future<List<Branch>> getBranches(int regionId) async {
    final response = await ApiManager.sendRequest(
      link: 'regions/$regionId/branches',
      method: Method.GET,
    );

    if (response?.data == null) {
      throw Exception('No branches were returned by the server.');
    }

    final decoded = response!.data is String
        ? jsonDecode(response.data as String)
        : response.data;

    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw Exception('The branch list has an unexpected format.');
    }

    return (decoded['data'] as List<dynamic>)
        .map((branch) => Branch.fromJson(branch as Map<String, dynamic>))
        .toList();
  }
}

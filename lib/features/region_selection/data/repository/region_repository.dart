import 'dart:convert';

import 'package:wavex/core/networks/api_manager.dart';

import '../models/country.dart';

class RegionRepository {
  Future<List<Country>> getRegions() async {
    final response = await ApiManager.sendRequest(
      link: 'countries',
      method: Method.GET,
    );

    if (response == null || response.data == null) {
      throw Exception('No regions were returned by the server.');
    }

    final decoded = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;

    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw Exception('The region list has an unexpected format.');
    }

    return (decoded['data'] as List<dynamic>)
        .map((country) => Country.fromJson(country as Map<String, dynamic>))
        .toList();
  }
}

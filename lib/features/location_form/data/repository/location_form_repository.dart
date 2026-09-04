import 'dart:convert';

import 'package:wavex/core/networks/api_manager.dart';
import 'package:wavex/core/networks/request_body.dart';
import '../models/location_form_request.dart';

class LocationFormRepository {
  Future<String> submit(LocationFormRequest request) async {
    final response = await ApiManager.sendRequest(
      link: 'location-form-submissions',
      method: Method.POST,
      body: RequestBody(request.toJson()),
    );
    if (response == null) throw Exception('Unable to submit the form.');
    final body =
        response.data is String ? jsonDecode(response.data) : response.data;
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Unable to submit the form.');
    }
    return body is Map && body['message'] != null
        ? body['message'].toString()
        : 'Form submitted successfully.';
  }
}

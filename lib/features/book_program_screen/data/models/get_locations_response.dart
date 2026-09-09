class GetLocationsResponse {
  List<LocationData>? data;
  int? status;
  String? message;

  GetLocationsResponse({this.data, this.status, this.message});

  GetLocationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LocationData>[];
      json['data'].forEach((v) {
        data!.add(LocationData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class LocationData {
  int? id;
  String? areaName;
  String? venueName;
  String? phone;
  String? fullAddress;
  String? updatedAt;
  bool? isActive;
  bool? requiresFormSubmission;
  String? formSubmissionStatus;

  LocationData(
      {this.id,
      this.areaName,
      this.venueName,
      this.phone,
      this.fullAddress,
      this.updatedAt,
      this.isActive});

  LocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
    venueName = json['venue_name'];
    phone = json['phone'];
    fullAddress = json['full_address'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    requiresFormSubmission = json['requires_form_submission'] ??
        json['user_requires_form_submission'];
    formSubmissionStatus = json['form_submission_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area_name'] = areaName;
    data['venue_name'] = venueName;
    data['phone'] = phone;
    data['full_address'] = fullAddress;
    data['updated_at'] = updatedAt;
    data['is_active'] = isActive;
    data['requires_form_submission'] = requiresFormSubmission;
    data['form_submission_status'] = formSubmissionStatus;
    return data;
  }
}

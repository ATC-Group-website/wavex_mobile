class GetLocationsResponse {
  List<LocationData>? data;
  int? status;
  String? message;

  GetLocationsResponse({this.data, this.status, this.message});

  GetLocationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LocationData>[];
      json['data'].forEach((v) {
        data!.add(new LocationData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_name'] = this.areaName;
    data['venue_name'] = this.venueName;
    data['phone'] = this.phone;
    data['full_address'] = this.fullAddress;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    return data;
  }
}

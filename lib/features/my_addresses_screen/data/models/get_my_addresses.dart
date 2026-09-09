class GetMyAddressesResponse {
  List<AddressData>? data;
  dynamic status;
  String? message;

  GetMyAddressesResponse({this.data, this.status, this.message});

  GetMyAddressesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AddressData>[];
      json['data'].forEach((v) {
        data!.add(AddressData.fromJson(v));
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

class AddressData {
  dynamic id;
  dynamic userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? governorate;
  String? city;
  dynamic apartment;
  dynamic postalCode;
  String? createdAt;
  int? isDefault;
  String? updatedAt;

  AddressData(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.governorate,
      this.isDefault,
      this.city,
      this.apartment,
      this.postalCode,
      this.createdAt,
      this.updatedAt});

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    isDefault = json['is_default'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    governorate = json['governorate'];
    city = json['city'];
    apartment = json['apartment'];
    postalCode = json['postal_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['is_default'] = isDefault;
    data['address'] = address;
    data['governorate'] = governorate;
    data['city'] = city;
    data['apartment'] = apartment;
    data['postal_code'] = postalCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

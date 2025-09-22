class GetAddressByIdResponse {
  AddressData? data;
  dynamic status;
  String? message;

  GetAddressByIdResponse({this.data, this.status, this.message});

  GetAddressByIdResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new AddressData.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
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
  dynamic governorate;
  dynamic city;
  dynamic apartment;
  dynamic postalCode;
  dynamic isDefault;
  String? createdAt;
  String? updatedAt;

  AddressData(
      {this.id,
        this.userId,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.governorate,
        this.city,
        this.apartment,
        this.postalCode,
        this.isDefault,
        this.createdAt,
        this.updatedAt});

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    governorate = json['governorate'];
    city = json['city'];
    apartment = json['apartment'];
    postalCode = json['postal_code'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['governorate'] = this.governorate;
    data['city'] = this.city;
    data['apartment'] = this.apartment;
    data['postal_code'] = this.postalCode;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

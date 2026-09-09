class AddressRequestBody {
  String? name;
  String? phone;
  String? address;
  String? postalCode;
  String? email;
  String? notes;
  bool? isDefault;
  String? district;

  AddressRequestBody(
      {this.name,
      this.phone,
      this.address,
      this.postalCode,
      this.email,
      this.isDefault,
      this.notes,
      this.district});

  AddressRequestBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    postalCode = json['postal_code'];
    email = json['email'];
    notes = json['notes'];
    isDefault = json['is_default'];
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['postal_code'] = postalCode;
    data['email'] = email;
    data['is_default'] = isDefault;
    data['notes'] = notes;
    data['district'] = district;
    return data;
  }
}

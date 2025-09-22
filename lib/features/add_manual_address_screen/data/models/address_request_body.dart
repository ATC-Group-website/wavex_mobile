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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['postal_code'] = this.postalCode;
    data['email'] = this.email;
    data['is_default'] = this.isDefault;
    data['notes'] = this.notes;
    data['district'] = this.district;
    return data;
  }
}

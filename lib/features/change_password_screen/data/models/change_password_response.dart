class ChangePasswordResponse {
  Data? data;
  int? status;
  String? message;

  ChangePasswordResponse({this.data, this.status, this.message});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  dynamic dateOfBirth;
  String? gender;
  dynamic medicalConditions;
  dynamic emailVerifiedAt;
  String? image;
  int? isActive;
  dynamic deviceToken;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.dateOfBirth,
      this.gender,
      this.medicalConditions,
      this.emailVerifiedAt,
      this.image,
      this.isActive,
      this.deviceToken,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    medicalConditions = json['medical_conditions'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    isActive = json['is_active'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['medical_conditions'] = medicalConditions;
    data['email_verified_at'] = emailVerifiedAt;
    data['image'] = image;
    data['is_active'] = isActive;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UpdateUserDataResponse {
  Data? data;
  int? status;
  String? message;

  UpdateUserDataResponse({this.data, this.status, this.message});

  UpdateUserDataResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? dateOfBirth;
  String? gender;
  String? medicalConditions;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['medical_conditions'] = this.medicalConditions;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

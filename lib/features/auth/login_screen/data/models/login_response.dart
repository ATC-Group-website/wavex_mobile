class LoginResponse {
  String? message;
  String? token;
  int? expirationTime;
  User? user;

  LoginResponse({this.message, this.token, this.expirationTime, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    expirationTime = json['expiration_time'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['token'] = token;
    data['expiration_time'] = expirationTime;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic phone;
  dynamic dateOfBirth;
  String? gender;
  dynamic medicalConditions;
  dynamic emailVerifiedAt;
  String? image;
  int? isActive;
  bool? isAdmin;
  dynamic deviceToken;
  String? createdAt;
  String? updatedAt;

  User(
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
      this.isAdmin,
      this.deviceToken,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
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
    isAdmin = json['is_admin'];
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
    data['is_admin'] = isAdmin;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

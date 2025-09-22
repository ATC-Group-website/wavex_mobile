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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['expiration_time'] = this.expirationTime;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
    data['is_admin'] = this.isAdmin;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

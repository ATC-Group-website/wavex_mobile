class ResetPasswordResponse {
  Data? data;
  int? status;
  String? message;

  ResetPasswordResponse({this.data, this.status, this.message});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    // data = json['data'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // data['data'] = this.data;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? otp;
  String? email;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({this.otp, this.email, this.updatedAt, this.createdAt, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    email = json['email'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['email'] = this.email;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class ContactUsResponse {
  Data? data;
  int? status;
  String? message;

  ContactUsResponse({this.data, this.status, this.message});

  ContactUsResponse.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? email;
  String? phone;
  String? body;
  bool? isSubscribedToEmails;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.name,
      this.email,
      this.phone,
      this.body,
      this.isSubscribedToEmails,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    body = json['body'];
    isSubscribedToEmails = json['is_subscribed_to_emails'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['body'] = body;
    data['is_subscribed_to_emails'] = isSubscribedToEmails;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

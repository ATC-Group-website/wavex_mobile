class ContactUsResponse {
  Data? data;
  int? status;
  String? message;

  ContactUsResponse({this.data, this.status, this.message});

  ContactUsResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['body'] = this.body;
    data['is_subscribed_to_emails'] = this.isSubscribedToEmails;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

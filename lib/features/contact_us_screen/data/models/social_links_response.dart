class SocialLinksResponse {
  Data? data;
  int? status;
  String? message;

  SocialLinksResponse({this.data, this.status, this.message});

  SocialLinksResponse.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? facebook;
  String? x;
  String? instagram;
  String? tiktok;
  String? linkedin;

  Data(
      {this.email,
        this.facebook,
        this.x,
        this.instagram,
        this.tiktok,
        this.linkedin});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    facebook = json['facebook'];
    x = json['x'];
    instagram = json['instagram'];
    tiktok = json['tiktok'];
    linkedin = json['linkedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['facebook'] = this.facebook;
    data['x'] = this.x;
    data['instagram'] = this.instagram;
    data['tiktok'] = this.tiktok;
    data['linkedin'] = this.linkedin;
    return data;
  }
}

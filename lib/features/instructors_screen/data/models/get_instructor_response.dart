class GetInstructorResponse {
  Data? data;
  int? status;
  String? message;

  GetInstructorResponse({this.data, this.status, this.message});

  GetInstructorResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic phone;
  String? bio;
  String? image;
  List<String>? specializations;
  bool? isActive;
  String? createdAt;
  List<Null>? links;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.bio,
        this.image,
        this.specializations,
        this.isActive,
        this.createdAt,
        this.links});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    bio = json['bio'];
    image = json['image'];
    specializations = json['specializations'].cast<String>();
    isActive = json['is_active'];
    createdAt = json['created_at'];
    if (json['links'] != null) {
      links = <Null>[];
      json['links'].forEach((v) {
        links!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['specializations'] = this.specializations;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v).toList();
    }
    return data;
  }
}

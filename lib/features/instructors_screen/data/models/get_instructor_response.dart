class GetInstructorResponse {
  Data? data;
  int? status;
  String? message;

  GetInstructorResponse({this.data, this.status, this.message});

  GetInstructorResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['bio'] = bio;
    data['image'] = image;
    data['specializations'] = specializations;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    if (links != null) {
      data['links'] = links!.map((v) => v).toList();
    }
    return data;
  }
}

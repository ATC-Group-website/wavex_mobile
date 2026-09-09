class GetInstructorsResponse {
  List<InstructorData>? data;
  int? status;
  String? message;

  GetInstructorsResponse({this.data, this.status, this.message});

  GetInstructorsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InstructorData>[];
      json['data'].forEach((v) {
        data!.add(InstructorData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class InstructorData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? bio;
  String? image;
  List<String>? specializations;
  bool? isActive;

  InstructorData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.bio,
      this.image,
      this.specializations,
      this.isActive});

  InstructorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    bio = json['bio'];
    image = json['image'];
    specializations = json['specializations'].cast<String>();
    isActive = json['is_active'];
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
    return data;
  }
}

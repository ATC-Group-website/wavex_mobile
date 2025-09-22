class GetInstructorsResponse {
  List<InstructorData>? data;
  int? status;
  String? message;

  GetInstructorsResponse({this.data, this.status, this.message});

  GetInstructorsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InstructorData>[];
      json['data'].forEach((v) {
        data!.add(new InstructorData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
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
    return data;
  }
}

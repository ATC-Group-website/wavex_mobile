class GetProgramsResponse {
  List<ProgramData>? data;
  int? status;
  String? message;

  GetProgramsResponse({this.data, this.status, this.message});

  GetProgramsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProgramData>[];
      json['data'].forEach((v) {
        data!.add(new ProgramData.fromJson(v));
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

class ProgramData {
  int? id;
  String? name;
  String? subtitle;
  String? description;
  String? mainImage;
  String? coverImage;
  List<String>? benefits;
  bool? isActive;

  ProgramData(
      {this.id,
        this.name,
        this.subtitle,
        this.description,
        this.mainImage,
        this.coverImage,
        this.benefits,
        this.isActive});

  ProgramData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subtitle = json['subtitle'];
    description = json['description'];
    mainImage = json['main_image'];
    coverImage = json['cover_image'];
    benefits = json['benefits'].cast<String>();
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['main_image'] = this.mainImage;
    data['cover_image'] = this.coverImage;
    data['benefits'] = this.benefits;
    data['is_active'] = this.isActive;
    return data;
  }
}

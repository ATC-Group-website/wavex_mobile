class GetProgramsResponse {
  List<ProgramData>? data;
  int? status;
  String? message;

  GetProgramsResponse({this.data, this.status, this.message});

  GetProgramsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProgramData>[];
      json['data'].forEach((v) {
        data!.add(ProgramData.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['main_image'] = mainImage;
    data['cover_image'] = coverImage;
    data['benefits'] = benefits;
    data['is_active'] = isActive;
    return data;
  }
}

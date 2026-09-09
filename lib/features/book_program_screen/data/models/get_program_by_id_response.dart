class GetProgramByIdResponse {
  ProgramData? data;
  int? status;
  String? message;

  GetProgramByIdResponse({this.data, this.status, this.message});

  GetProgramByIdResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProgramData.fromJson(json['data']) : null;
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

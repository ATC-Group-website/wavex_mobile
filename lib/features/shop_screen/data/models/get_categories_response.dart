class GetCategoriesResponse {
  List<CategoriesData>? data;
  int? status;
  String? message;

  GetCategoriesResponse({this.data, this.status, this.message});

  GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoriesData>[];
      json['data'].forEach((v) {
        data!.add(CategoriesData.fromJson(v));
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

class CategoriesData {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? sortOrder;

  CategoriesData(
      {this.id, this.name, this.slug, this.description, this.sortOrder});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['sort_order'] = sortOrder;
    return data;
  }
}

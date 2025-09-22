class GetCategoriesResponse {
  List<CategoriesData>? data;
  int? status;
  String? message;

  GetCategoriesResponse({this.data, this.status, this.message});

  GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoriesData>[];
      json['data'].forEach((v) {
        data!.add(new CategoriesData.fromJson(v));
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

class CategoriesData {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? sortOrder;

  CategoriesData({this.id, this.name, this.slug, this.description, this.sortOrder});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}

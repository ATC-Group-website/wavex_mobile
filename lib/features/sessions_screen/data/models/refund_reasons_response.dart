class RefundReasonsResponse {
  List<String>? data;
  int? status;
  String? message;

  RefundReasonsResponse({this.data, this.status, this.message});

  RefundReasonsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<String>();
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class RefundResponse {
  Data? data;
  int? status;
  String? message;

  RefundResponse({this.data, this.status, this.message});

  RefundResponse.fromJson(Map<String, dynamic> json) {
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
  String? message;
  int? bookingId;
  int? paymentId;
  String? refundAmount;
  String? currency;

  Data(
      {this.message,
        this.bookingId,
        this.paymentId,
        this.refundAmount,
        this.currency});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    bookingId = json['booking_id'];
    paymentId = json['payment_id'];
    refundAmount = json['refund_amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['booking_id'] = this.bookingId;
    data['payment_id'] = this.paymentId;
    data['refund_amount'] = this.refundAmount;
    data['currency'] = this.currency;
    return data;
  }
}

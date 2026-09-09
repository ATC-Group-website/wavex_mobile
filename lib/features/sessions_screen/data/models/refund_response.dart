class RefundResponse {
  Data? data;
  int? status;
  String? message;

  RefundResponse({this.data, this.status, this.message});

  RefundResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['booking_id'] = bookingId;
    data['payment_id'] = paymentId;
    data['refund_amount'] = refundAmount;
    data['currency'] = currency;
    return data;
  }
}

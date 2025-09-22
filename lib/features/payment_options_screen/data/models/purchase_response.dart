class PurchaseResponse {
  Data? data;
  int? status;
  String? message;

  PurchaseResponse({this.data, this.status, this.message});

  PurchaseResponse.fromJson(Map<String, dynamic> json) {
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
  String? clientSecret;
  PaymentIntent? paymentIntent;
  String? orderId;

  Data({this.clientSecret, this.paymentIntent, this.orderId});

  Data.fromJson(Map<String, dynamic> json) {
    clientSecret = json['client_secret'];
    paymentIntent = json['payment_intent'] != null
        ? new PaymentIntent.fromJson(json['payment_intent'])
        : null;
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_secret'] = this.clientSecret;
    if (this.paymentIntent != null) {
      data['payment_intent'] = this.paymentIntent!.toJson();
    }
    data['order_id'] = this.orderId;
    return data;
  }
}

class PaymentIntent {
  String? id;
  String? status;
  int? amount;
  String? currency;
  String? description;

  PaymentIntent(
      {this.id, this.status, this.amount, this.currency, this.description});

  PaymentIntent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'];
    currency = json['currency'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['description'] = this.description;
    return data;
  }
}

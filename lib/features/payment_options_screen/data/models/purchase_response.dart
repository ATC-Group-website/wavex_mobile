class PurchaseResponse {
  Data? data;
  int? status;
  String? message;

  PurchaseResponse({this.data, this.status, this.message});

  PurchaseResponse.fromJson(Map<String, dynamic> json) {
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
  String? clientSecret;
  PaymentIntent? paymentIntent;
  String? orderId;

  Data({this.clientSecret, this.paymentIntent, this.orderId});

  Data.fromJson(Map<String, dynamic> json) {
    clientSecret = json['client_secret'];
    paymentIntent = json['payment_intent'] != null
        ? PaymentIntent.fromJson(json['payment_intent'])
        : null;
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_secret'] = clientSecret;
    if (paymentIntent != null) {
      data['payment_intent'] = paymentIntent!.toJson();
    }
    data['order_id'] = orderId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['amount'] = amount;
    data['currency'] = currency;
    data['description'] = description;
    return data;
  }
}

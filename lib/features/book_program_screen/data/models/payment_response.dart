class PaymentResponse {
  bool? success;
  String? clientSecret;
  PaymentIntent? paymentIntent;
  PaymentRecord? paymentRecord;

  PaymentResponse(
      {this.success,
      this.clientSecret,
      this.paymentIntent,
      this.paymentRecord});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    clientSecret = json['client_secret'];
    paymentIntent = json['payment_intent'] != null
        ? PaymentIntent.fromJson(json['payment_intent'])
        : null;
    paymentRecord = json['payment_record'] != null
        ? PaymentRecord.fromJson(json['payment_record'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['client_secret'] = clientSecret;
    if (paymentIntent != null) {
      data['payment_intent'] = paymentIntent!.toJson();
    }
    if (paymentRecord != null) {
      data['payment_record'] = paymentRecord!.toJson();
    }
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

class PaymentRecord {
  int? id;
  String? status;

  PaymentRecord({this.id, this.status});

  PaymentRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}

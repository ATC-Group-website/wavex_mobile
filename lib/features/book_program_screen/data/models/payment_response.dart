class PaymentResponse {
  bool? success;
  String? gateway;
  String? clientSecret;
  String? redirectUrl;
  PaymentIntent? paymentIntent;
  PaymentRecord? paymentRecord;

  bool get supportsStripePaymentSheet =>
      success == true &&
      gateway == 'stripe' &&
      clientSecret != null &&
      clientSecret!.isNotEmpty;

  PaymentResponse(
      {this.success,
      this.gateway,
      this.clientSecret,
      this.redirectUrl,
      this.paymentIntent,
      this.paymentRecord});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    gateway = json['gateway'];
    clientSecret = json['client_secret'];
    redirectUrl = json['redirect_url'];
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
    data['gateway'] = gateway;
    data['client_secret'] = clientSecret;
    data['redirect_url'] = redirectUrl;
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
  int? slots;
  int? sessionId;
  int? packageId;
  dynamic amount;
  String? currency;

  PaymentRecord({
    this.id,
    this.status,
    this.slots,
    this.sessionId,
    this.packageId,
    this.amount,
    this.currency,
  });

  PaymentRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    slots = json['slots'];
    sessionId = json['session_id'];
    packageId = json['package_id'];
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['slots'] = slots;
    data['session_id'] = sessionId;
    data['package_id'] = packageId;
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}

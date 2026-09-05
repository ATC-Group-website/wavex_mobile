class PaymentResponse {
  bool? success;
  String? clientSecret;
  PaymentIntent? paymentIntent;
  PaymentRecord? paymentRecord;

  PaymentResponse({
    this.success,
    this.clientSecret,
    this.paymentIntent,
    this.paymentRecord,
  });

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    clientSecret = json['client_secret'];
    paymentIntent = json['payment_intent'] != null
        ? new PaymentIntent.fromJson(json['payment_intent'])
        : null;
    paymentRecord = json['payment_record'] != null
        ? new PaymentRecord.fromJson(json['payment_record'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['client_secret'] = this.clientSecret;
    if (this.paymentIntent != null) {
      data['payment_intent'] = this.paymentIntent!.toJson();
    }
    if (this.paymentRecord != null) {
      data['payment_record'] = this.paymentRecord!.toJson();
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

  PaymentIntent({
    this.id,
    this.status,
    this.amount,
    this.currency,
    this.description,
  });

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

class PaymentRecord {
  int? id;
  String? status;
  int? slots;
  String? reservationExpiresAt;

  PaymentRecord({this.id, this.status, this.slots, this.reservationExpiresAt});

  PaymentRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    slots = json['slots'];
    reservationExpiresAt = json['reservation_expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['slots'] = this.slots;
    data['reservation_expires_at'] = this.reservationExpiresAt;
    return data;
  }
}

class OrderDetailsResponse {
  OrderData? data;
  int? status;
  String? message;

  OrderDetailsResponse({this.data, this.status, this.message});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
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

class OrderData {
  String? id;
  int? userId;
  String? status;
  double? cost;
  int? shippingFees;
  double? total;
  String? paymentMethod;
  String? paymentStatus;
  dynamic transactionReference;
  int? addressId;
  String? boughtAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic cancelledAt;
  dynamic deletedBy;
  dynamic notes;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  User? user;
  Address? address;
  List<OrderItems>? orderItems;

  OrderData(
      {this.id,
      this.userId,
      this.status,
      this.cost,
      this.shippingFees,
      this.total,
      this.paymentMethod,
      this.paymentStatus,
      this.transactionReference,
      this.addressId,
      this.boughtAt,
      this.shippedAt,
      this.deliveredAt,
      this.cancelledAt,
      this.deletedBy,
      this.notes,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.address,
      this.orderItems});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    status = json['status'];
    cost = json['cost'];
    shippingFees = json['shipping_fees'];
    total = json['total'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    transactionReference = json['transaction_reference'];
    addressId = json['address_id'];
    boughtAt = json['bought_at'];
    shippedAt = json['shipped_at'];
    deliveredAt = json['delivered_at'];
    cancelledAt = json['cancelled_at'];
    deletedBy = json['deleted_by'];
    notes = json['notes'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['status'] = status;
    data['cost'] = cost;
    data['shipping_fees'] = shippingFees;
    data['total'] = total;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['transaction_reference'] = transactionReference;
    data['address_id'] = addressId;
    data['bought_at'] = boughtAt;
    data['shipped_at'] = shippedAt;
    data['delivered_at'] = deliveredAt;
    data['cancelled_at'] = cancelledAt;
    data['deleted_by'] = deletedBy;
    data['notes'] = notes;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  User({this.id, this.firstName, this.lastName, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Address {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  dynamic governorate;
  dynamic city;
  dynamic apartment;
  String? postalCode;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.governorate,
      this.city,
      this.apartment,
      this.postalCode,
      this.isDefault,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    governorate = json['governorate'];
    city = json['city'];
    apartment = json['apartment'];
    postalCode = json['postal_code'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['governorate'] = governorate;
    data['city'] = city;
    data['apartment'] = apartment;
    data['postal_code'] = postalCode;
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OrderItems {
  String? orderId;
  int? productId;
  int? quantity;
  String? price;
  String? total;

  OrderItems(
      {this.orderId, this.productId, this.quantity, this.price, this.total});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    return data;
  }
}

class OrderDetailsResponse {
  OrderData? data;
  int? status;
  String? message;

  OrderDetailsResponse({this.data, this.status, this.message});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['cost'] = this.cost;
    data['shipping_fees'] = this.shippingFees;
    data['total'] = this.total;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['transaction_reference'] = this.transactionReference;
    data['address_id'] = this.addressId;
    data['bought_at'] = this.boughtAt;
    data['shipped_at'] = this.shippedAt;
    data['delivered_at'] = this.deliveredAt;
    data['cancelled_at'] = this.cancelledAt;
    data['deleted_by'] = this.deletedBy;
    data['notes'] = this.notes;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['governorate'] = this.governorate;
    data['city'] = this.city;
    data['apartment'] = this.apartment;
    data['postal_code'] = this.postalCode;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    return data;
  }
}

class GetCartResponse {
  OrderData? data;
  int? status;
  String? message;

  GetCartResponse({this.data, this.status, this.message});

  GetCartResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic cost;
  dynamic shippingFees;
  dynamic total;
  String? paymentMethod;
  String? paymentStatus;
  dynamic transactionReference;
  dynamic addressId;
  dynamic boughtAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic cancelledAt;
  dynamic deletedBy;
  dynamic notes;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
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
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  int? id;
  String? orderId;
  int? productId;
  int? quantity;
  String? price;
  String? total;
  String? createdAt;
  String? updatedAt;
  Product? product;

  OrderItems(
      {this.id,
      this.orderId,
      this.productId,
      this.quantity,
      this.price,
      this.total,
      this.createdAt,
      this.updatedAt,
      this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? image;

  Product({this.id, this.name, this.image});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

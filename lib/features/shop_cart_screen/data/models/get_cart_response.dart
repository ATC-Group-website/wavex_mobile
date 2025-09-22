class GetCartResponse {
  OrderData? data;
  int? status;
  String? message;

  GetCartResponse({this.data, this.status, this.message});

  GetCartResponse.fromJson(Map<String, dynamic> json) {
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
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
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
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

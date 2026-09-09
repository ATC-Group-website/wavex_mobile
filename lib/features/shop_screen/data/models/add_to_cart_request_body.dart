class AddToCartRequestBody {
  String? orderId;
  List<OrderItem>? orderItems;

  AddToCartRequestBody({this.orderItems, this.orderId});

  AddToCartRequestBody.fromJson(Map<String, dynamic> json) {
    orderId = json["order_id"];
    if (json['order_items'] != null) {
      orderItems = <OrderItem>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderId != null) {
      data['order_id'] = orderId;
    }
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  String? productId;
  int? quantity;

  OrderItem({this.productId, this.quantity});

  OrderItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}

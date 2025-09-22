class AddToCartRequestBody {
  String? orderId;
  List<OrderItem>? orderItems;

  AddToCartRequestBody({this.orderItems,this.orderId});

  AddToCartRequestBody.fromJson(Map<String, dynamic> json) {
    orderId = json["order_id"];
    if (json['order_items'] != null) {
      orderItems = <OrderItem>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.orderId !=null){
      data['order_id'] = this.orderId;
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }
}

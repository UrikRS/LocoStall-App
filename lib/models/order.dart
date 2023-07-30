class Order {
  final int prodId;
  final int qty;

  Order(this.prodId, this.qty);

  Map<String, dynamic> toJson() => {
        'prod_id': prodId,
        'qty': qty,
      };
}

class OrderList {
  final String createAt;
  final List<Order> orderList;
  final String payment;
  final int shopId;
  final String updateAt;
  final int userId;

  OrderList({
    this.createAt = '',
    this.orderList = const [],
    this.payment = '',
    this.shopId = 0,
    this.updateAt = '',
    this.userId = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'create_at': createAt,
      'order_list': orderList.map((order) => order.toJson()).toList(),
      'payment': payment,
      'shop_id': shopId,
      'update_at': updateAt,
      'user_id': userId,
    };
  }
}

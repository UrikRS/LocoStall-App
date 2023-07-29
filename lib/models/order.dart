class Order {
  final int prodId;
  final int qty;

  Order(this.prodId, this.qty);
}

class OrderList {
  final String createAt;
  final List<Order> orderList;
  final String payment;
  final int shopId;
  final String updateAt;
  final int userId;

  OrderList(
    this.createAt,
    this.orderList,
    this.payment,
    this.shopId,
    this.updateAt,
    this.userId,
  );
}

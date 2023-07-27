class Order {
  final int prodId;
  final int qty;

  Order(this.prodId, this.qty);
}

class OrderList {
  final DateTime createAt;
  final int id;
  final List<Order> orderList;
  final String payment;
  final int shopId;
  final DateTime updateAt;
  final int userId;

  OrderList(
    this.createAt,
    this.id,
    this.orderList,
    this.payment,
    this.shopId,
    this.updateAt,
    this.userId,
  );
}

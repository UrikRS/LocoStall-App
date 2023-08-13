class Item {
  final int prodId;
  final int qty;
  String? name;
  int? price;

  Item(this.prodId, this.qty);

  Map<String, dynamic> toJson() => {
        'prod_id': prodId,
        'qty': qty,
      };
}

class Order {
  final List<Item> itemList;
  final String payment;
  final int shopId;
  final int userId;
  final String? state;
  final String? createAt;
  final String? updateAt;
  final String? shopName;

  Order({
    this.itemList = const [],
    this.payment = '',
    this.shopId = 0,
    this.userId = 0,
    this.state = '',
    this.createAt = '',
    this.updateAt = '',
    this.shopName = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'item_list': itemList.map((item) => item.toJson()).toList(),
      'payment': payment,
      'shop_id': shopId,
      'user_id': userId,
    };
  }
}

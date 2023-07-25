import 'package:locostall/models/menu.dart';

class Shop {
  String id;
  String lang;
  String name;
  String shopId;

  Shop(
    this.id,
    this.lang,
    this.name,
    this.shopId,
  );
}

class ShopDetail {
  String id;
  String shopId;
  String name;
  String lang;
  String rating;
  List<Menu> menus;

  ShopDetail(
    this.id,
    this.shopId,
    this.name,
    this.lang,
    this.rating,
    this.menus,
  );
}

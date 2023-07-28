import 'package:locostall/models/menu.dart';

class Shop {
  final int id;
  final String lang;
  final String name;
  final int shopId;
  final dynamic description;

  Shop(
    this.id,
    this.lang,
    this.name,
    this.shopId,
    this.description,
  );
}

class ShopDetail {
  final int id;
  final int shopId;
  final String name;
  final String lang;
  final int rating;
  final List<Menu>? menus;

  ShopDetail(
    this.id,
    this.shopId,
    this.name,
    this.lang,
    this.rating,
    this.menus,
  );

  Menu? findMenuById(int menuId) {
    for (Menu menu in menus!) {
      if (menu.id == menuId) {
        return menu;
      }
    }
  }
}

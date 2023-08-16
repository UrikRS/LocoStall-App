import 'package:locostall/models/menu.dart';

class Shop {
  final String name;
  final int shopId;
  final String description;
  final String cover;

  Shop(
    this.name,
    this.shopId,
    this.description,
    this.cover,
  );
}

class ShopDetail {
  final int id;
  final int shopId;
  final String name;
  final String lang;
  final int rating;
  final List<Menu>? menus;
  final String description;
  final String cover;

  ShopDetail(
    this.id,
    this.shopId,
    this.name,
    this.lang,
    this.rating,
    this.menus,
    this.description,
    this.cover,
  );

  Menu? findMenuById(int prodId) {
    for (Menu menu in menus!) {
      if (menu.prodId == prodId) {
        return menu;
      }
    }
    return null;
  }
}

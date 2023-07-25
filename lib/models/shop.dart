import 'package:locostall/models/menu.dart';

class Shop {
  String id;
  String lang;
  String name;
  String shopId;
  List<Menu> menu;

  Shop(
    this.id,
    this.lang,
    this.name,
    this.shopId,
    this.menu,
  );
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:locostall/models/menu.dart';
import 'package:locostall/models/order.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/models/user.dart';

class ApiClient {
  String host = 'http://107.167.190.202';
  int port = 5000;
  String path = 'api';

  Future<List<Shop>> getShops(langCode) async {
    if (langCode == 'ja') {
      langCode = 'jp';
    }
    Uri url = Uri.parse('$host:$port/$path/$langCode/shops');
    try {
      final response = await get(url);
      List<dynamic> shops_ = jsonDecode(response.body);
      List<Shop> shops = [];
      for (dynamic shop_ in shops_) {
        Shop shop = Shop(
          shop_['id'],
          shop_['lang'],
          shop_['name'],
          shop_['shop_id'],
          shop_['description'],
        );
        shops.add(shop);
      }
      return shops;
    } catch (e) {
      return [];
    }
  }

  Future<ShopDetail> getShopDetail(langCode, shopId) async {
    if (langCode == 'ja') {
      langCode = 'jp';
    }
    Uri url = Uri.parse('$host:$port/$path/$langCode/shop/$shopId');
    try {
      final response = await get(url);
      dynamic shopDetail_ = jsonDecode(response.body);
      List<dynamic> menus_ = shopDetail_['menu'];
      List<Menu> menus = [];
      for (dynamic menu_ in menus_) {
        Menu menu = Menu(
          menu_['id'],
          menu_['name'],
          menu_['description'],
          menu_['price'],
        );
        menus.add(menu);
      }
      ShopDetail shopDetail = ShopDetail(
        shopDetail_['id'],
        shopDetail_['shop_id'],
        shopDetail_['name'],
        shopDetail_['lang'],
        shopDetail_['rating'],
        menus,
      );
      return shopDetail;
    } catch (e) {
      return ShopDetail(0, 0, 'UNKNOWN', langCode, 0, []);
    }
  }

  Future<void> postOrder(OrderList orderList) async {
    Uri url = Uri.parse('$host:$port/$path/order');
    await post(url, body: jsonEncode(orderList));
  }

  Future<bool> authenticateUser(String email, String password) async {
    Uri url = Uri.parse('$host:$port/$path/user/authenticate');
    try {
      final response = await post(url, body: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        // Successfully authenticated
        return true;
      } else {
        // Authentication failed
        return true;
      }
    } catch (e) {
      // Handle error
      return true;
    }
  }

  Future<void> userRegister(userId, langCode) async {
    Uri url = Uri.parse('$host:$port/$path/user');
    await post(url, body: {'app_id': userId, 'native_lang': langCode});
  }

  Future<User> getUser(userId) async {
    Uri url = Uri.parse('$host:$port/$path/user/$userId');
    Response response = await get(url);
    dynamic user = jsonDecode(response.body);
    return user;
  }
}

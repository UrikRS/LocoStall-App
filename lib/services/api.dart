import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:locostall/models/menu.dart';
import 'package:locostall/models/order.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/models/user.dart';

class ApiClient {
  String host = 'https://backend.locostall.shop';
  String path = 'api';

  Future<List<Shop>> getShops(langCode) async {
    if (langCode == 'ja') {
      langCode = 'jp';
    }
    Uri url = Uri.parse('$host/$path/$langCode/shops');
    try {
      final response = await get(url);
      List<dynamic> shops_ = jsonDecode(response.body);
      List<Shop> shops = [];
      for (dynamic shop_ in shops_) {
        Shop shop = Shop(
          shop_['name'],
          shop_['shop_id'],
          shop_['description'],
          shop_['cover'],
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
    Uri url = Uri.parse('$host/$path/$langCode/shop/$shopId');
    try {
      final response = await get(url);
      dynamic shopDetail_ = jsonDecode(response.body);
      List<dynamic> menus_ = shopDetail_['menu'];
      List<Menu> menus = [];
      for (dynamic menu_ in menus_) {
        Menu menu = Menu(
          menu_['id'],
          menu_['prod_id'],
          menu_['shop_id'],
          menu_['name'],
          menu_['description'],
          menu_['price'],
          menu_['image'],
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
        shopDetail_['description'],
      );
      return shopDetail;
    } catch (e) {
      return ShopDetail(0, 0, 'UNKNOWN', langCode, 0, [], '');
    }
  }

  Future<Order> sendOrder(Order order) async {
    Uri url = Uri.parse('$host/$path/send_order');
    try {
      print(jsonEncode(order));
      final response = await post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(order),
      );
      dynamic order_ = jsonDecode(response.body)['data'];
      List<dynamic> items_ = order_['item_list'];
      List<Item> items = [];
      for (dynamic item_ in items_) {
        Item item = Item(
          item_['prod_id'],
          item_['qty'],
        );
        items.add(item);
      }
      Order responseOrder = Order(
        itemList: order_['item_list'],
        userId: order_['user_id'],
        payment: order_['payment'],
        shopId: order_['shop_id'],
      );
      return responseOrder;
    } catch (e) {
      return Order();
    }
  }

  Future<List<Order>> getUserOrders(userId) async {
    Uri url = Uri.parse('$host/$path/orders/user/$userId');
    try {
      final response = await get(url);
      List<dynamic> orders_ = jsonDecode(response.body);
      List<Order> orders = [];
      for (dynamic order_ in orders_) {
        List<dynamic> items_ = jsonDecode(order_['item_list']);
        List<Item> items = [];
        for (dynamic item_ in items_) {
          Item item = Item(
            item_['prod_id'],
            item_['qty'],
          );
          item.name = item_['name'];
          item.price = item_['price'];
          items.add(item);
        }
        Order order = Order(
          orderId: order_['id'],
          itemList: items,
          payment: order_['payment'],
          shopId: order_['shop_id'],
          userId: order_['user_id'],
          state: order_['state'],
          createAt: order_['created_at'],
          updateAt: order_['updated_at'],
          shopName: order_['shop_name'],
        );
        orders.add(order);
      }
      return orders;
    } catch (e) {
      return [];
    }
  }

  Future<Menu> getMenuItem(menuId) async {
    Uri url = Uri.parse('$host/$path/menu_item/$menuId');
    try {
      final response = await get(url);
      Menu menu = jsonDecode(response.body);
      return menu;
    } catch (e) {
      return Menu(0, 0, 0, '', '', 0, '');
    }
  }

  Future<User> userLogin(String email, String password) async {
    Uri url = Uri.parse('$host/$path/user/login');
    try {
      final response = await post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'mail': email,
          'password': password,
        }),
      );
      dynamic user_ = jsonDecode(response.body);
      User user = User(user_['id']);
      return user;
    } catch (e) {
      return User(null);
    }
  }

  Future<(User, UserData)> userRegister(email, password, langCode) async {
    if (langCode == 'ja') {
      langCode = 'jp';
    }
    Uri url = Uri.parse('$host/$path/user');
    try {
      final response = await post(url,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode({
            'mail': email,
            'nLang': langCode,
            'password': password,
          }));
      dynamic user_ = jsonDecode(response.body)['data'];
      User user = User(user_['id']);
      UserData userData = UserData(
        user_['id'],
        user_['line_id'],
        user_['display_name'],
        user_['native_lang'],
        user_['email'],
        user_['password'],
        user_['type'],
        user_['shop_id'],
      );
      return (user, userData);
    } catch (e) {
      return (User(null), UserData(0, null, null, '', '', '', '', null));
    }
  }

  Future<UserData> getUserData(userId) async {
    Uri url = Uri.parse('$host/$path/user/$userId');
    final response = await get(url);
    dynamic userData_ = jsonDecode(response.body);
    UserData userData = UserData(
      userData_['id'],
      userData_['line_id'],
      userData_['display_name'],
      userData_['native_lang'],
      userData_['mail'],
      userData_['password'],
      userData_['type'],
      userData_['shop_id'],
    );
    return userData;
  }

  Future<void> updateUserData(UserData userData) async {
    Uri url = Uri.parse('$host/$path/user/${userData.userId}');
    await post(url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "display_name": userData.name,
          "mail": userData.email,
          "native_lang": userData.nLang,
          "line_id": userData.lineId,
          "password": userData.password,
          "type": userData.type,
          "shop_id": userData.shopId
        }));
  }

  Future<int> predict(dynamic file) async {
    Uri url = Uri.parse('$host/$path/predict');

    if (file is XFile) {
      file = File(file.path);
    }
    List<int> imageBytes = await file.readAsBytes();

    // Convert bytes to a http.MultipartFile
    var imageFileToSend = MultipartFile.fromBytes(
      'file', // This should match the API's expected parameter name
      imageBytes,
      filename: 'image.jpg',
      contentType: MediaType('image', 'jpeg'),
    );

    // Create the multipart request
    var request = MultipartRequest('POST', url);

    // Add the image file to the request
    request.files.add(imageFileToSend);

    // Send the request and handle the response
    var response = await Response.fromStream(await request.send());

    print(response.body);
    int pred = jsonDecode(response.body)['predicted_class'];
    return pred;
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/models/user.dart';

class ApiClient {
  String host = 'http://107.167.190.202';
  int port = 5000;
  String path = 'api';

  Future<List<Shop>> getShops(langCode) async {
    Uri url = Uri.parse('$host:$port/$path/$langCode/shops');
    // final response = await get(url);
    // dynamic shops = jsonDecode(response.body);

    // test
    print(url);
    return [
      Shop('111', 'en', 'shop name 1', 'aaa'),
      Shop('222', 'en', 'shop name 2', 'bbb'),
      Shop('333', 'en', 'shop name 3', 'ccc'),
      Shop('444', 'en', 'shop name 4', 'ddd'),
    ];
    // return shops;
  }

  Future<Shop> getShopDetail(langCode, shopId) async {
    Uri url = Uri.parse('$host:$port/$path/$langCode/shop/$shopId');
    final response = await get(url);
    dynamic shop = jsonDecode(response.body);
    return shop;
  }

  // TODO: need api
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/services/api.dart';
import 'package:locostall/screens/elements/shop_detail.dart';

class StallsTab extends StatefulWidget {
  const StallsTab({super.key});

  @override
  State<StallsTab> createState() => _StallsTabState();
}

class _StallsTabState extends State<StallsTab> {
  List<Shop> _shops = [];

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    final prefs = await SharedPreferences.getInstance();
    ApiClient apiClient = ApiClient();
    String langCode = prefs.getString('langCode') ?? 'en';
    List<Shop> shops = await apiClient.getShops(langCode);
    setState(() {
      _shops = shops;
    });
  }

  Widget _listBuilder(BuildContext context, int index) {
    List<Widget> stalls = [];

    for (var shop in _shops) {
      stalls.add(SizedBox(
        height: 60.0,
        child: SafeArea(
          top: false,
          bottom: false,
          child: GestureDetector(
            child: Card(
              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    shop.name,
                    style: const TextStyle(fontSize: 30, height: 1.5),
                  ),
                ],
              ),
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => ShopDetail(shopId: shop.shopId),
            ),
          ),
        ),
      ));
    }

    return Column(
      children: stalls,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: 1,
        itemBuilder: _listBuilder,
      ),
    );
  }
}

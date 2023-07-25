import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/services/api.dart';
import 'package:locostall/screens/elements/shop_detail.dart';

class ShopsTab extends StatefulWidget {
  const ShopsTab({super.key});

  @override
  State<ShopsTab> createState() => _ShopsTabState();
}

class _ShopsTabState extends State<ShopsTab> {
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

  Widget _shopsListBuilder(BuildContext context, int index) {
    List<Widget> Shops = [];

    for (var shop in _shops) {
      Shops.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              elevation: 3.0,
              child: TransparentImageCard(
                width: double.infinity,
                endColor: Colors.white30,
                borderRadius: 10.0,
                tags: const [
                  Text('category 1'),
                  Text('category 2'),
                  Text('category 3'),
                  Text('category 4')
                ],
                title: Text(
                  shop.name,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                description: Text('${shop.name} description'),
                footer: Text('${shop.name} footer'),
                imageProvider: const NetworkImage(
                  'https://dummyimage.com/600x400/ccc/fff.jpg&text=stall-image',
                ),
              ),
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => ShopDetailDialog(shopId: shop.shopId),
            ),
          ),
        ),
      );
    }

    return Column(
      children: Shops,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: 1,
        itemBuilder: _shopsListBuilder,
      ),
    );
  }
}

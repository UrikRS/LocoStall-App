import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_card/image_card.dart';
import 'package:locostall/bloc/all.dart';
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
    final languageBloc = BlocProvider.of<LanguageBloc>(context);
    List<Shop> shops = await ApiClient().getShops(languageBloc.state.langCode);
    if (mounted) {
      setState(() {
        _shops = shops;
      });
    }
  }

  Widget _shopsListBuilder(BuildContext context, int index) {
    List<Widget> shops = [];

    for (Shop shop in _shops) {
      shops.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8,
          ),
          child: GestureDetector(
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              elevation: 3.0,
              child: TransparentImageCard(
                width: double.infinity,
                endColor: Colors.black87,
                borderRadius: 10.0,
                imageProvider:
                    AssetImage('lib/assets/shops/${shop.shopId}.jpg'),
                title: Text(
                  shop.name,
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
                description: Text(
                  shop.description,
                  style: const TextStyle(color: Colors.white),
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

    return Column(children: shops);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (context, state) {
        _setData();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: 1,
        itemBuilder: _shopsListBuilder,
      ),
    );
  }
}

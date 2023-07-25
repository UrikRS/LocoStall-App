import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_card/image_card.dart';
import 'package:locostall/models/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locostall/services/api.dart';

class ShopDetailDialog extends StatefulWidget {
  const ShopDetailDialog({super.key, required this.shopId});
  final String shopId;

  @override
  State<ShopDetailDialog> createState() => _ShopDetailDialogState();
}

class _ShopDetailDialogState extends State<ShopDetailDialog> {
  // late ShopDetail _shopDetail;

  @override
  void initState() {
    super.initState();
    // _setData();
  }

  Future<void> _setData() async {
    final prefs = await SharedPreferences.getInstance();
    ApiClient apiClient = ApiClient();
    String langCode = prefs.getString('langCode') ?? 'en';
    ShopDetail shopDetail =
        await apiClient.getShopDetail(langCode, widget.shopId);
    setState(() {
      // _shopDetail = shopDetail;
    });
  }

  CarouselSlider catagoryMenus() {
    return CarouselSlider.builder(
      itemCount: 10,
      options: CarouselOptions(
        autoPlay: false,
        viewportFraction: 0.3,
        height: 300,
        initialPage: 2,
      ),
      itemBuilder: (context, itemIndex, pageViewIndex) {
        String i = itemIndex.toString();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PhysicalModel(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            elevation: 3.0,
            child: FillImageCard(
              borderRadius: 10.0,
              imageProvider: NetworkImage(
                'https://dummyimage.com/200x200/ccc/fff.jpg&text=menu$i-image',
              ),
              title: Text(
                'menu $i name',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              description: Text('menu $i description'),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      onPressed: () {
                        print('$i-');
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: Text('0'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onPressed: () {
                        print('$i+');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  fit: BoxFit.fitWidth,
                  'https://dummyimage.com/600x400/ccc/fff.jpg&text=stall-image',
                ),
              ),
              title: Text('name of shop id ${widget.shopId}'),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    itemSize: 30,
                    initialRating: 3,
                    minRating: 1,
                    allowHalfRating: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    unratedColor: Colors.amber[100],
                    itemBuilder: (context, rating) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'detail of shop id ${widget.shopId} : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'menus of shop id ${widget.shopId}',
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'catagory 1',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                catagoryMenus(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'catagory 2',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                catagoryMenus(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'catagory 3',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                catagoryMenus(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'catagory 4',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                catagoryMenus(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

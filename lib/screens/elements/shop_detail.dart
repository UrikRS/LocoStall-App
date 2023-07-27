import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_card/image_card.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:locostall/bloc/drawer_bloc.dart';
import 'package:locostall/bloc/cart_bloc.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/services/api.dart';

class ShopDetailDialog extends StatefulWidget {
  const ShopDetailDialog({super.key, required this.shopId});
  final dynamic shopId;

  @override
  State<ShopDetailDialog> createState() => _ShopDetailDialogState();
}

class _ShopDetailDialogState extends State<ShopDetailDialog> {
  ShopDetail? shopDetail;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    final prefs = await SharedPreferences.getInstance();
    ApiClient apiClient = ApiClient();
    String langCode = prefs.getString('langCode') ?? 'en';
    ShopDetail shopDetail_ =
        await apiClient.getShopDetail(langCode, widget.shopId);
    if (mounted) {
      setState(() {
        shopDetail = shopDetail_;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    final cartBloc = BlocProvider.of<CartBloc>(context);
    _setData();

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      clipBehavior: Clip.hardEdge,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * .25,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                fit: BoxFit.fitWidth,
                'https://dummyimage.com/600x400/ccc/fff.jpg&text=stall-image',
              ),
              title: Text(shopDetail?.name ?? 'Unknown'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  drawerBloc.add(ItemTappedEvent(TabPage.orders));
                  Navigator.pop(context);
                },
                icon: badges.Badge(
                  position: badges.BadgePosition.bottomStart(),
                  badgeContent: Text(
                    cartBloc.state.cartItems.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
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
                    initialRating: shopDetail?.rating.toDouble() ?? 2.5,
                    ignoreGestures: true,
                    allowHalfRating: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    unratedColor: Colors.amber[100],
                    itemBuilder: (context, rating) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
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
                MenusCarousel(shopDetail: shopDetail, context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenusCarousel extends StatelessWidget {
  const MenusCarousel({
    super.key,
    required this.shopDetail,
    required this.context,
  });

  final ShopDetail? shopDetail;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final menus = shopDetail?.menus;

    return CarouselSlider.builder(
      itemCount: menus?.length ?? 0,
      options: CarouselOptions(
        disableCenter: true,
        autoPlay: false,
        viewportFraction: 0.6,
        aspectRatio: 8 / 7,
        enableInfiniteScroll: false,
      ),
      itemBuilder: (context, itemIndex, pageViewIndex) =>
          MenuItemCard(itemIndex: itemIndex, shopDetail: shopDetail),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.itemIndex,
    required this.shopDetail,
  });

  final int itemIndex;
  final ShopDetail? shopDetail;

  @override
  Widget build(BuildContext context) {
    final menuItem = shopDetail!.menus?[itemIndex];
    final cartBloc = BlocProvider.of<CartBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        elevation: 3.0,
        child: FillImageCard(
          heightImage: 150,
          borderRadius: 10.0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          imageProvider: NetworkImage(
            'https://dummyimage.com/300x240/ccc/fff.jpg&text=menu$itemIndex-image',
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                menuItem?.name ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'NT ${menuItem?.price}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          description: SizedBox(
            height: 40,
            child: Text(
              menuItem?.description ?? 'Unknown',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove,
                  size: 18,
                ),
                onPressed: () =>
                    cartBloc.add(RemoveFromCartEvent(menuItem!.id)),
              ),
              Text(
                cartBloc.state.cartItems
                    .where((item) => item == menuItem!.id)
                    .length
                    .toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 18,
                ),
                onPressed: () => cartBloc.add(AddToCartEvent(menuItem!.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

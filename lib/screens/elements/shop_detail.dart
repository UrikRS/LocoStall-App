import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:image_card/image_card.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/bloc/all.dart';
import 'package:locostall/screens/elements/checkout.dart';
import 'package:locostall/models/shop.dart';
import 'package:locostall/services/api.dart';

class ShopDetailDialog extends StatefulWidget {
  const ShopDetailDialog({
    super.key,
    required this.shopId,
  });
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

  @override
  void deactivate() {
    super.deactivate();
    BlocProvider.of<CartBloc>(context).add(EmptyCartEvent());
  }

  Future<void> _setData() async {
    final languageBloc = BlocProvider.of<LanguageBloc>(context);
    ShopDetail shopDetail_ = await ApiClient()
        .getShopDetail(languageBloc.state.langCode, widget.shopId);
    if (mounted) {
      setState(() {
        shopDetail = shopDetail_;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FluidDialog(
      rootPage: FluidDialogPage(
        builder: (context) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  background: CachedNetworkImage(
                    imageUrl: shopDetail?.cover ??
                        'https://dummyimage.com/300x180/ccc/fff.jpg',
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    shopDetail?.name ?? 'UNKNOWN',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                actions: [OrderButton(shopDetail: shopDetail)],
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
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
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
                      height: 150,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            shopDetail?.description ?? 'UNKNOWN',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'MENU',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MenusCarousel(shopDetail: shopDetail, context: context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton({
    super.key,
    required this.shopDetail,
  });

  final ShopDetail? shopDetail;

  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    return TextButton.icon(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => Checkout(shopDetail: shopDetail!));
      },
      label: Text(
        AppLocalizations.of(context)?.order ?? 'ORDER',
        style: const TextStyle(
          color: Colors.white,
          shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1))],
        ),
      ),
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
        child: const Icon(
          Icons.history_edu,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1))],
        ),
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
    int itemCount = (menus?.length ?? 0) ~/ 2;

    return CarouselSlider.builder(
      options: CarouselOptions(
        disableCenter: true,
        viewportFraction: .7,
        autoPlay: false,
        height: menus?.length == 1 ? 350 : 700,
        enableInfiniteScroll: false,
      ),
      itemCount: menus?.length == 1 ? 1 : itemCount,
      itemBuilder: (context, itemIndex, pageViewIndex) {
        final int first = itemIndex * 2;
        final int second = first + 1;

        return Column(
          children: [
            if (first < menus!.length)
              Expanded(
                child: MenuItemCard(
                  itemIndex: first,
                  shopDetail: shopDetail,
                ),
              ),
            if (second < menus.length)
              Expanded(
                child: MenuItemCard(
                  itemIndex: second,
                  shopDetail: shopDetail,
                ),
              ),
          ],
        );
      },
    );
  }
}

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    super.key,
    required this.itemIndex,
    required this.shopDetail,
  });

  final int itemIndex;
  final ShopDetail? shopDetail;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    final menuItem = widget.shopDetail!.menus?[widget.itemIndex];
    final cartBloc = BlocProvider.of<CartBloc>(context);

    if (!showDetail) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          elevation: 10.0,
          child: LayoutBuilder(builder: (context, constraints) {
            return FillImageCard(
              width: constraints.maxWidth,
              heightImage: constraints.maxHeight * .52,
              borderRadius: 10.0,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              imageProvider: CachedNetworkImageProvider(
                menuItem?.image ??
                    'https://dummyimage.com/300x180/ccc/fff.jpg&text=menu',
              ),
              tags: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      showDetail = true;
                    });
                  },
                  child: const Text('DETAIL'),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * .5,
                        child: Text(
                          menuItem!.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        'NT ${menuItem.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              description: const SizedBox(height: 5),
              footer: (cartBloc.state.cartItems.contains(menuItem.prodId))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                          onPressed: () => cartBloc
                              .add(RemoveFromCartEvent(menuItem.prodId)),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          cartBloc.state.cartItems
                              .where((item) => item == menuItem.prodId)
                              .length
                              .toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          onPressed: () =>
                              cartBloc.add(AddToCartEvent(menuItem.prodId)),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 36,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          child: const Text(
                            'ORDER',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () =>
                              cartBloc.add(AddToCartEvent(menuItem.prodId)),
                        ),
                      ),
                    ),
            );
          }),
        ),
      );
    } else {
      return Card(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(8),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      showDetail = false;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  menuItem!.description,
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.6,
                    wordSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

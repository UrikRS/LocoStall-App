import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locostall/bloc/cart_bloc.dart';
import 'package:locostall/bloc/drawer_bloc.dart';
import 'package:locostall/bloc/order_bloc.dart';
import 'package:locostall/bloc/user_bloc.dart';
import 'package:locostall/models/menu.dart';
import 'package:locostall/models/order.dart';
import 'package:locostall/models/shop.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';

class Checkout extends StatefulWidget {
  const Checkout({
    super.key,
    required this.shopDetail,
  });

  final ShopDetail shopDetail;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late String now;

  @override
  void initState() {
    super.initState();

    now = DateTime.now().toString();
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final orderBloc = BlocProvider.of<OrderBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    Order order = Order(
      itemList: cartBloc.getItemsFromCart(),
      payment: 'cash',
      shopId: widget.shopDetail.shopId,
      userId: userBloc.state.user?.userId ?? 0,
    );
    orderBloc.add(CreateOrderEvent(order));
  }

  @override
  void deactivate() {
    super.deactivate();
    final orderBloc = BlocProvider.of<OrderBloc>(context);
    orderBloc.add(CancelOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final orderBloc = BlocProvider.of<OrderBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return FluidDialog(
      defaultDecoration: const BoxDecoration(color: Colors.transparent),
      rootPage: FluidDialogPage(
        alignment: Alignment.topRight,
        builder: (context) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            child: SKSTicketView(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              drawArc: false,
              triangleAxis: Axis.vertical,
              backgroundColor: Colors.transparent,
              borderRadius: 6,
              drawTriangle: false,
              drawDivider: false,
              child: SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.shopDetail.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'address : xxxxxxxxxxxxxxxxxxx',
                        overflow: TextOverflow.clip,
                      ),
                      const Text(
                        'tel. : xxxxxxxxxx',
                        overflow: TextOverflow.clip,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CREATE TIME',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            width: 70,
                            child: Text(
                              now,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 14,
                        child: Text('*' * 100, overflow: TextOverflow.clip),
                      ),
                      const SizedBox(height: 10),
                      OrderTable(
                          shopDetail: widget.shopDetail,
                          cartBloc: cartBloc,
                          orderBloc: orderBloc),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 14,
                        child: Text('*' * 100, overflow: TextOverflow.clip),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'NT ${cartBloc.state.cartItems.fold(0, (sum, item) => sum + widget.shopDetail.findMenuById(item)!.price)}'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 14,
                        child: Text('*' * 100, overflow: TextOverflow.clip),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PAYMENT',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${userBloc.state.userData?.name}',
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                        child: const Text(
                          'PAY CASH',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          if (userBloc.state.user != null) {
                            orderBloc.add(SubmitOrderEvent());
                            drawerBloc.add(ItemTappedEvent(TabPage.waiting));
                          } else {
                            drawerBloc.add(ItemTappedEvent(TabPage.login));
                          }
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderTable extends StatelessWidget {
  const OrderTable({
    super.key,
    required this.shopDetail,
    required this.cartBloc,
    required this.orderBloc,
  });

  final ShopDetail? shopDetail;
  final OrderBloc orderBloc;
  final CartBloc cartBloc;

  void updateOrder() {
    List<Item> items = cartBloc.getItemsFromCart();
    orderBloc.add(UpdateOrderEvent(itemList: items));
  }

  List<TableRow> _orderRows(CartBloc cartBloc, OrderBloc orderBloc) {
    List<TableRow> rows = [];

    rows.add(const TableRow(
      children: [
        TableCell(
          child: Text(
            'ITEM',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'QTY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'PRICE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ));

    rows.add(const TableRow(
      children: [
        SizedBox(height: 10),
        SizedBox(height: 10),
        SizedBox(height: 10),
      ],
    ));

    for (int prodId in cartBloc.state.cartItems.toSet()) {
      Menu? menu = shopDetail!.findMenuById(prodId);
      rows.add(TableRow(
        children: [
          TableCell(
            child: Text(
              menu!.name,
            ),
          ),
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 14.0,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    cartBloc.add(RemoveFromCartEvent(prodId));
                    updateOrder();
                  },
                ),
                Text(
                  cartBloc.state.cartItems
                      .where((item) => item == prodId)
                      .length
                      .toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  iconSize: 14.0,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    cartBloc.add(AddToCartEvent(prodId));
                    updateOrder();
                  },
                ),
              ],
            ),
          ),
          TableCell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${cartBloc.state.cartItems.where((item) => item == prodId).length} x ${menu.price}',
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  '= ${menu.price * cartBloc.state.cartItems.where((item) => item == prodId).length}',
                ),
              ],
            ),
          ),
        ],
      ));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    updateOrder();
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(.4),
        1: FlexColumnWidth(.4),
        2: FlexColumnWidth(.2),
      },
      children: _orderRows(cartBloc, orderBloc),
    );
  }
}

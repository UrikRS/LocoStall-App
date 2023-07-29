import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locostall/bloc/cart_bloc.dart';
import 'package:locostall/bloc/drawer_bloc.dart';
import 'package:locostall/bloc/order_bloc.dart';
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

    List<Order> orders = cartBloc.getOrdersFromCart();

    OrderList orderList = OrderList(
      now,
      orders,
      'cash',
      widget.shopDetail.id,
      now,
      0,
    );
    orderBloc.add(CreateOrderEvent(orderList));
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

    return FluidDialog(
      defaultDecoration: const BoxDecoration(color: Colors.transparent),
      rootPage: FluidDialogPage(
        alignment: Alignment.topRight,
        builder: (context) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            child: SKSTicketView(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
              drawArc: false,
              triangleAxis: Axis.vertical,
              backgroundColor: Colors.transparent,
              borderRadius: 6,
              drawTriangle: false,
              drawDivider: false,
              child: SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
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
                      const Text('address : xxxxxxxxxxxxxxxxxxx'),
                      const Text('tel. : xxxxxxxxxx'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('CREATE TIME'),
                          Text(now),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 14,
                        child: Text('*' * 100, overflow: TextOverflow.clip),
                      ),
                      const SizedBox(height: 10),
                      OrderTable(shopDetail: widget.shopDetail),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PAYMENT'),
                          Text('user name'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'LINE PAY',
                              style: TextStyle(
                                color: Colors.green.shade300,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              orderBloc
                                  .add(UpdateOrderEvent(payment: 'linepay'));
                              orderBloc.add(SubmitOrderEvent(
                                  orderBloc.state.unsubmitted!));
                              drawerBloc.add(ItemTappedEvent(TabPage.orders));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'CASH',
                              style: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              orderBloc.add(SubmitOrderEvent(
                                  orderBloc.state.unsubmitted!));
                              drawerBloc.add(ItemTappedEvent(TabPage.orders));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
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

class OrderTable extends StatefulWidget {
  const OrderTable({
    super.key,
    required this.shopDetail,
  });

  final ShopDetail? shopDetail;

  @override
  State<OrderTable> createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
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

    for (int menuId in cartBloc.state.cartItems.toSet()) {
      Menu? menu = widget.shopDetail!.findMenuById(menuId);
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
                    cartBloc.add(RemoveFromCartEvent(menuId));
                    List<Order> orders = cartBloc.getOrdersFromCart();
                    orderBloc.add(UpdateOrderEvent(orderList: orders));
                  },
                ),
                Text(
                  cartBloc.state.cartItems
                      .where((item) => item == menuId)
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
                    cartBloc.add(AddToCartEvent(menuId));
                    List<Order> orders = cartBloc.getOrdersFromCart();
                    orderBloc.add(UpdateOrderEvent(orderList: orders));
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
                  '${cartBloc.state.cartItems.where((item) => item == menuId).length} x ${menu.price}',
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  '= ${menu.price * cartBloc.state.cartItems.where((item) => item == menuId).length}',
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
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final orderBloc = BlocProvider.of<OrderBloc>(context);

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

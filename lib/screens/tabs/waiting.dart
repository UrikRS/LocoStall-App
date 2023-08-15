import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locostall/bloc/user_bloc.dart';
import 'package:locostall/models/order.dart';
import 'package:locostall/services/api.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';
import 'package:timelines/timelines.dart';

class WaitingTab extends StatefulWidget {
  const WaitingTab({super.key});

  @override
  State<WaitingTab> createState() => _WaitingTabState();
}

class _WaitingTabState extends State<WaitingTab> {
  List<Order> _orders = [];
  Map<int, String> states = {
    0: 'foodReady',
    1: 'cooking',
    2: 'waiting',
    3: 'finish',
    4: 'cancel'
  };

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    final userBloc = BlocProvider.of<UserBloc>(context);
    if (userBloc.state.user != null) {
      List<Order> orders =
          await ApiClient().getUserOrders(userBloc.state.user!.userId);
      if (mounted) {
        setState(() {
          _orders = orders;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        color: Colors.amber,
        nodePosition: 0,
        indicatorPosition: 0,
        indicatorTheme: const IndicatorThemeData(size: 20),
        connectorTheme: const ConnectorThemeData(thickness: 4),
      ),
      padding: const EdgeInsets.all(24),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.after,
        contentsAlign: ContentsAlign.basic,
        itemCount: 5,
        contentsBuilder: (context, index) {
          List<Widget> listContent = [];
          listContent.add(
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '     ${states[index]}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          );
          for (Order order in _orders) {
            if (order.state == states[index]) {
              var pay = 0;
              for (Item item in order.itemList) {
                pay += item.qty * (item.price ?? 0);
              }
              listContent.add(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 3,
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${order.shopName}'),
                            Text(
                              'NT $pay',
                              style: TextStyle(
                                color: Colors.green.shade400,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          Receipt(order: order, pay: pay));
                                },
                                child: Text(
                                  'VIEW',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          return Column(
            children: listContent,
          );
        },
        indicatorBuilder: (context, index) {
          if (states[index] == 'foodReady') {
            return DotIndicator(
              color: Colors.green.shade400,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20.0,
              ),
            );
          } else if (states[index] == 'cooking') {
            return const DotIndicator(
              color: Colors.amber,
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 20.0,
              ),
            );
          } else if (states[index] == 'waiting') {
            return DotIndicator(
              color: Colors.red.shade300,
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 20.0,
              ),
            );
          } else if (states[index] == 'finish') {
            return const DotIndicator(
              color: Colors.grey,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 20.0,
              ),
            );
          } else {
            return const DotIndicator(
              color: Colors.grey,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20.0,
              ),
            );
          }
        },
        connectorBuilder: (context, index, type) {
          if (states[index] == 'foodReady') {
            return SolidLineConnector(
              color: Colors.green.shade400,
              thickness: 5,
            );
          } else if (states[index] == 'cooking') {
            return const SolidLineConnector(
              color: Colors.amber,
              thickness: 5,
            );
          } else if (states[index] == 'waiting') {
            return SolidLineConnector(
              color: Colors.red.shade300,
              thickness: 5,
            );
          } else {
            return const SolidLineConnector(
              color: Colors.grey,
              thickness: 5,
            );
          }
        },
      ),
    );
  }
}

class Receipt extends StatelessWidget {
  const Receipt({super.key, required this.order, required this.pay});
  final Order order;
  final int pay;

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    return FluidDialog(
      defaultDecoration: const BoxDecoration(color: Colors.transparent),
      rootPage: FluidDialogPage(
        alignment: Alignment.center,
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
                        order.shopName ?? 'UNKNOWN',
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
                              order.createAt ?? 'UNKNOWN',
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
                      OrderTable(order: order),
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
                          Text('NT $pay'),
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
                      Text(
                        'ORDER NUMBER : ${order.orderId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'THANK YOU !',
                        style: TextStyle(
                          color: Color(0xFF3F3B34),
                          fontFamily: 'BowlbyOneSC',
                          fontSize: 20,
                        ),
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
  const OrderTable({super.key, required this.order});
  final Order order;

  List<TableRow> _orderRows() {
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

    for (Item item in order.itemList) {
      rows.add(TableRow(
        children: [
          TableCell(
            child: Text(
              item.name ?? 'UNKNOWN',
            ),
          ),
          TableCell(
            child: Center(
              child: Text(
                '${item.qty}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.qty} x ${item.price}',
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  '= ${item.qty * (item.price ?? 0)}',
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
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(.4),
        1: FlexColumnWidth(.4),
        2: FlexColumnWidth(.2),
      },
      children: _orderRows(),
    );
  }
}

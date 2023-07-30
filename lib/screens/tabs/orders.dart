import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:locostall/bloc/cart_bloc.dart';
import 'package:locostall/bloc/order_bloc.dart';
import 'package:locostall/models/order.dart';
import 'dart:convert';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  Widget? _orderListBuilder(BuildContext context, int index) {
    List<Widget> orders = [];

    // final cartBloc = BlocProvider.of<CartBloc>(context);
    final orderBloc = BlocProvider.of<OrderBloc>(context);

    for (OrderList order in orderBloc.state.submitted) {
      orders.add(Card(
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(order.createAt),
                Text(order.payment),
                Text('shop ${order.shopId}'),
                Text('user ${order.userId}'),
                Text(jsonEncode(order.orderList)),
              ],
            ),
          ),
        ),
      ));
    }

    return Column(children: orders);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: _orderListBuilder,
    );
  }
}

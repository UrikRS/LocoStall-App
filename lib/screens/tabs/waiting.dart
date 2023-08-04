import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locostall/bloc/user_bloc.dart';
import 'package:locostall/models/order.dart';
import 'dart:convert';

import 'package:locostall/services/api.dart';

class WaitingTab extends StatefulWidget {
  const WaitingTab({super.key});

  @override
  State<WaitingTab> createState() => _WaitingTabState();
}

class _WaitingTabState extends State<WaitingTab> {
  List<Order> _orders = [];

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

  Widget? _orderListBuilder(BuildContext context, int index) {
    List<Widget> orderCards = [];

    for (Order order in _orders) {
      orderCards.add(Card(
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(order.payment),
                Text('shop ${order.shopId}'),
                Text('user ${order.userId}'),
                Text(jsonEncode(order.itemList)),
              ],
            ),
          ),
        ),
      ));
    }

    return Column(children: orderCards);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: _orderListBuilder,
    );
  }
}

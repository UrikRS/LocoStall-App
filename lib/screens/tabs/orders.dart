import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:locostall/bloc/cart_bloc.dart';
import 'package:locostall/bloc/order_bloc.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  Widget? _orderListBuilder(BuildContext context, int index) {
    List<Widget> orders = [];

    // final cartBloc = BlocProvider.of<CartBloc>(context);
    final orderBloc = BlocProvider.of<OrderBloc>(context);

    orders.add(Text('${orderBloc.state.submitted}'));

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

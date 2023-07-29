import 'package:bloc/bloc.dart';
import 'package:locostall/models/order.dart';

// 1. Define the events
class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final OrderList orders;

  CreateOrderEvent(this.orders);
}

class UpdateOrderEvent extends OrderEvent {
  final String? createAt;
  final List<Order>? orderList;
  final String? payment;
  final int? shopId;
  final String? updateAt;
  final int? userId;

  UpdateOrderEvent({
    this.createAt,
    this.orderList,
    this.payment,
    this.shopId,
    this.updateAt,
    this.userId,
  });
}

class SubmitOrderEvent extends OrderEvent {
  final OrderList orders;

  SubmitOrderEvent(this.orders);
}

class CancelOrderEvent extends OrderEvent {}

class GetUserOrdersEvent extends OrderEvent {}

// 2. Define the state
class OrderState {
  final OrderList? unsubmitted;
  final List<OrderList> submitted;

  OrderState(this.unsubmitted, this.submitted);
}

// 3. Create the BLoC class
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState(null, [])) {
    on<CreateOrderEvent>(
        (event, emit) => emit(OrderState(event.orders, state.submitted)));

    on<UpdateOrderEvent>(
      (event, emit) => emit(
        OrderState(
            OrderList(
              event.createAt ?? state.unsubmitted!.createAt,
              event.orderList ?? state.unsubmitted!.orderList,
              event.payment ?? state.unsubmitted!.payment,
              event.shopId ?? state.unsubmitted!.shopId,
              event.updateAt ?? state.unsubmitted!.updateAt,
              event.userId ?? state.unsubmitted!.userId,
            ),
            state.submitted),
      ),
    );

    on<SubmitOrderEvent>((event, emit) {
      state.submitted.add(event.orders);
      emit(OrderState(null, state.submitted));
    });

    on<CancelOrderEvent>(
        (event, emit) => emit(OrderState(null, state.submitted)));
  }
}

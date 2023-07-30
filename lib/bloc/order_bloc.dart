import 'package:bloc/bloc.dart';
import 'package:locostall/models/order.dart';

/* events */
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

class SubmitOrderEvent extends OrderEvent {}

class CancelOrderEvent extends OrderEvent {}

class GetUserOrdersEvent extends OrderEvent {}

/* states */
class OrderState {
  final OrderList unsubmitted;
  final List<OrderList> submitted;

  OrderState(this.unsubmitted, this.submitted);
}

/* BLoC */
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState(OrderList(), [])) {
    on<CreateOrderEvent>(
        (event, emit) => emit(OrderState(event.orders, state.submitted)));

    on<UpdateOrderEvent>(
      (event, emit) => emit(
        OrderState(
            OrderList(
              createAt: event.createAt ?? state.unsubmitted.createAt,
              orderList: event.orderList ?? state.unsubmitted.orderList,
              payment: event.payment ?? state.unsubmitted.payment,
              shopId: event.shopId ?? state.unsubmitted.shopId,
              updateAt: event.updateAt ?? state.unsubmitted.updateAt,
              userId: event.userId ?? state.unsubmitted.userId,
            ),
            state.submitted),
      ),
    );

    on<SubmitOrderEvent>((event, emit) {
      state.submitted.add(state.unsubmitted);
      emit(OrderState(OrderList(), state.submitted));
    });

    on<CancelOrderEvent>(
        (event, emit) => emit(OrderState(OrderList(), state.submitted)));
  }
}

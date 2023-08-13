import 'package:bloc/bloc.dart';
import 'package:locostall/models/order.dart';
import 'package:locostall/services/api.dart';

/* events */
abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final Order orders;

  CreateOrderEvent(this.orders);
}

class UpdateOrderEvent extends OrderEvent {
  final String? createAt;
  final List<Item>? itemList;
  final String? payment;
  final int? shopId;
  final String? updateAt;
  final int? userId;

  UpdateOrderEvent({
    this.createAt,
    this.itemList,
    this.payment,
    this.shopId,
    this.updateAt,
    this.userId,
  });
}

class SubmitOrderEvent extends OrderEvent {}

class CancelOrderEvent extends OrderEvent {}

/* state */
class OrderState {
  final Order? unsubmitted;

  OrderState(this.unsubmitted);
}

/* BLoC */
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState(null)) {
    on<CreateOrderEvent>((event, emit) => emit(OrderState(event.orders)));

    on<UpdateOrderEvent>(
      (event, emit) => emit(
        OrderState(Order(
          itemList: event.itemList ?? state.unsubmitted!.itemList,
          payment: event.payment ?? state.unsubmitted!.payment,
          shopId: event.shopId ?? state.unsubmitted!.shopId,
          userId: event.userId ?? state.unsubmitted!.userId,
        )),
      ),
    );

    on<SubmitOrderEvent>((event, emit) async {
      if (state.unsubmitted!.itemList != []) {
        await ApiClient().sendOrder(state.unsubmitted ?? Order());
        emit(OrderState(null));
      } else {
        emit(OrderState(state.unsubmitted));
      }
    });

    on<CancelOrderEvent>((event, emit) => emit(OrderState(null)));
  }
}

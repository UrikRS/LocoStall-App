import 'package:bloc/bloc.dart';
import 'package:locostall/models/order.dart';

// 1. Define the events
class OrderEvent {}

class CreateOrderEvent extends OrderEvent {}

class SubmitOrderEvent extends OrderEvent {}

class CancelOrderEvent extends OrderEvent {}

// 2. Define the state
class OrderState {
  OrderList? unsubmitted;
  List<OrderList> submitted;

  OrderState(this.unsubmitted, this.submitted);
}

// 3. Create the BLoC class
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState(null, [])) {
    on<CreateOrderEvent>((event, emit) {});

    on<SubmitOrderEvent>((event, emit) {});

    on<CancelOrderEvent>((event, emit) {});
  }
}

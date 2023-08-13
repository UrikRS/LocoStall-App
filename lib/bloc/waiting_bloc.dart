import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locostall/models/order.dart';
import 'package:locostall/services/api.dart';

/* events */
abstract class WaitingEvent extends Equatable {
  const WaitingEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends WaitingEvent {
  final int userId;

  const FetchDataEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

/* state */
class WaitingState extends Equatable {
  final List<Order> orders;
  const WaitingState(this.orders);

  @override
  List<Object> get props => [orders];
}

/* BLoC */
class WaitingBloc extends Bloc<WaitingEvent, WaitingState> {
  WaitingBloc() : super(const WaitingState([])) {
    on<FetchDataEvent>((event, emit) async {
      final List<Order> orders = await ApiClient().getUserOrders(event.userId);
      emit(WaitingState(orders));
    });
  }
}

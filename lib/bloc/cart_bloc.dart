import 'package:bloc/bloc.dart';
import 'package:locostall/models/order.dart';

/* events */
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int menuId;

  AddToCartEvent(this.menuId);
}

class RemoveFromCartEvent extends CartEvent {
  final int menuId;

  RemoveFromCartEvent(this.menuId);
}

class EmptyCartEvent extends CartEvent {}

/* states */
class CartState {
  final List<int> cartItems;

  CartState(this.cartItems);
}

/* BLoC */
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<AddToCartEvent>((event, emit) {
      state.cartItems.add(event.menuId);
      emit(CartState(state.cartItems));
    });

    on<RemoveFromCartEvent>((event, emit) {
      if (state.cartItems.contains(event.menuId)) {
        state.cartItems.remove(event.menuId);
      }
      emit(CartState(state.cartItems));
    });

    on<EmptyCartEvent>((event, emit) => emit(CartState([])));
  }

  List<Order> getOrdersFromCart() {
    List<Order> orders = [];
    for (int menuId in state.cartItems.toSet()) {
      Order order =
          Order(menuId, state.cartItems.where((id) => id == menuId).length);
      orders.add(order);
    }
    return orders;
  }
}

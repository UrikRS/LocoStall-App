import 'package:bloc/bloc.dart';
import 'package:locostall/models/order.dart';

/* events */
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int prodId;

  AddToCartEvent(this.prodId);
}

class RemoveFromCartEvent extends CartEvent {
  final int prodId;

  RemoveFromCartEvent(this.prodId);
}

class EmptyCartEvent extends CartEvent {}

/* state */
class CartState {
  final List<int> cartItems;

  CartState(this.cartItems);
}

/* BLoC */
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<AddToCartEvent>((event, emit) {
      state.cartItems.add(event.prodId);
      emit(CartState(state.cartItems));
    });

    on<RemoveFromCartEvent>((event, emit) {
      if (state.cartItems.contains(event.prodId)) {
        state.cartItems.remove(event.prodId);
      }
      emit(CartState(state.cartItems));
    });

    on<EmptyCartEvent>((event, emit) => emit(CartState([])));
  }

  List<Item> getItemsFromCart() {
    List<Item> items = [];
    for (int prodId in state.cartItems.toSet()) {
      Item item =
          Item(prodId, state.cartItems.where((id) => id == prodId).length);
      items.add(item);
    }
    return items;
  }
}

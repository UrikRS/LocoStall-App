import 'package:bloc/bloc.dart';

enum TabPage {
  shops,
  orders,
  login,
  register,
  settings,
} // Add more tabs as needed

// 1. Define the events
abstract class DrawerEvent {}

class ItemTappedEvent extends DrawerEvent {
  final TabPage tab;

  ItemTappedEvent(this.tab);
}

// 2. Define the state
class DrawerState {
  final TabPage tab;

  DrawerState(this.tab);
}

// 3. Create the BLoC class
class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerState(TabPage.shops)) {
    on<ItemTappedEvent>((event, emit) => emit(DrawerState(event.tab)));
  }
}

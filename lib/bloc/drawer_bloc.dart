import 'package:bloc/bloc.dart';

enum TabPage {
  shops,
  orders,
  login,
  register,
  settings,
} // Add more tabs as needed

/* events */
abstract class DrawerEvent {}

class ItemTappedEvent extends DrawerEvent {
  final TabPage tab;

  ItemTappedEvent(this.tab);
}

/* states */
class DrawerState {
  final TabPage tab;

  DrawerState(this.tab);
}

/* BLoC */
class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerState(TabPage.shops)) {
    on<ItemTappedEvent>((event, emit) => emit(DrawerState(event.tab)));
  }
}

import 'package:bloc/bloc.dart';
import 'package:locostall/models/user.dart';

/* events */
class UserEvent {}

class LoginEvent extends UserEvent {
  final User user;

  LoginEvent(this.user);
}

class LogoutEvent extends UserEvent {}

/* states */
class UserState {
  final User? user;

  UserState(this.user);
}

/* BLoC */
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(null)) {
    on<LoginEvent>((event, emit) => emit(UserState(event.user)));

    on<LogoutEvent>((event, emit) => emit(UserState(null)));
  }
}

import 'package:bloc/bloc.dart';
import 'package:locostall/models/user.dart';

// 1. Define the events
class UserEvent {}

class LoginEvent extends UserEvent {
  final User user;

  LoginEvent(this.user);
}

class LogoutEvent extends UserEvent {}

// 2. Define the state
class UserState {
  final User? user;

  UserState(this.user);
}

// 3. Create the BLoC class
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(null)) {
    on<LoginEvent>((event, emit) => emit(UserState(event.user)));

    on<LogoutEvent>((event, emit) => emit(UserState(null)));
  }
}

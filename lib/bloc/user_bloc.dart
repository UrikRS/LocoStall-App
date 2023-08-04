import 'package:bloc/bloc.dart';
import 'package:locostall/models/user.dart';
import 'package:locostall/services/api.dart';

/* events */
class UserEvent {}

class LoginEvent extends UserEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent extends UserEvent {}

class RegisterEvent extends UserEvent {
  final String email;
  final String password;
  final String langCode;

  RegisterEvent(this.email, this.password, this.langCode);
}

/* state */
class UserState {
  final User? user;
  final UserData? userData;

  UserState(this.user, this.userData);
}

/* BLoC */
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(null, null)) {
    on<LoginEvent>((event, emit) async {
      try {
        final user = await ApiClient().userLogin(event.email, event.password);
        if (user.userId != null) {
          final userData = await ApiClient().getUserData(user.userId);
          emit(UserState(user, userData));
        } else {
          emit(UserState(null, null));
        }
      } catch (e) {
        emit(UserState(null, null));
      }
    });

    on<LogoutEvent>((event, emit) => emit(UserState(null, null)));

    on<RegisterEvent>((event, emit) async {
      try {
        final (user, userData) = await ApiClient()
            .userRegister(event.email, event.password, event.langCode);
        emit(UserState(user, userData));
      } catch (e) {
        emit(UserState(null, null));
      }
    });
  }
}

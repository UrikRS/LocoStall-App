import 'package:bloc/bloc.dart';
import 'package:locostall/models/user.dart';
import 'package:locostall/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* events */
abstract class UserEvent {}

class LoginEvent extends UserEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent extends UserEvent {}

class RegisterEvent extends UserEvent {
  final String email;
  final String password;

  RegisterEvent(this.email, this.password);
}

class UpdateEvent extends UserEvent {
  final String? lineId;
  final String? name;
  final String? nLang;
  final String? email;
  final String? password;
  final String? type;
  final int? shopId;

  UpdateEvent({
    this.lineId,
    this.name,
    this.nLang,
    this.email,
    this.password,
    this.type,
    this.shopId,
  });
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
        final prefs = await SharedPreferences.getInstance();
        if (user.userId != null) {
          final userData = await ApiClient().getUserData(user.userId);
          prefs.setInt('userId', userData.userId);
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
        final (user, _) =
            await ApiClient().userRegister(event.email, event.password);
        final prefs = await SharedPreferences.getInstance();
        if (user.userId != null) {
          final userData = await ApiClient().getUserData(user.userId);
          prefs.setInt('userId', userData.userId);
          emit(UserState(user, userData));
        } else {
          emit(UserState(null, null));
        }
      } catch (e) {
        emit(UserState(null, null));
      }
    });

    on<UpdateEvent>((event, emit) async {
      await ApiClient().updateUserData(UserData(
        state.userData!.userId,
        event.lineId,
        event.name,
        event.nLang ?? state.userData!.nLang,
        event.email ?? state.userData!.email,
        event.password ?? state.userData!.password,
        event.type,
        event.shopId,
      ));
    });
  }
}

import 'package:bloc/bloc.dart';

// 1. Define the events
class UserEvent {}

// 2. Define the state
class UserState {}

// 3. Create the BLoC class
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {}
}

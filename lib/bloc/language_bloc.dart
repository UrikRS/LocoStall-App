import 'package:bloc/bloc.dart';

/* events */
abstract class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String langCode;

  ChangeLanguageEvent(this.langCode);
}

/* state */
class LanguageState {
  final String langCode;

  LanguageState(this.langCode);
}

/* BLoC */
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState('en')) {
    on<ChangeLanguageEvent>((event, emit) =>
        emit(LanguageState(event.langCode == 'jp' ? 'ja' : event.langCode)));
  }
}

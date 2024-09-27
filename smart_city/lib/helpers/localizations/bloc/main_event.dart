part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class MainInitEvent extends MainEvent {
  const MainInitEvent();
  @override
  List<Object?> get props => [];
}
class MainChangeLanguageEvent extends MainEvent {
   Locale ?locale;
   MainChangeLanguageEvent({
     this.locale,
  });

  @override
  List<Object?> get props => [locale];
}

class MainChangeDarkModeEvent extends MainEvent {
  const MainChangeDarkModeEvent();

  @override
  List<Object?> get props => [];
}

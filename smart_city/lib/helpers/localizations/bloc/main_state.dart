part of 'main_bloc.dart';

enum MainStatus {
  initial,
  onchangeLanguage,
  onEnableDarkMode,
  unKnown
}

class MainState extends Equatable {
  MainStatus mainStatus =  MainStatus.initial;
  MainState(
      {
        required this.mainStatus
      });

  MainState copyWith({
    MainStatus? mainStatus
  }) {
    return MainState(
      mainStatus: mainStatus??this.mainStatus
    );
  }

  @override
  List<Object?> get props {
    return [mainStatus];
  }
}


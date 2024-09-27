import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../language_helper.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc(MainState mainState) : super(MainState(mainStatus: mainState.mainStatus)){
    on<MainChangeLanguageEvent>(onChangeLanguage);
    on<MainInitEvent>(onInitMain);
    on<MainChangeDarkModeEvent>((event, emit) {
      // TODO: implement event handler
      emit(state.copyWith(
          mainStatus: MainStatus.onEnableDarkMode,
      ));
    });
  }

  Future<void> onInitMain(MainInitEvent event, Emitter<MainState> emit) async {

      MainState locazationState = state.copyWith(mainStatus: MainStatus.initial);
      emit(locazationState);
  }
  Future<void> onChangeLanguage(MainChangeLanguageEvent event, Emitter<MainState> emit) async {

    if(event.locale== null)
      {
        emit(state.copyWith(
            mainStatus: MainStatus.onchangeLanguage
        ));
      }
    LanguageHelper().setLocale(event.locale!);
    emit(state.copyWith(mainStatus: MainStatus.onchangeLanguage ));
  }
}

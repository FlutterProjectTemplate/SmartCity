import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class VoiceManager {
  static final VoiceManager _singletonVoiceManager = VoiceManager._internal();

  static VoiceManager get getInstance => _singletonVoiceManager;

  factory VoiceManager() {
    return _singletonVoiceManager;
  }

  VoiceManager._internal() {
    _initializeTts();
  }

  FlutterTts flutterTts = FlutterTts();

  String? language;
  String? engine;
  double volume = 1;
  double pitch = 1;
  double rate = 0;
  bool isCurrentLanguageInstalled = false;
  TtsState ttsState = TtsState.stopped;

  String? _newVoiceText;
  int? _inputLength;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  Future<void> inital()async {
    flutterTts = FlutterTts();
    await _initializeTts();
  }
  Future<void> _initializeTts() async {
    print("_initializeTts");
    List<dynamic>engines =await flutterTts.getEngines as List<dynamic>;
   await flutterTts.setEngine(engines.first);
   await _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() => ttsState = TtsState.playing);
    flutterTts.setCompletionHandler(() => ttsState = TtsState.stopped);
    flutterTts.setCancelHandler(() => ttsState = TtsState.stopped);
    flutterTts.setPauseHandler(() => ttsState = TtsState.paused);
    flutterTts.setContinueHandler(() => ttsState = TtsState.continued);
    flutterTts.setErrorHandler((msg) => ttsState = TtsState.stopped);

    flutterTts.setLanguage('en');
  }

  Future<void> setVoiceText(String text) async {
    _newVoiceText = text;
  }
  Future<void> getLanguage() async {
    List<dynamic>languages =await flutterTts.getLanguages as List<dynamic>;
    List<String> languageDefault = [...languages.where((element) {
      return element== "en" || element== "en-US";
    },)];
  }

  Future<void> speak({Function()? onFinish}) async {
    dynamic a = await flutterTts.getLanguages;
    print("language:$a");
    List<dynamic>languages =await flutterTts.getLanguages as List<dynamic>;
      List<String> languageDefault = [...languages.where((element) {
        return element== "en" || element== "en-US";
      },)];

      if(languageDefault.isNotEmpty)
      {

        await flutterTts.setLanguage(languageDefault.first);
      }
    await flutterTts.setSharedInstance(true);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
       // IosTextToSpeechAudioCategoryOptions.allowBluetooth,
       // IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ],
      IosTextToSpeechAudioMode.voicePrompt,

    );
    await flutterTts.setVolume(volume);
   // await flutterTts.setSpeechRate(rate);
    //await flutterTts.setPitch(pitch);

    if (_newVoiceText?.isNotEmpty ?? false) {
      print("flutterTts speak");
      await flutterTts.speak(_newVoiceText!);
      flutterTts.setCompletionHandler(() {
        if(onFinish!=null) {
          onFinish();
        }
      },);
    }
  }

  Future<void> stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }
  bool iStop(){
    return  ttsState == TtsState.stopped;
  }

  Future<void> pause() async {
    var result = await flutterTts.pause();
    if (result == 1) ttsState = TtsState.paused;
  }

  Future<dynamic> getLanguages() async => await flutterTts.getLanguages;
  Future<dynamic> getEngines() async => await flutterTts.getEngines;

  Future<void> setEngine(String selectedEngine) async {
    await flutterTts.setEngine(selectedEngine);
    language = null;
    engine = selectedEngine;
  }

  Future<void> setLanguage(String selectedLanguage) async {
    language = selectedLanguage;
    await flutterTts.setLanguage(language!);
    if (isAndroid) {
      flutterTts.isLanguageInstalled(language!).then((value) => isCurrentLanguageInstalled = value);
    }
  }

  Future<void> _getDefaultEngine() async {
    engine = await flutterTts.getDefaultEngine;
  }

  Future<void> _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<int?> getMaxSpeechInputLength() async {
    _inputLength = await flutterTts.getMaxSpeechInputLength;
    return _inputLength;
  }

  void dispose() {
    flutterTts.stop();
  }

  Future<bool> isSpeaking() async {
    return await await flutterTts.awaitSpeakCompletion(true);
  }
}

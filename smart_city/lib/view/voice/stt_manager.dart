import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputManager {
  static final VoiceInputManager _singleton = VoiceInputManager._internal();

  factory VoiceInputManager() {
    return _singleton;
  }

  VoiceInputManager._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if(_speechEnabled){
      // var systemLocale = await _speechToText.systemLocale();
      print("object");
    }
  }
  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${_speechToText.isListening}');
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${_speechToText.isListening}');
  }


  void _logEvent(String eventDescription) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
  }
  Future<void> startListening({required Function(String) onResult}) async {
    await VoiceInputManager().initSpeech();
    print("object");
    // Some UI or other code to select a locale from the list
    // resulting in an index, selectedLocale
    LocaleName localeName = LocaleName('en-US', "US");
    _speechToText.listen(
        listenFor: Duration(seconds: 20),
        localeId: localeName.localeId,
        onResult: (result) {
          _lastWords = result.recognizedWords;
          onResult(_lastWords);
    });
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    await _speechToText.cancel();
  }

  bool get isListening => _speechToText.isListening;
  bool get isEnabled => _speechEnabled;
  String get recognizedWords => _lastWords;
}

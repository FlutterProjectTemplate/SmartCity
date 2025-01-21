import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
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
    _speechEnabled = await _speechToText.initialize(debugLogging: true);
    if(_speechEnabled){
      // var systemLocale = await _speechToText.systemLocale();
      print("initSpeech");
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
  Future<void> startListening({required Function(String) onResult, Function()? onListenEnd}) async {
    if(!_speechEnabled)
      {
         await initSpeech();
      }
    _speechToText.errorListener = (SpeechRecognitionError error){
      if(onListenEnd!=null) {
        onListenEnd();
      }
    };
   var result =  _speechToText.listen(
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
       listenOptions: SpeechListenOptions(
         listenMode: ListenMode.confirmation,
         onDevice: false,
         partialResults: true,
         cancelOnError: true,
       ),
       // localeId: localeName.localeId,
        onResult: (result) async {
          print("result: ${result}" );
          //await VoiceInputManager().stopListening();
          _lastWords = result.recognizedWords;
          stopListening();
          onResult(_lastWords);
        }
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    await _speechToText.cancel();
  }

  bool isListening() {
    return  _speechToText.isListening;
  }
  bool get isEnabled => _speechEnabled;
  String get recognizedWords => _lastWords;
}

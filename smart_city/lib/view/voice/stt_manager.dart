import 'package:flutter/material.dart';
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
  }

  Future<void> startListening(Function(String) onResult) async {
    await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          onResult(_lastWords);
    });
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _speechToText.cancel();
  }

  bool get isListening => _speechToText.isListening;
  bool get isEnabled => _speechEnabled;
  String get recognizedWords => _lastWords;
}

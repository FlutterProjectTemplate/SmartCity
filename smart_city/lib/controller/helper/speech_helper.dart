
import 'package:text_to_speech/text_to_speech.dart';

class SpeechHelper {
  static final SpeechHelper _singletonSpeechHelper = SpeechHelper._internal();

  static SpeechHelper get getInstance => _singletonSpeechHelper;

  factory SpeechHelper() {
    return _singletonSpeechHelper;
  }

  SpeechHelper._internal();
  TextToSpeech tts = TextToSpeech();

  void init(){
    tts = TextToSpeech();
    tts.setVolume(1);
    tts.setRate(1.0);
    tts.setPitch(1.0);
    tts.setLanguage('en-US');

  }
  Future<String> speechToText() async {
    String language = 'en-US';
    List<String>? voices = await tts.getVoiceByLang(language);
    return (voices??[]).toString();
  }
  void textToSpeech(String text){
    tts.speak(text);
  }

}
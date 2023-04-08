import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();
  static initTTS() {
    tts.setPitch(1);
    tts.setSpeechRate(0.5);
    tts.setVolume(100);
  }

  static speak(String text, String language) async {
    tts.setLanguage(language);
    print(language);
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechToTextServices {
  final SpeechToText _speechToText = SpeechToText();
  bool isListeningSpeech = false;

  void initializeSpeech() async {
    try {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
      }

      if (status.isGranted) {
        final checkInitialization = await _speechToText.initialize();
        isListeningSpeech = checkInitialization;
        if (isListeningSpeech) {
          if (kDebugMode) {
            print('The speech methode is initialized');
          }
        } else {
          if (kDebugMode) {
            print('The methode initialization Failed');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('package error:$e');
      }
    }
  }

  void listenSpeech(Function(SpeechRecognitionResult) result) {
    if (_speechToText.isNotListening && isListeningSpeech) {
      _speechToText.listen(onResult: result);
    } else {
      if (kDebugMode) {
        print('speech to text is not initialize and already listening');
      }
    }
  }

  void stopListening() {
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
  }
}

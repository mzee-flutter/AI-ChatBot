import 'package:flutter/cupertino.dart';

class ReactiveResponse extends ChangeNotifier {
  String? _response;
  String? get response => _response;

  void upDateResponse(String newChunk) {
    _response = _response! + newChunk;
    notifyListeners();
  }
}

import 'package:flutter/widgets.dart';

class Keyboard {
  const Keyboard._();

  static void hide() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

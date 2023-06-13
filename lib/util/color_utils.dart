import 'package:flutter/widgets.dart';

class ColorUtils {
  const ColorUtils._();

  static Color parseFromHexString(String value) {
    if (value.startsWith('#')) {
      // ignore: parameter_assignments
      value = value.substring(1);
    }

    final int colorIntValue;
    if (value.length == 6) {
      colorIntValue = int.parse('ff$value', radix: 16);
    } else if (value.length == 8) {
      colorIntValue = int.parse(value, radix: 16);
    } else {
      throw ArgumentError();
    }

    return Color(colorIntValue);
  }
}

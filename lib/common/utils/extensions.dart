import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension ColorUtils on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  //https://stackoverflow.com/a/49835615/9444743
  static Color fromString(String colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  String getHexCode() {
    String radixValue = value.toRadixString(16);
    // String hexValue = "#${radixValue.substring(2)}${radixValue.substring(0, 2)}";
    return "#${radixValue.toString()}";
  }

  static Color random() {
    Random random = Random();
    return Color.fromARGB(
      255, // Alpha value (255 = fully opaque)
      random.nextInt(256), // Red value (0-255)
      random.nextInt(256), // Green value (0-255)
      random.nextInt(256), // Blue value (0-255)
    );
  }

  Color invert() {
    final r = 255 - red;
    final g = 255 - green;
    final b = 255 - blue;

    return Color.fromARGB((opacity * 255).round(), r, g, b);
  }

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  /// lighten/darken a color based on theme mode (dark/light)
  /// lightness = how much to mutate (lighten/darken) the color
  /// luminanceThreshold = color luminance threshold to apply the mutation
  Color normalizeColorBrightness({
    bool lighten = true,
    double luminanceThreshold = 0.5,
    double lightness = 0.1,
  }) {
    assert(luminanceThreshold >= 0 && luminanceThreshold <= 1);
    assert(lightness >= 0 && lightness <= 1);

    double luminance = computeLuminance();

    if (lighten) {
      if (luminance < luminanceThreshold) {
        /// if threshold difference is greater than 0.2, increase lightness
        double thresholdDiff = luminanceThreshold - luminance;
        if (thresholdDiff > 0.2) lightness = lightness / thresholdDiff;

        final hsl = HSLColor.fromColor(this);
        final hslLight = hsl.withLightness((hsl.lightness + lightness).clamp(0.0, 1.0));

        return hslLight.toColor();
      } else {
        return this;
      }
    } else {
      if (luminance > luminanceThreshold) {
        /// if threshold difference is less than 0.2, decrease lightness
        double thresholdDiff = luminance - luminanceThreshold;
        if (thresholdDiff > 0.2) lightness = lightness / thresholdDiff;

        final hsl = HSLColor.fromColor(this);
        final hslDark = hsl.withLightness((hsl.lightness - lightness).clamp(0.0, 1.0));
        return hslDark.toColor();
      } else {
        return this;
      }
    }
  }
}

/// Extensions on Duration class
/// used to format Duration.
/// Example hh:mm:ss
extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

/// extension on context class
/// isDarkMode checks current system brightness mode
extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

/// Extra options for changing letter cases in strings
/// https://stackoverflow.com/a/29629114/9444743
extension on String {
  bool isNotNullOrEmpty() {
    return this != null && isNotEmpty;
  }

  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension IntExt on int {
  bool isBetween(int from, int to) {
    return from < this && this < to;
  }

  bool isBetweenExclusive(int from, int to) {
    return from <= this && this <= to;
  }

  int normalize(int from, int to) {
    if (this < from) {
      return from;
    } else if (this >= from && this <= to) {
      return this;
    } else {
      return to;
    }
  }
}

extension DoubleExt on double {
  bool isBetween(double from, double to) {
    return from < this && this < to;
  }

  bool isBetweenExclusive(double from, double to) {
    return from <= this && this <= to;
  }

  double normalize(double from, double to) {
    if (this < from) {
      return from;
    } else if (this >= from && this <= to) {
      return this;
    } else {
      return to;
    }
  }
}

extension SplitMatch<T> on List<T> {
  ListMatch<T> splitMatch(bool Function(T element) matchFunction) {
    final listMatch = ListMatch<T>();

    for (final element in this) {
      if (matchFunction(element)) {
        listMatch.matched.add(element);
      } else {
        listMatch.unmatched.add(element);
      }
    }

    return listMatch;
  }
}

class ListMatch<T> {
  List<T> matched = <T>[];
  List<T> unmatched = <T>[];
}

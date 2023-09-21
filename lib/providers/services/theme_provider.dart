import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeSettings>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeSettings> {
  @override
  ThemeSettings build() {
    return ThemeSettings(
      mode: ThemeMode.light,
      primaryLightColor: Colors.blueGrey,
      primaryDarkColor: Colors.deepPurpleAccent,
    );
  }

  void toggle() {
    state = state.copyWith(mode: state.mode.toggle);
  }

  void setDarkTheme() {
    state = state.copyWith(mode: ThemeMode.dark);
  }

  void setLightTheme() {
    state = state.copyWith(mode: ThemeMode.light);
  }

  void setSystemTheme() {
    state = state.copyWith(mode: ThemeMode.system);
  }

  void setPrimaryColor(Color color) {
    if (state.mode == ThemeMode.light) {
      state = state.copyWith(primaryLightColor: color);
    } else if (state.mode == ThemeMode.dark) {
      state = state.copyWith(primaryDarkColor: color);
    }
  }
}

class ThemeSettings {
  final ThemeMode mode;
  final Color primaryLightColor;
  final Color primaryDarkColor;

  ThemeSettings({
    required this.mode,
    required this.primaryLightColor,
    required this.primaryDarkColor,
  });

  ThemeSettings copyWith({
    ThemeMode? mode,
    Color? primaryLightColor,
    Color? primaryDarkColor,
  }) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      primaryLightColor: primaryLightColor ?? this.primaryLightColor,
      primaryDarkColor: primaryDarkColor ?? this.primaryDarkColor,
    );
  }
}

extension ToggleTheme on ThemeMode {
  ThemeMode get toggle {
    switch (this) {
      case ThemeMode.dark:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.system:
        return ThemeMode.dark;
    }
  }
}

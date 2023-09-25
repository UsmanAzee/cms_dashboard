import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = NotifierProvider<AppConfig, Map<String, dynamic>>(() => AppConfig());

class AppConfig extends Notifier<Map<String, dynamic>> {
  final _applicationConfig = {
    "useFlutterNavigation": false,
  };

  @override
  Map<String, dynamic> build() {
    return _applicationConfig;
  }

  void updateAppConfig(String key, dynamic value) {
    state = {..._applicationConfig, key: value};
  }

  void toggleNavigationType() {
    state = {..._applicationConfig, "useFlutterNavigation": !state["useFlutterNavigation"]};
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<MenuAppController, Map<String, dynamic>> menuAppControllerProvider = StateNotifierProvider<MenuAppController, Map<String, dynamic>>(
  (ref) => MenuAppController(ref),
);

class MenuAppController extends StateNotifier<Map<String, dynamic>> {
  final Ref ref;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  MenuAppController(this.ref) : super({}) {
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}

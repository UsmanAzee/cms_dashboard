import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuAppControllerProvider = StateNotifierProvider<MenuAppController, GlobalKey<ScaffoldState>>(
  (ref) => MenuAppController(ref),
);

class MenuAppController extends StateNotifier<GlobalKey<ScaffoldState>> {
  final Ref ref;
  MenuAppController(this.ref) : super(GlobalKey<ScaffoldState>(debugLabel: "menuAppControllerProvider"));

  void controlMenu() {
    debugPrint("toggle drawer");
    if (!state.currentState!.isDrawerOpen) {
      state.currentState!.openDrawer();
    }
  }

  void updateScaffoldKey(GlobalKey<ScaffoldState> newKey) {
    state = newKey;
  }
}

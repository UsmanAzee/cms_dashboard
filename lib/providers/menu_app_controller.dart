import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuAppControllerProvider = StateNotifierProvider<MenuAppController, GlobalKey<ScaffoldState>>(
  (ref) => MenuAppController(ref),
);

class MenuAppController extends StateNotifier<GlobalKey<ScaffoldState>> {
  final Ref ref;
  MenuAppController(this.ref) : super(GlobalKey<ScaffoldState>());

  GlobalKey<ScaffoldState> get scaffoldKey => state;

  void controlMenu() {
    debugPrint("toggle drawer");
    if (!state.currentState!.isDrawerOpen) {
      state.currentState!.openDrawer();
    }
  }
}

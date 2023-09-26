import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'loading_modal.dart';

bool isValidUrl(String? url) {
  try {
    if (url == null) return false;
    Uri.parse(url);
    return true;
  } catch (e) {
    return false;
  }
}

// Opens the uri in browser
Future<void> openHttpsUri({required String url}) async {
  try {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  } catch (err) {
    debugPrint('launch https url error: ${err.toString()}');
  }
}

Size getSize(GlobalKey key) {
  Size calculatedSize = const Size(0, 0);
  if (key.currentContext != null) {
    final RenderBox? renderBoxRed = key.currentContext?.findRenderObject() as RenderBox;
    if (renderBoxRed != null) {
      calculatedSize = renderBoxRed.size;
    }
  }
  return calculatedSize;
}

Offset getPosition(GlobalKey key) {
  Offset calculatedPosition = const Offset(0, 0);
  if (key.currentContext != null) {
    final RenderBox? renderBoxRed = key.currentContext?.findRenderObject() as RenderBox;
    if (renderBoxRed != null) {
      calculatedPosition = renderBoxRed.localToGlobal(Offset.zero);
    }
  }
  return calculatedPosition;
}

Route createFadeTransitionRoute(BuildContext context, {required Widget page}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    // reverseTransitionDuration: const Duration(seconds: 2),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route createSlideTransitionRoute(BuildContext context, {required Widget page, Duration? duration}) {
  return PageRouteBuilder(
    transitionDuration: duration ?? const Duration(milliseconds: 200),
    reverseTransitionDuration: duration ?? const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.5, 1.0),
        ),
      );
      var slideAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}

class Utils {
  static late BuildContext context;
  static GlobalKey<LoadingModelState>? _loadingModelState;

  static final Utils _utils = Utils._internal();

  // factory Utils() {
  //   return _alert;
  // }

  factory Utils.of(BuildContext c) {
    context = c;
    return _utils;
  }

  Utils._internal();

  Future<void> startLoading({String text = "Loading"}) async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, _, __) => LoadingModel(key: _loadingModelState, loadingText: text),
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          double begin = 0.0;
          double end = 1.0;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          final animationValue = animation.drive(tween);

          return FadeTransition(
            opacity: animationValue,
            child: child,
          );
        });
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  void changeLoadingText(String text) async {
    _loadingModelState?.currentState?.updateLoadingText(text);
  }
}

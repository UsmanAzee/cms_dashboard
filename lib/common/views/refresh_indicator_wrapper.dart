import 'package:flutter/material.dart';

class RefreshIndicatorWrapper extends StatelessWidget {
  final Widget child;
  final GlobalKey<RefreshIndicatorState> indicatorKey;
  final RefreshCallback onRefresh;

  const RefreshIndicatorWrapper({
    super.key,
    required this.child,
    required this.indicatorKey,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: indicatorKey,
      color: Colors.white,
      backgroundColor: Colors.blue,
      strokeWidth: 4.0,
      onRefresh: onRefresh,
      child: ListView(children: [child]),
    );
  }
}

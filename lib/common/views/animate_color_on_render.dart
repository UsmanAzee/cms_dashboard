import 'package:flutter/material.dart';

typedef AnimatedColorBuilder = Widget Function(BuildContext context, Color? color);

/// Wrapper widget,
/// provides a animating color value that animates on render
/// This is just to show when a widget renders/re-renders
class AnimateColorOnRender extends StatefulWidget {
  final AnimatedColorBuilder animatedColorBuilder;

  const AnimateColorOnRender({Key? key, required this.animatedColorBuilder}) : super(key: key);

  @override
  State<AnimateColorOnRender> createState() => _AnimateColorOnRenderState();
}

class _AnimateColorOnRenderState extends State<AnimateColorOnRender> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 750),
    );
    _colorTween = ColorTween(begin: Colors.pink, end: Colors.blueGrey).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animationController.value > 0) {
      _animationController.value = 0;
    }
    _animationController.forward();

    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => widget.animatedColorBuilder(context, _colorTween.value),
    );
  }
}

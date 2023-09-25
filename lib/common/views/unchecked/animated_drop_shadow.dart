import 'package:flutter/material.dart';

class AnimatedDropShadow extends StatefulWidget {
  final Widget child;

  const AnimatedDropShadow({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedDropShadow> createState() => _AnimatedDropShadowState();
}

class _AnimatedDropShadowState extends State<AnimatedDropShadow> with TickerProviderStateMixin {
  late final AnimationController controller;

  // Tween<double> blurTween = Tween<double>(begin: 10, end: 50);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller.repeat(reverse: true);
    controller.addListener(() {
      setState(() {});
    });
    // controller.drive(_paddingTween).value;

    // controller.addListener(() {
    //   // debugPrint(controller.value.toString());
    // });

    // Tween tween = Tween<double>(begin: 10, end: 100);

    // controller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double blurRadius = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo)
        .drive<double>(Tween<double>(begin: 0, end: 10))
        .value;

    double spreadRadius = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo)
        .drive<double>(Tween<double>(begin: 0, end: 10))
        .value;

    Offset offset = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo)
        .drive<Offset>(Tween<Offset>(begin: Offset(4, 4), end: Offset(4, 8)))
        .value;

    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     blurRadius: 4,
        //     offset: offset,
        //   ),
        //   BoxShadow(
        //     color: Colors.grey,
        //     blurRadius: 4,
        //     offset: offset,
        //   ),
        // ],
        gradient: LinearGradient(
          colors: [
            Colors.grey,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.grey,
          ],
          begin: AlignmentDirectional(1, 10),
          end: AlignmentDirectional(5, 5),
        ),
        color: Colors.white,
      ),
      child: widget.child,
    );
  }
}

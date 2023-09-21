import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingModel extends StatefulWidget {
  final String? loadingText;

  const LoadingModel({Key? key, this.loadingText}) : super(key: key);

  @override
  State<LoadingModel> createState() => LoadingModelState();
}

class LoadingModelState extends State<LoadingModel> {
  String _loadingText = "Loading...";

  @override
  void initState() {
    if (widget.loadingText?.isNotEmpty ?? false) {
      _loadingText = '${widget.loadingText}...';
    }
    super.initState();
  }

  Future<bool> onWillPop() {
    // Disable exit on back button
    return Future.value(false);
  }

  void updateLoadingText(String text) {
    setState(() {
      _loadingText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(0),
        child: ClipRect(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 5.0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            builder: (_, value, __) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            _loadingText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const LinearProgressIndicator(minHeight: 4)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

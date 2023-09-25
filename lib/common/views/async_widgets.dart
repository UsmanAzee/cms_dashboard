import 'package:flutter/material.dart';

typedef OnPressed = Future<void> Function();

class LoadingButton extends StatefulWidget {
  final OnPressed onPressed;
  final bool loading;
  final String label;
  final String loadingLabel;
  final IconData? icon;

  final String? imageAsset;

  const LoadingButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingLabel = "",
    this.icon,
    this.imageAsset,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _loading = false;

  @override
  void initState() {
    _loading = widget.loading;
    super.initState();
  }

  @override
  void didUpdateWidget(LoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loading != widget.loading) {
      debugPrint("check loading state");
      setState(() => _loading = widget.loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle();
    ButtonStyle style = ButtonStyle(
      splashFactory: InkRipple.splashFactory,
      overlayColor: MaterialStateProperty.resolveWith(
        (states) {
          return states.contains(MaterialState.pressed) ? Theme.of(context).colorScheme.onSecondary : null;
        },
      ),
    );

    if (_loading) {
      labelStyle = labelStyle.copyWith(color: Colors.grey.shade400);
      style = style.copyWith(
        backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
      );
    }

    Color loaderColor = Theme.of(context).colorScheme.primary;

    Widget trailingWidget = const SizedBox.shrink();
    Widget leadingWidget = const SizedBox.shrink();

    if (widget.icon != null) {
      leadingWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(widget.icon),
      );
    }

    if (widget.imageAsset != null) {
      leadingWidget = Container(
        width: 24,
        height: 24,
        // padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.asset(widget.imageAsset!),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: ElevatedButton(
        key: UniqueKey(),
        style: style,
        onPressed: () async {
          if (_loading) return;
          setState(() => _loading = true);
          await widget.onPressed();
          if (mounted) setState(() => _loading = false);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leadingWidget,
            if (widget.icon != null || widget.imageAsset != null) const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _loading && widget.loadingLabel.isNotEmpty ? widget.loadingLabel : widget.label,
                style: labelStyle,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _loading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: loaderColor,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : trailingWidget,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIconButton extends StatefulWidget {
  final OnPressed onPressed;

  /// icon button loading state.
  ///
  /// Set true to show the loader.
  ///
  /// If provided onPressed callback function is asynchronous
  /// then it'll show loader until callback is returned.
  final bool loading;
  final IconData icon;

  /// icon button content color.
  ///
  /// This includes loader color, button border color and button icon color
  final Color? contentColor;

  final Color? backgroundColor;

  /// The size of the icon button.
  ///
  /// This must be in the range of 40 - 80
  ///
  final double size;

  /// Button will be circular by default
  final BorderRadius? radius;

  static const double minimumSize = 40;
  static const double maximumSize = 70;

  const LoadingIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.loading = false,
    this.contentColor,
    this.backgroundColor,
    this.size = minimumSize,
    this.radius,
  }) : super(key: key);

  @override
  State<LoadingIconButton> createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton> {
  bool _loading = false;

  @override
  void initState() {
    _loading = widget.loading;
    super.initState();
  }

  @override
  void didUpdateWidget(LoadingIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loading != widget.loading) {
      debugPrint("check loading state");
      setState(() => _loading = widget.loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color contentColor = widget.contentColor ?? Theme.of(context).colorScheme.primary.withOpacity(1);

    double containerSize =
        widget.size >= LoadingIconButton.minimumSize && widget.size <= LoadingIconButton.maximumSize ? widget.size : LoadingIconButton.minimumSize;
    double iconSize = (widget.size * 3 / 4).roundToDouble();

    BorderRadius radius = widget.radius ?? BorderRadius.circular(50);

    return ClipRRect(
      borderRadius: radius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: InkWell(
            key: UniqueKey(),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed) ? Theme.of(context).colorScheme.onSecondary : null;
              },
            ),
            onTap: () async {
              if (_loading) return;
              setState(() => _loading = true);
              await widget.onPressed();
              setState(() => _loading = false);
            },
            child: Container(
              decoration: BoxDecoration(
                color: _loading ? Colors.grey.shade200 : const Color(0xffeef4f7),
                // color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 1.5),
                  ),
                ],
                borderRadius: radius,
                // border: widget.showBorder
                //     ? Border.all(
                //         color: _loading ? Colors.transparent : const Color(0xffcedfe7),
                //       )
                //     : null,
              ),
              width: containerSize,
              height: containerSize,
              child: Center(
                child: _loading
                    ? SizedBox(
                        width: iconSize - 10,
                        height: iconSize - 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: contentColor,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        color: contentColor,
                        size: iconSize,
                        // weight: 0.1,   // TODO weight is not working for icon
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AsyncImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final String name; // Unique name for this image

  const AsyncImage({
    Key? key,
    required this.name,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.fit = BoxFit.fitWidth,
  }) : super(key: key);

  @override
  State<AsyncImage> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  late String imageUrl;

  @override
  void initState() {
    imageUrl = widget.imageUrl;
    super.initState();
  }

  @override
  void didUpdateWidget(AsyncImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        imageUrl = widget.imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color errorColor = Colors.pinkAccent.shade100;
    Color errorColor = Theme.of(context).colorScheme.error.withAlpha(180);

    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          // constraints: BoxConstraints(maxWidth: widget.width ?? maxWidth, maxHeight: widget.height ?? maxHeight),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius - 1),
            child: Image.network(
              imageUrl,
              fit: widget.fit,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                double? progressValue =
                    loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null;

                return Center(
                  child: LinearProgressIndicator(
                    value: progressValue,
                  ),
                );
              },
              errorBuilder: (context, exception, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error,
                        color: errorColor,
                        size: 42,
                      ),
                      Text("Error loading image", textAlign: TextAlign.center, style: TextStyle(color: errorColor))
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // const Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: CircularProgressIndicator(),
        //   ),
        // )
      ],
    );
  }
}

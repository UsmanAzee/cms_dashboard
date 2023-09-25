import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';

// https://github.com/mhmzdev/awesome_snackbar_content/tree/main
// https://pub.dev/packages/awesome_snackbar_content
class CustomSnackbar extends StatelessWidget {
  static const String back = 'assets/snackbar/back.svg';
  static const String bubbles = 'assets/snackbar/bubbles.svg';

  /// `IMPORTANT NOTE` for SnackBar properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// behavior: SnackBarBehavior.floating
  /// elevation: 0.0

  /// /// `IMPORTANT NOTE` for MaterialBanner properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// forceActionsBelow: true,
  /// elevation: 0.0
  /// [inMaterialBanner = true]

  /// title is the header String that will show on top
  final String title;

  /// message String is the body message which shows only 2 lines at max
  final String message;

  /// `optional` color of the SnackBar/MaterialBanner body
  final Color? color;

  /// contentType will reflect the overall theme of SnackBar/MaterialBanner: failure, success, help, warning
  final ContentType contentType;

  /// if you want to use this in materialBanner
  final bool inMaterialBanner;

  /// if you want to customize the font size of the title
  final double? titleFontSize;

  /// if you want to customize the font size of the message
  final double? messageFontSize;

  const CustomSnackbar({
    Key? key,
    this.color,
    this.titleFontSize,
    this.messageFontSize,
    required this.title,
    required this.message,
    required this.contentType,
    this.inMaterialBanner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // screen dimensions
    bool isMobile = size.width <= 768;
    bool isTablet = size.width > 768 && size.width <= 992;

    /// for reflecting different color shades in the SnackBar
    final hsl = HSLColor.fromColor(color ?? contentType.color!);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    double horizontalPadding = 0.0;
    double leftSpace = size.width * 0.12;

    if (isMobile) {
      horizontalPadding = size.width * 0.01;
    } else if (isTablet) {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.2;
    } else {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.3;
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      height: size.height * 0.125,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          /// background container
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(20),
            color: color ?? contentType.color,
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: color ?? contentType.color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// Splash SVG asset
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
              child: SvgPicture.asset(
                bubbles,
                height: size.height * 0.06,
                width: size.width * 0.05,
                colorFilter: _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
              ),
            ),
          ),

          // Bubble Icon
          Positioned(
            top: -size.height * 0.02,
            left: leftSpace - 8 - (isMobile ? size.width * 0.075 : size.width * 0.035),
            right: null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  back,
                  height: size.height * 0.06,
                  colorFilter: _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                ),
                Positioned(
                  top: size.height * 0.015,
                  child: SvgPicture.asset(
                    contentType.assetPath,
                    height: size.height * 0.022,
                  ),
                )
              ],
            ),
          ),

          /// content
          Positioned.fill(
            left: leftSpace,
            right: size.width * 0.03,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize ?? (!isMobile ? size.height * 0.03 : size.height * 0.025),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (inMaterialBanner) {
                          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                          return;
                        }
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: SvgPicture.asset(
                        SnackbarTypes.failure.assetPath,
                        height: size.height * 0.022,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: messageFontSize ?? size.height * 0.016,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static ColorFilter? _getColorFilter(ui.Color? color, ui.BlendMode colorBlendMode) => color == null ? null : ui.ColorFilter.mode(color, colorBlendMode);
}

class ContentType {
  final String title;
  final Color? color;
  final String assetPath;

  const ContentType({
    required this.title,
    required this.color,
    required this.assetPath,
  });
}

class SnackbarTypes {
  static const ContentType help = ContentType(
    title: 'help',
    color: Color(0xff03A9F4),
    assetPath: 'assets/snackbar/types/help.svg',
  );
  static const ContentType failure = ContentType(
    title: 'failure',
    color: Color(0xffFF5722),
    assetPath: 'assets/snackbar/types/failure.svg',
  );
  static const ContentType success = ContentType(
    title: 'success',
    color: Color(0xff4CAF50),
    assetPath: 'assets/snackbar/types/success.svg',
  );
  static const ContentType warning = ContentType(
    title: 'warning',
    color: Color(0xffFFC107),
    assetPath: 'assets/snackbar/types/warning.svg',
  );
}

// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';
import './extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertType {
  static const int BANNER = 1;
  static const int SNACKBAR = 2;
  static const int BOTTOM_SHEET = 3;
}

class Alert {
  static late BuildContext _context;
  final SnackBarBehavior _snackBarBehavior = SnackBarBehavior.fixed;
  static const double alertShowDuration = 2000;

  static final Alert _alert = Alert._internal();

  // factory Alert() {
  //   return _alert;
  // }

  factory Alert.of(BuildContext context) {
    _context = context;
    return _alert;
  }

  Alert._internal();

  Future<void> showAlert({
    required String alertText,
    Color backgroundColor = const Color(0xFF0091EA),
    Color color = const Color(0xFF0091EA),
    IconData snackbarIcon = Icons.info_outline,
    double timeout = alertShowDuration,
  }) async {
    try {
      if (alertText.trim().isEmpty) {
        return;
      }

      // if (alertText.length > 200) {
      //   alertText = alertText.substring(0, 200) + " ...";
      // }

      /// Get current scaffold messenger state
      ScaffoldMessengerState mState = ScaffoldMessenger.of(_context);

      /// Hide any snackbar already on view
      mState.hideCurrentSnackBar();

      /// Show new snackbar
      ScaffoldFeatureController controller = mState.showSnackBar(
        SnackBar(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          // ),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            padding: const EdgeInsets.symmetric(vertical: 4),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.vertical(
            //     top: Radius.circular(16),
            //   ),
            // ),
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  children: [
                    // WidgetSpan(
                    //   alignment: PlaceholderAlignment.bottom,
                    //   child: Icon(
                    //     snackbarIcon,
                    //     color: color,
                    //     size: 18,
                    //   ),
                    // ),
                    // WidgetSpan(child: const SizedBox(width: 8)),
                    TextSpan(
                      text: alertText,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          behavior: _snackBarBehavior,
          backgroundColor: backgroundColor,
          // duration: Duration(milliseconds: timeout.normalize(1000, 6000).round()),
        ),
      );

      /// add a timeout for closing the alert
      int t = timeout.normalize(1000, 10000).round();
      Future.delayed(
        Duration(milliseconds: t),
        () => controller.close,
      );

      /// wait for alert to be closed
      await controller.closed;
    } catch (err) {
      debugPrint("Error showing snack bar alert: ${err.toString()}");
    }
  }

  Future<void> showAlertBanner({
    required String alertText,
    Color backgroundColor = const Color(0xFF0091EA),
    Color color = const Color(0xFFFFFFFF),
    IconData bannerIcon = Icons.info_outline,
    double timeout = alertShowDuration,
  }) async {
    try {
      // if (alertText.length > 200) {
      //   alertText = alertText.substring(0, 200) + " ...";
      // }

      /// Get current scaffold messenger state
      ScaffoldMessengerState mState = ScaffoldMessenger.of(_context);

      /// Hide any snackbar already on view
      mState.hideCurrentMaterialBanner();

      /// Show new snackbar
      ScaffoldFeatureController controller = mState.showMaterialBanner(
        MaterialBanner(
          // forceActionsBelow: true,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.all(12),
          content: Container(
            constraints: const BoxConstraints(minHeight: 60, maxHeight: 150),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  children: [
                    // WidgetSpan(
                    //   alignment: PlaceholderAlignment.bottom,
                    //   child: Icon(
                    //     bannerIcon,
                    //     color: color,
                    //     size: 18,
                    //   ),
                    // ),
                    const WidgetSpan(child: SizedBox(width: 2)),
                    TextSpan(
                      text: alertText,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: backgroundColor,
              //   shape: RoundedRectangleBorder(
              //   //   side: BorderSide(width: 1, color: color),
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   // shadowColor: color,
              // ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: color,
              ),
              child: Text(
                'Dismiss',
                style: TextStyle(
                  color: Theme.of(_context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              onPressed: () => ScaffoldMessenger.of(_context).hideCurrentMaterialBanner(),
            ),
          ],
        ),
      );

      if (timeout.isFinite) {
        /// add a timeout for closing the alert
        Future.delayed(
          Duration(milliseconds: timeout.normalize(1000, 10000).round()),
          () {
            try {
              controller.close();
            } catch (err) {
              // debugPrint("close alert error:\n\t${err.toString()}");
            }
          },
        );
      }

      /// wait for alert to be closed
      await controller.closed;
    } catch (err) {
      debugPrint("Error showing material banner alert: ${err.toString()}");
    }
  }

  Future<void> showAlertBottomSheet({
    required String alertText,
    IconData alertIcon = Icons.info_outline,
    Color alertColor = const Color(0xFF0091EA),
    Color textColor = const Color(0xFFFFFFFF),
    double timeout = double.infinity,
  }) async {
    try {
      await showModalBottomSheet(
        // expand: false,
        isScrollControlled: true,
        constraints: BoxConstraints(
          minHeight: max(150, MediaQuery.of(_context).size.height * 0.2),
          maxHeight: min(300, MediaQuery.of(_context).size.height * 0.3),
        ),
        context: _context,
        // duration: const Duration(milliseconds: 250),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (context) => AlertBottomSheet(
          timeout: timeout,
          alertText: alertText,
          alertIcon: alertIcon,
          textColor: textColor,
          backgroundColor: alertColor,
        ),
      );
    } catch (err) {
      debugPrint("Error showing alert bottom sheet: ${err.toString()}");
    }
  }

  Future<void> info({
    int type = AlertType.SNACKBAR,
    required String alertText,
    double timeout = alertShowDuration,
  }) async {
    const IconData infoIcon = Icons.info_outline;
    final Color backgroundColor = Theme.of(_context).colorScheme.primary.withOpacity(0.4);
    final Color textColor = Theme.of(_context).colorScheme.onPrimary;

    switch (type) {
      case AlertType.SNACKBAR:
        {
          await showAlert(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            snackbarIcon: infoIcon,
            timeout: timeout,
          );
          break;
        }
      case AlertType.BANNER:
        {
          await showAlertBanner(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            bannerIcon: infoIcon,
            timeout: timeout,
          );
          break;
        }
      case AlertType.BOTTOM_SHEET:
        {
          await showAlertBottomSheet(
            alertText: alertText,
            alertIcon: infoIcon,
            textColor: textColor,
            alertColor: backgroundColor,
            timeout: timeout,
          );
          break;
        }
      default:
        {
          break;
        }
    }
  }

  Future<void> warn({
    int type = AlertType.SNACKBAR,
    required String alertText,
    double timeout = alertShowDuration,
  }) async {
    const IconData warningIcon = Icons.warning_amber;
    final Color backgroundColor = Theme.of(_context).colorScheme.tertiary.withOpacity(0.4);
    final Color textColor = Theme.of(_context).colorScheme.onTertiary;

    switch (type) {
      case AlertType.SNACKBAR:
        {
          await showAlert(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            snackbarIcon: warningIcon,
            timeout: timeout,
          );
          break;
        }
      case AlertType.BANNER:
        {
          await showAlertBanner(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            bannerIcon: warningIcon,
            timeout: timeout,
          );
          break;
        }
      default:
        {
          await showAlertBottomSheet(
            alertText: alertText,
            alertIcon: warningIcon,
            textColor: textColor,
            alertColor: backgroundColor,
            timeout: timeout,
          );
          break;
        }
    }
  }

  Future<void> error({
    int type = AlertType.SNACKBAR,
    required String alertText,
    double timeout = 5000,
  }) async {
    const IconData errorIcon = Icons.error_outline;
    final Color backgroundColor = Theme.of(_context).colorScheme.error;
    final Color textColor = Theme.of(_context).colorScheme.onError;

    switch (type) {
      case AlertType.SNACKBAR:
        {
          await showAlert(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            snackbarIcon: errorIcon,
            timeout: timeout,
          );
          break;
        }
      case AlertType.BANNER:
        {
          await showAlertBanner(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            bannerIcon: errorIcon,
            timeout: timeout,
          );
          break;
        }
      case AlertType.BOTTOM_SHEET:
        {
          await showAlertBottomSheet(
            alertText: alertText,
            alertIcon: errorIcon,
            textColor: textColor,
            alertColor: backgroundColor,
            timeout: timeout,
          );
          break;
        }
      default:
        {
          await showAlertBottomSheet(
            alertText: alertText,
            alertIcon: errorIcon,
            textColor: textColor,
            alertColor: backgroundColor,
            timeout: timeout,
          );
          break;
        }
    }
  }

  Future<void> success({
    int type = AlertType.SNACKBAR,
    required String alertText,
    double timeout = alertShowDuration,
  }) async {
    const IconData successIcon = Icons.check_circle;
    final Color backgroundColor = Theme.of(_context).colorScheme.primary;
    final Color textColor = Theme.of(_context).colorScheme.onPrimary;

    switch (type) {
      case AlertType.SNACKBAR:
        {
          await showAlert(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            snackbarIcon: successIcon,
            timeout: timeout,
          );
          break;
        }
      case AlertType.BANNER:
        {
          await showAlertBanner(
            alertText: alertText,
            backgroundColor: backgroundColor,
            color: textColor,
            bannerIcon: successIcon,
            timeout: timeout,
          );
          break;
        }
      default:
        {
          await showAlertBottomSheet(
            alertText: alertText,
            alertIcon: successIcon,
            textColor: textColor,
            alertColor: backgroundColor,
            timeout: timeout,
          );
          break;
        }
    }
  }

  Future<void> showHttpsUri({required String url}) async {
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

  Future<bool> showConfirmationAlert({
    required String title,
    required String body,
    Function? onConfirm,
    String negativeButtonLabel = "CANCEL",
    String positiveButtonLabel = "CONFIRM",
  }) async {
    dynamic isConfirmed = await showModalBottomSheet(
      // expand: false,
      context: _context,
      // duration: const Duration(milliseconds: 250),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) =>
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        const Divider(),
        Flexible(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
          child: ButtonBar(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 40),
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: Text(negativeButtonLabel.toUpperCase()),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 40),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm();
                  }

                  Navigator.pop(context, true);
                },
                child: Text(positiveButtonLabel.toUpperCase()),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 8),
      ]),
    );

    return isConfirmed != null && isConfirmed == true;
  }
}

class AlertBottomSheet extends StatefulWidget {
  final String alertText;
  final Color textColor;
  final Color backgroundColor;
  final IconData alertIcon;
  final double timeout;

  const AlertBottomSheet({
    Key? key,
    required this.alertText,
    required this.textColor,
    required this.backgroundColor,
    required this.alertIcon,
    required this.timeout,
  }) : super(key: key);

  @override
  State<AlertBottomSheet> createState() => _AlertBottomSheetState();
}

class _AlertBottomSheetState extends State<AlertBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.timeout > 0 && widget.timeout != double.infinity) {
        Future.delayed(Duration(milliseconds: widget.timeout.toInt()), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 8),
                  //     child: Icon(widget.alertIcon, color: widget.alertColor, size: 32),
                  //   ),
                  // ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(
                      children: [
                        // WidgetSpan(
                        //   alignment: PlaceholderAlignment.bottom,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        //     child: Icon(widget.alertIcon, color: widget.textColor, size: 32),
                        //   ),
                        // ),
                        // WidgetSpan(child: const SizedBox(width: 16)),
                        TextSpan(
                          text: widget.alertText,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                // color: widget.alertColor,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 2),
        const SizedBox(height: 12),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(130, 40),
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.textColor,
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              // onOk?.call();
              Navigator.pop(context, true);
            },
            child: const Text("Ok"),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package_info_provider.dart';

final analyticsProvider = StateProvider<FirebaseAnalytics>((ref) {
  FirebaseAnalytics analyticsInstance = FirebaseAnalytics.instance;
  final packageInfo = ref.watch(packageInfoProvider);

  analyticsInstance.setDefaultEventParameters({
    "appName": packageInfo.appName,
    "packageName": packageInfo.packageName,
    "version": packageInfo.version,
    "buildNumber": packageInfo.buildNumber,
    "buildSignature": packageInfo.buildSignature,
    "installerStore": packageInfo.installerStore,
  });

  return analyticsInstance;
});

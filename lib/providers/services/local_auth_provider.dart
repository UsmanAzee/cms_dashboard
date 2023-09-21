import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final localAuthProvider = NotifierProvider<AppLocalAuth, Map<String, dynamic>>(() => AppLocalAuth());

class AppLocalAuth extends Notifier<Map<String, dynamic>> {
  final LocalAuthentication _auth = LocalAuthentication();
  final Map<String, dynamic> _authentications = {};

  @override
  Map<String, dynamic> build() {
    return _authentications;
  }

  Future<bool> getAuthentication({
    required String key,
    required String message,
    bool saveResponse = false,
  }) async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();

    bool isAuthenticated = false;

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
      try {
        isAuthenticated = await _auth.authenticate(
          localizedReason: message,
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
        debugPrint("$message\nauthentication result: $isAuthenticated");
        // ···
      } on PlatformException catch (err) {
        // ...
        debugPrint("Platform exception: ${err.toString()}");
      }
    } else {
      debugPrint("no biometrics available");
    }

    if (saveResponse) {
      state = {...state, key: isAuthenticated};
    }

    return isAuthenticated;
  }
}

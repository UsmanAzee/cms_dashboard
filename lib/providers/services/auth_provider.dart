// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_auth_provider.dart';
import 'shared_prefs_provider.dart';

// Firebase auth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Firebase auth stream provider
final authStateProvider = StreamProvider<User?>((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final authProvider = NotifierProvider<AuthenticationService, AuthCredential?>(() => AuthenticationService());

class AuthenticationService extends Notifier<AuthCredential?> {
  final String _prefs_key = "auth_cred";
  BuildContext? _rootContext;

  @override
  AuthCredential? build() {
    return null;
  }

  void updateRootContext(BuildContext context) {
    _rootContext = context;
  }

  Future<void> signOut() async {
    try {
      await ref.watch(firebaseAuthProvider).signOut();
      if (_rootContext != null) {
        Navigator.of(_rootContext!, rootNavigator: true).popUntil((route) => route.isFirst);
        // await Navigator.of(
        //   _rootContext!,
        //   rootNavigator: true,
        // ).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const LoginPage(),
        //   ),
        //   (route) => false,
        // );
      }
    } catch (err) {
      debugPrint("Error signing out:\n${err.toString()}");
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      UserCredential cred = await ref.watch(firebaseAuthProvider).signInWithProvider(GoogleAuthProvider());
      state = cred.credential;
      ref.watch(sharedPrefsProvider).setString(
          _prefs_key,
          jsonEncode({
            "providerId": state!.providerId,
            "signInMethod": state!.signInMethod,
            "token": state!.token,
            "accessToken": state!.accessToken,
          }));

      return true;
    } catch (err) {
      debugPrint("error signing in with google");
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential cred = await ref.watch(firebaseAuthProvider).signInWithEmailAndPassword(email: email, password: password);
      state = cred.credential;
      if (cred.credential != null) {
        ref.watch(sharedPrefsProvider).setString(
            _prefs_key,
            jsonEncode({
              "providerId": state!.providerId,
              "signInMethod": state!.signInMethod,
              "token": state!.token,
              "accessToken": state!.accessToken,
            }));
      }

      return true;
    } catch (err) {
      debugPrint("error signing in with email and password");
      return false;
    }
  }

  Future<void> signInAnonymously() async {
    // anonymous sign in, clear saved user credentials
    state = null;
    ref.watch(sharedPrefsProvider).remove(_prefs_key);
    await ref.watch(firebaseAuthProvider).signInAnonymously();
  }

  Future<bool> localAuthentication() async {
    final String? authCredStr = ref.watch(sharedPrefsProvider).getString(_prefs_key);
    if (authCredStr == null) {
      debugPrint("No saved credentials, User must sign in with an account first");
      return false;
    }

    final bool isAuthenticated =
        await ref.watch(localAuthProvider.notifier).getAuthentication(key: "login_authentication", message: "Please sign in to continue");
    if (isAuthenticated) {
      debugPrint("use saved user credentials object to sign in with firebase");
      Map<String, dynamic> authCredMap = jsonDecode(authCredStr);

      AuthCredential credentials = AuthCredential(
        providerId: authCredMap['providerId'],
        signInMethod: authCredMap['signInMethod'],
        token: authCredMap['token'],
        accessToken: authCredMap['accessToken'],
      );

      ref.watch(firebaseAuthProvider).signInWithCredential(credentials);
    }

    return isAuthenticated;
  }
}

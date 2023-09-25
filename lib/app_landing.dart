import 'package:cms_dashboard/providers/services/auth_provider.dart';
import 'package:cms_dashboard/screens/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/navigation/my_scaffold_nav.dart';

class AppLanding extends ConsumerStatefulWidget {
  const AppLanding({super.key});

  @override
  ConsumerState<AppLanding> createState() => AppLandingState();

  static AppLandingState? getState(BuildContext context) {
    return context.findAncestorStateOfType<AppLandingState>();
  }
}

class AppLandingState extends ConsumerState<AppLanding> {
  void refresh() {
    debugPrint("Inside App Landing widget state");
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateProvider).when(
      data: (User? user) {
        if (user != null) {
          // update provider context which may be used when signing
          // out user from inside the provider
          ref.read(authProvider.notifier).updateRootContext(context);

          return const MyScaffoldNav();
        } else {
          return const LoginPage();
        }
      },
      error: (error, stackTrace) {
        return const LoginPage();
      },
      loading: () {
        return const Scaffold(
          body: Center(child: LinearProgressIndicator()),
        );
      },
    );
  }
}

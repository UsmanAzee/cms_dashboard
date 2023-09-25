import 'package:cms_dashboard/responsive.dart';
import 'package:cms_dashboard/screens/demo/demo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/services/auth_provider.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/splash.dart';
import 'pages_data.dart';

// Preserve widget state issue
/*
  Widget state resets as it goes to background. i.e. every time a page
  route is called forth, it goes into 'initState' method.
  This is not good if we are doing some expensive initialization logic.
  Means by default that initialization logic will run EVERY TIME that
  route is called forth.

  Moreover, flutter does not recommend using named routes any more.
  (See flutter documentation)
 */
// Go router issue main page:
// https://github.com/flutter/flutter/issues/99124

// recommended solution for above issue:
// https://github.com/flutter/packages/pull/2650
// https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html

/*
  Recommended solution feels too cumbersome for simple navigation in application.
 */

typedef PageBuilder = Widget Function(GoRouterState);

// final Map<PageData, PageBuilder> routes = {
//   Pages.home: (GoRouterState state) => HomePage(routerState: state),
// };

final GlobalKey<NavigatorState> _routerKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  final Map<PageData, Widget> pageWidgets = {
    Pages.home: const HomeScreen(),
    Pages.demo: const DemoScreen(),
  };

  return GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routeLocation,
    routes: [
      GoRoute(
        path: SplashPage.routeLocation,
        name: SplashPage.routeName,
        pageBuilder: (context, state) => _pageBuilderTransition(
          context,
          state,
          (GoRouterState state) => const SplashPage(),
        ),
      ),
      GoRoute(
        path: LoginPage.routeLocation,
        name: LoginPage.routeName,
        pageBuilder: (context, state) => _pageBuilderTransition(
          context,
          state,
          (GoRouterState state) => LoginPage(routerState: state),
        ),
      ),
      for (PageData page in Pages())
        GoRoute(
          path: page.routeLocation,
          name: page.name,
          pageBuilder: (context, state) => _pageBuilderTransition(
            context,
            state,
            (GoRouterState state) => pageWidgets[page] ?? const SizedBox.shrink(),
          ),
        )
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      final isSplash = state.fullPath == SplashPage.routeLocation;
      if (isSplash) {
        return isAuth ? Pages.home.routeLocation : LoginPage.routeLocation;
      }

      final isLoggingIn = state.fullPath == LoginPage.routeLocation;
      if (isLoggingIn) return isAuth ? Pages.home.routeLocation : null;

      return isAuth ? null : SplashPage.routeLocation;
    },
  );
});

CustomTransitionPage _pageBuilderTransition(BuildContext context, GoRouterState state, PageBuilder pageBuilder) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: pageBuilder(state),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      // return FadeTransition(
      //   opacity:
      //   CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      //   child: child,
      // );

      if (Responsive.isDesktop(context)) {
        return child;
      }

      return SlideTransition(
        position: Tween(
          begin: const Offset(-1.5, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.bounceIn,
          ),
        ),
        child: child,
      );
    },
  );
}

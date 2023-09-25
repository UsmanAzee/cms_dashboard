import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/menu_app_controller.dart';
import '../../providers/services/network_connectivity_provider.dart';
import '../../responsive.dart';
import '../views/custom_snackbar.dart';
import 'my_drawer.dart';
import 'pages_data.dart';

class MyScaffoldRouter extends ConsumerWidget {
  final Widget body;
  final PageData page;

  const MyScaffoldRouter({
    super.key,
    required this.body,
    required this.page,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(connectivityProvider, (bool? prevState, bool newState) {
      if (prevState == true && newState == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: CustomSnackbar(
              title: "Connection problem",
              message: "Internet connection is unavailable",
              contentType: SnackbarTypes.failure,
            ),
          ),
        );
      }

      if (newState == true && prevState == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: CustomSnackbar(
              title: "Connection restored",
              message: "Internet connection available",
              contentType: SnackbarTypes.success,
            ),
          ),
        );
      }
    });

    final Key scaffoldKey = ref.watch(menuAppControllerProvider.notifier).scaffoldKey;

    final bool isDesktop = Responsive.isDesktop(context);

    // Scaffold wrapper
    return Scaffold(
      key: scaffoldKey,
      appBar: isDesktop
          ? null
          : AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(page.title),
        forceMaterialTransparency: true,
      ),
      drawer: MyDrawer(
        currentPage: page,
          navigateToPage: (page) {
            context.go(page.routeLocation);
          },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/7 part of the screen
              child: MyDrawer(
                currentPage: page,
                navigateToPage: (page) => context.go(page.routeLocation),
              ),
            ),
          Expanded(
            // It takes 5/6 part of the screen
            flex: 6,
            child: body,
          ),
        ],
      ),
    );
  }
}

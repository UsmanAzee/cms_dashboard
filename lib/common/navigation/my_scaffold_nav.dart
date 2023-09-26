import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services/network_connectivity_provider.dart';
import '../../responsive.dart';
import '../../screens/demo/demo_screen.dart';
import '../../screens/home/home_screen.dart';
import '../views/custom_snackbar.dart';
import 'my_drawer.dart';
import 'pages_data.dart';

/*
Scaffold wrapper for main page views.
Contains common drawer for all page views
 */
class MyScaffoldNav extends ConsumerStatefulWidget {
  final PageData? defaultPage;

  const MyScaffoldNav({
    super.key,
    this.defaultPage,
  });

  @override
  ConsumerState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends ConsumerState<MyScaffoldNav> {
  late PageData currentPage;

  final Map<PageData, Widget> pagesWidget = {};

  @override
  void initState() {
    if (widget.defaultPage != null) {
      currentPage = widget.defaultPage!;
    } else {
      currentPage = Pages.home;
    }
    super.initState();
  }

  Widget getPageWidget(PageData page) {
    switch (page.routeLocation) {
      case "/":
        {
          if (!pagesWidget.containsKey(Pages.home) || pagesWidget[Pages.home] == null) {
            pagesWidget[Pages.home] = const HomeScreen();
          }
          return pagesWidget[Pages.home]!;
        }
      case "/demo":
        {
          if (!pagesWidget.containsKey(Pages.demo) || pagesWidget[Pages.demo] == null) {
            pagesWidget[Pages.demo] = const DemoScreen();
          }
          return pagesWidget[Pages.demo]!;
        }
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
      Subscribe to user connectivity events and
      show notification when user disconnects/re-connects
      to internet.
      Using
     */
    ref.listen(connectivityProvider, (bool? prevState, bool newState) {
      if (prevState == true && newState == false) {
        // Internet connection not available
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
        // Internet connection is available
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

    final bool isDesktop = Responsive.isDesktop(context);

    // Scaffold wrapper
    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(currentPage.title),
              forceMaterialTransparency: true,
            ),
      drawer: MyDrawer(
        currentPage: currentPage,
        navigateToPage: (page) {
          setState(() => currentPage = page);
        },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: MyDrawer(
                currentPage: currentPage,
                navigateToPage: (page) {
                  setState(() => currentPage = page);
                },
              ),
            ),
          Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: getPageWidget(currentPage),
          ),
        ],
      ),
    );
  }
}

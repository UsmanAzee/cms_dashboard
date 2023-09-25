import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/services/auth_provider.dart';
import '../../responsive.dart';
import 'drawer_list_tile.dart';
import 'pages_data.dart';

class MyDrawer extends StatelessWidget {
  final PageData currentPage;
  final Function(PageData page) navigateToPage;

  const MyDrawer({
    Key? key,
    required this.navigateToPage,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(color: Colors.blue),
            child: Image.asset("assets/images/logo.png"),
          ),
          for (PageData pageData in Pages())
            DrawerListTile(
              onTap: () {
                if (!Responsive.isDesktop(context)) {
                  // Exit Drawer
                  Navigator.of(context).pop();
                }
                // Callback function to navigate to another page view
                navigateToPage(pageData);
              },
              currentPage: currentPage,
              pageData: pageData,
            ),
          Consumer(
            builder: (context, ref, child) => ListTile(
              onTap: () => ref.watch(firebaseAuthProvider).signOut(),
              horizontalTitleGap: 0.0,
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        ],
      ),
    );
  }
}

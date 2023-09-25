import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/navigation/pages_data.dart';
import '../../common/views/page_wrapper.dart';
import 'components/dashboard/dashboard_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        dynamic doPop = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              insetPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Are you sure you want to exit application? "),
                    ),
                    const SizedBox(height: 11),
                    const Divider(height: 2),
                    ButtonBar(
                      buttonPadding: const EdgeInsets.only(left: 16),
                      alignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Stay"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onTertiary,
                            foregroundColor: Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Exit"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );

        doPop ??= false;

        return doPop;
      },
      child: const PageWrapper(
        page: Pages.home,
        body: DashboardScreen(),
      ),
    );
  }
}

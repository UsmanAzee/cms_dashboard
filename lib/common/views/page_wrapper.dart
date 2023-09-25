import 'package:cms_dashboard/common/navigation/my_scaffold_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_config_provider.dart';
import '../navigation/pages_data.dart';

class PageWrapper extends ConsumerWidget {
  final Widget body;
  final PageData page;

  const PageWrapper({
    super.key,
    required this.page,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(appConfigProvider);

    final bool usingFlutterNav = appConfig.containsKey('useFlutterNavigation') && appConfig['useFlutterNavigation'];

    if (usingFlutterNav) {
      return body;
    }

    return MyScaffoldRouter(
      page: page,
      body: body,
    );


    // return Responsive(
    //   mobile: FileInfoCardGridView(
    //     crossAxisCount: size.width < 650 ? 2 : 4,
    //     childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
    //   ),
    //   tablet: const FileInfoCardGridView(),
    //   desktop: FileInfoCardGridView(
    //     childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
    //   ),
    // )
  }
}

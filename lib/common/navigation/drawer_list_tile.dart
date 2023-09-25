import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'pages_data.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.pageData,
    required this.currentPage,
    required this.onTap,
  }) : super(key: key);
  final PageData currentPage;
  final PageData pageData;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        pageData.svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        pageData.title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

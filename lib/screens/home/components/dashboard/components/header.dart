import 'package:cms_dashboard/common/utils/utils.dart';
import 'package:cms_dashboard/providers/services/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants.dart';
import '../../../../../responsive.dart';

class Header extends ConsumerWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // if (!Responsive.isDesktop(context))
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: Scaffold.of(context).isDrawerOpen ? Scaffold.of(context).closeDrawer : Scaffold.of(context).openDrawer,
        //   ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context)) Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends ConsumerWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  Widget getProfileImage(String? url) {
    if (isValidUrl(url)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          url!,
          height: 38,
        ),
      );
    } else {
      return Image.asset(
        "assets/images/profile_pic.png",
        height: 38,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserInfo userInfo = ref.watch(userInfoProvider);

    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          getProfileImage(userInfo.photoURL),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(userInfo.displayName),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}

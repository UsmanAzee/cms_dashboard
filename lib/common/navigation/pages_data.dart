class PageData {
  final String title;
  final String name;
  final String routeLocation;
  final int index;
  final String svgSrc;

  // final Widget page;

  const PageData({
    required this.index,
    required this.title,
    required this.svgSrc,
    required this.name,
    required this.routeLocation,
    // required this.page,
  });

  // override for equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PageData && other.title == title && other.name == name && other.routeLocation == routeLocation;
  }

  @override
  int get hashCode => Object.hash(title, name, routeLocation);
}

class Pages extends Iterable<PageData> {
  static const PageData home = PageData(
    index: 0,
    title: "Home",
    svgSrc: "assets/icons/menu_dashboard.svg",
    name: "Home",
    routeLocation: "/",
  );

  static const PageData demo = PageData(
    index: 1,
    title: "Demo",
    svgSrc: "assets/icons/menu_task.svg",
    name: "Demo",
    routeLocation: "/demo",
  );

  // static const PageData transaction = PageData(
  //   index: 1,
  //   title: "Transaction",
  //   svgSrc: "assets/icons/menu_tran.svg",
  //   name: "Transaction",
  //   routeLocation: "/transaction",
  //   page: CameraDemoPage(),
  // );
  // static const PageData task = PageData(
  //   index: 2,
  //   title: "Task",
  //   svgSrc: "assets/icons/menu_task.svg",
  //   name: "Task",
  //   routeLocation: "/task",
  //   page: DemoNewPage(),
  // );
  // static const PageData documents = PageData(
  //   index: 3,
  //   title: "Documents",
  //   svgSrc: "assets/icons/menu_doc.svg",
  //   name: "Documents",
  //   routeLocation: "/documents",
  //   page: TodosPage(),
  // );
  // static const PageData store = PageData(
  //   index: 4,
  //   title: "Store",
  //   svgSrc: "assets/icons/menu_store.svg",
  //   name: "Store",
  //   routeLocation: "/store",
  //   page: TodosFP(),
  // );
  // static const PageData notification = PageData(
  //   index: 5,
  //   title: "Notification",
  //   svgSrc: "assets/icons/menu_notification.svg",
  //   name: "Notification",
  //   routeLocation: "/notification",
  //   page: WidgetsDemoPage(),
  // );
  // static const PageData profile = PageData(
  //   index: 6,
  //   title: "Profile",
  //   svgSrc: "assets/icons/menu_profile.svg",
  //   name: "Profile",
  //   routeLocation: "/profile",
  //   page: SettingsPage(),
  // );
  // static const PageData settings = PageData(
  //   index: 6,
  //   title: "Settings",
  //   svgSrc: "assets/icons/menu_setting.svg",
  //   name: "Settings",
  //   routeLocation: "/settings",
  //   page: SettingsPage(),
  // );

  // make Pages iterable
  @override
  Iterator<PageData> get iterator => <PageData>[
        home,
        demo,
        // demoNew,
        // todos,
        // todosFp,
        // widgetsDemo,
        // profile,
        // settings,
      ].iterator;
}

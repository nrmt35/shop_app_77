import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/tabbed_navigator.dart';
import '../theme.dart';
import 'basket/basket_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';

enum TabItem {
  home,
  search,
  basket,
  profile;

  String get label {
    switch (this) {
      case TabItem.home:
        return 'Главная';
      case TabItem.search:
        return 'Поиск';
      case TabItem.basket:
        return 'Корзина';
      case TabItem.profile:
        return 'Аккаунт';
      default:
        throw ArgumentError();
    }
  }

  String get icon {
    switch (this) {
      case TabItem.home:
        return 'assets/icons/home.svg';
      case TabItem.search:
        return 'assets/icons/search-normal.svg';
      case TabItem.basket:
        return 'assets/icons/bag.svg';
      case TabItem.profile:
        return 'assets/icons/profile-circle.svg';
      default:
        throw ArgumentError();
    }
  }
}

final MaterialTabController tabController = MaterialTabController();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const TabItem mainTab = TabItem.home;

  final tabNavigatorKeys = List<GlobalKey<NavigatorState>>.generate(
    TabItem.values.length,
    (index) => GlobalKey(),
    growable: false,
  );

  void onTabSelected(TabItem newSelected) {
    final oldValue = TabItem.values[tabController.index];
    if (newSelected == oldValue) {
      final navigatorState = tabNavigatorKeys[newSelected.index].currentState;
      // pop to first route
      navigatorState?.popUntil((route) => route.isFirst);
    } else {
      tabController.index = newSelected.index;
    }
  }

  Future<bool> onWillPop() async {
    final tabIndex = tabController.index;
    final currentTab = TabItem.values[tabIndex];
    final navigatorState = tabNavigatorKeys[tabIndex].currentState;

    if (navigatorState == null) {
      // let system handle back button
      return true;
    }

    final isFirstRouteInCurrentTab = !(await navigatorState.maybePop());
    if (isFirstRouteInCurrentTab) {
      // if not on the 'main' tab
      if (currentTab != mainTab) {
        // select 'main' tab
        tabController.index = mainTab.index;
        // back button handled by app
        return false;
      }
    }
    // let system handle back button if we're on the first route
    return isFirstRouteInCurrentTab;
  }

  Widget buildTabWidget(BuildContext context, int index) {
    final tab = TabItem.values[index];
    final Widget child;
    switch (tab) {
      case TabItem.home:
        child = const HomeScreen();
        break;
      case TabItem.search:
        child = const SearchScreen();
        break;
      case TabItem.basket:
        child = const BasketScreen();
        break;
      case TabItem.profile:
        child = const ProfileScreen();
        break;
    }
    return MaterialTabView(
      navigatorKey: tabNavigatorKeys[index],
      builder: (context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          body: MaterialTabNavigator(
            tabCount: TabItem.values.length,
            controller: tabController,
            tabBuilder: buildTabWidget,
          ),
          bottomNavigationBar: AnimatedBuilder(
            animation: tabController,
            builder: (context, child) => BottomNavigation(
              currentTab: TabItem.values[tabController.index],
              onSelectTab: onTabSelected,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      currentIndex: TabItem.values.indexOf(currentTab),
      onTap: (index) => onSelectTab(TabItem.values[index]),
      items: TabItem.values
          .map(
            (e) => BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset(
                  e.icon,
                  color: AppColors.primary,
                  height: 24,
                  width: 24,
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset(
                  e.icon,
                  color: AppColors.secondary,
                  height: 24,
                  width: 24,
                ),
              ),
              label: e.label,
            ),
          )
          .toList(),
    );
  }
}

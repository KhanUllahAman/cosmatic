// ignore_for_file: library_private_types_in_public_api

import 'package:cosmatic/admin/video_list_screen.dart';
import 'package:cosmatic/guest/Home.dart';
import 'package:cosmatic/screens/account_screen/account_screen.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:enefty_icons/enefty_icons.dart';

class CustomBottomNavBarGuest extends StatefulWidget {
  const CustomBottomNavBarGuest({final Key? key}) : super(key: key);

  @override
  _CustomBottomNavBarGuestState createState() => _CustomBottomNavBarGuestState();
}

class _CustomBottomNavBarGuestState extends State<CustomBottomNavBarGuest> {


  final PersistentTabController _controller = PersistentTabController();

  ///screens
  List<Widget> _buildScreens() => [
        const GuestHomeScreen(),
        VideoListScreen()
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [

        PersistentBottomNavBarItem(
          icon: const Icon(EneftyIcons.home_3_bold),
          title: "Home",
          activeColorPrimary: AppColor.primaryColor,
          inactiveColorPrimary: AppColor.iconColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(EneftyIcons.video_add_bold),
          title: "View Reals",
          activeColorPrimary: AppColor.primaryColor,
          inactiveColorPrimary: AppColor.iconColor,
        ),
      ];


  @override
  Widget build(final BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,

        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: true,
          hideNavigationBarWhenKeyboardShows: true,
          confineInSafeArea: false,

          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 55,
          backgroundColor: AppColor.cardBgColor,
          hideNavigationBar: false,
          decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
          itemAnimationProperties: const ItemAnimationProperties(duration: Duration(milliseconds: 400),curve: Curves.ease),
          screenTransitionAnimation: const ScreenTransitionAnimation(animateTabTransition: true,),
          navBarStyle: NavBarStyle.style9,

        ),
      );
}

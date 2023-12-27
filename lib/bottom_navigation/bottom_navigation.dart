import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';

Widget bottomNavigation(ctx, index) {
  var iconList = [
    'assets/bn_home.svg',
    'assets/bn_explore.svg',
    'assets/bn_mic.svg',
    'assets/bn_notification.svg',
  ];
  return AnimatedBottomNavigationBar.builder(
    itemCount: iconList.length,
    tabBuilder: (index, active) {
      return Padding(
        padding: EdgeInsets.all(
          Dim().d16,
        ),
        child: SvgPicture.asset(
          iconList[index],
          color: active ? Clr().accentColor : Clr().white,
        ),
      );
    },
    backgroundColor: Clr().black,
    activeIndex: index,
    notchSmoothness: NotchSmoothness.softEdge,
    gapLocation: GapLocation.center,
    onTap: (i) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (i != 0) {
        var list = sp.getStringList('stack') ?? ['0'];
        if (list.contains('$i')) {
          list.removeWhere((e) => e == '$i');
          list.add('$i');
        } else {
          list.add('$i');
        }
        sp.setStringList('stack', list);
      }
      STM().switchCondition(ctx, i.toString());
    },
    // shadow: const BoxShadow(
    //   offset: Offset(0, 2),
    //   blurRadius: 12,
    //   spreadRadius: 0.5,
    //   color: Colors.white,
    // ),
  );
}

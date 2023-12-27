import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final iconList = <IconData>[
    Icons.brightness_5,
    Icons.brightness_4,
    Icons.brightness_6,
    Icons.brightness_7,
  ];
  var _bottomNavIndex = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Clr().black,
        extendBody: true,
        body: ListView(
          children: [
            SizedBox(height: 64),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 160,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.brightness_3,
          ),
          onPressed: () {
            // _fabAnimationController.reset();
            // _borderRadiusAnimationController.reset();
            // _borderRadiusAnimationController.forward();
            // _fabAnimationController.forward();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Colors.white : Colors.black;
            return Icon(
              iconList[index],
              size: 24,
              color: color,
            );
          },
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          // notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.softEdge,
          gapLocation: GapLocation.center,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          // hideAnimationController: _hideBottomBarAnimationController,
          shadow: BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 12,
            spreadRadius: 0.5,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
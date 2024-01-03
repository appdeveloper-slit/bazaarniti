import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_notification.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class Notifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationsPage();
  }
}

class NotificationsPage extends State<Notifications> {
  late BuildContext ctx;

  bool isLoaded = false;

  String? sID, sMessage;
  List<dynamic> resultList = [];

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData();
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "get-notification", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['notifications'];
      sMessage = result['message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        if (!mounted) return true;
        var list = sp.getStringList('stack');
        var i = list!.indexWhere((e) => e == '3');
        var position = list[i - 1];
        STM().switchCondition(ctx, position);
        list.removeAt(i);
        sp.setStringList('stack', list);
        return true;
      },
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: toolbarBottomNavigation(ctx, 3, 'Notifications'),
        body: Visibility(
          visible: isLoaded,
          child: bodyLayout(),
        ),
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            STM().redirect2page(ctx, AddTweet());
          },
          backgroundColor: Clr().accentColor,
          child: SvgPicture.asset(
            'assets/tweet.svg',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: bottomNavigation(ctx, 3,setState),
      ),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return resultList.isNotEmpty
        ? ListView.separated(
            itemCount: resultList.length,
            itemBuilder: (context, index) {
              return itemNotification(ctx, resultList[index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: Dim().d8,
              );
            },
          )
        : STM().emptyData(ctx,'$sMessage');
  }
}

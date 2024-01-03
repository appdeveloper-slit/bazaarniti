import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:bazaarniti/verifypin.dart';
import 'package:dio/dio.dart';
import 'package:bazaarniti/adapter/playbutton.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'adapter/item_home_header.dart';
import 'adapter/item_home_tweet.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
String? sID;
class Home extends StatefulWidget {
  final check;

  const Home({Key? key, this.check}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State<Home> {
  late BuildContext ctx;
  bool isLoaded = false,
      isActive = false,
      isMandatory = false,
      isNotification = false;

  String? sUUID, sMessage;
  Map<String, dynamic> user = {};
  List<dynamic> headerList = [];
  List<dynamic> resultList = [];
  List<String> stackList = ['0'];

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUUID = sp.getString("uuid");
      stackList = sp.getStringList("stack") ?? ['0'];
      sID = sp.getString("user_id");
      user = {
        'id': sID,
        'name': sp.getString("name"),
        'username': sp.getString("user_name"),
        'image': sp.getString("image"),
      };
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
      'uuid': sUUID,
      'user_id': sID,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "get-post", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      headerList = result['headers'];
      resultList = result['posts'];
      sMessage = result['message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Upgrader.clearSavedSettings();
    ctx = context;
    return stackList.length > 1
        ? WillPopScope(
            onWillPop: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              if (!mounted) return true;
              var list = sp.getStringList('stack');
              var i = list!.length - 1;
              var position = list[i];
              STM().switchCondition(ctx, position);
              sp.setStringList('stack', list);
              return true;
            },
            child: bodyLayout())
        : DoubleBack(
            message: 'Press back once again to exit!',
            child: bodyLayout(),
          );
  }

  //Body
  Widget bodyLayout() {
    return widget.check == true
        ? verifyPin()
        : Scaffold(
            backgroundColor: Clr().screenBackground,
            appBar: toolbarHome(ctx, user),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: bottomNavigation(ctx, 0,setState),
            body: UpgradeAlert(
              upgrader: Upgrader(
                showLater: !isMandatory,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: Visibility(
                visible: isLoaded,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    Dim().pp2,
                  ),
                  child: Column(
                    children: [
                      if (headerList.isNotEmpty)
                        Row(
                          children: [
                            SizedBox(
                              width: Dim().d8,
                            ),
                            Expanded(
                              child: itemHomeHeader(
                                ctx,
                                0,
                                headerList[0],
                              ),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Expanded(
                              child: itemHomeHeader(
                                ctx,
                                1,
                                headerList[1],
                              ),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Expanded(
                              child: itemHomeHeader(
                                ctx,
                                2,
                                headerList[2],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: Dim().d32,
                      ),
                      resultList.isNotEmpty
                          ? Padding(
                            padding: EdgeInsets.only(bottom: Dim().d12),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: resultList.length,
                                itemBuilder: (context, index) {
                                  return itemHomeTweet(ctx, resultList[index], sID, setState,index);
                                },
                                separatorBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const Divider(
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      SizedBox(
                                        height: Dim().d12,
                                      ),
                                    ],
                                  );
                                },
                              ),
                          )
                          : STM().emptyData(ctx, '$sMessage'),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

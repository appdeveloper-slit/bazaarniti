import 'dart:async';

import 'package:bazaarniti/bn_home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'message.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ConversationPage();
  }
}

class ConversationPage extends State<Conversation>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<Conversation> {
  late BuildContext ctx;

  String? sID, sMessage;
  List<dynamic> resultList = [];
  ScrollController scrollCtrl = ScrollController();
  bool isLoading = false;

  static StreamController<String> conversationStreamCtrl =
      StreamController<String>.broadcast();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getSessionData();
    conversationStreamCtrl.stream.listen((event) {
      getData(false);
    });
    scrollCtrl.addListener(() {
      if (scrollCtrl.position.maxScrollExtent == scrollCtrl.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
        }
      }
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    status('conversation-offline');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        status('conversation-online');
        break;
      case AppLifecycleState.detached:
        status('conversation-offline');
        break;
      default:
        break;
    }
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData(true);
        }
      });
    });
  }

  //Api Method
  getData(b) async {
    setState(() {
      isLoading = false;
    });
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    //Output
    var result = {};
    if (b) {
      result = await STM().post(ctx, Str().loading, "get-conversation", body);
    } else {
      result = await STM().postWithoutDialog(ctx,"get-conversation", body);
    }
    if (!mounted) return;
    setState(() {
      resultList = result['result'];
      sMessage = result['message'];
    });
  }

  //Api Method
  status(type) async {
    //Input
    FormData body = FormData.fromMap({
      'type': type,
      'user_id': sID,
    });
    //Output
    STM().postWithoutDialog(ctx,"status", body);
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          STM().redirect2page(ctx, const Home());
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: toolbarWithTitleLayout(ctx, 'Messages'),
        body: bodyLayout(),
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
        bottomNavigationBar: bottomNavigation(ctx, -1),
      ),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return resultList.isNotEmpty
        ? ListView.builder(
            controller: scrollCtrl,
            itemCount: resultList.length,
            itemBuilder: (context, index) {
              return itemConversation(ctx, resultList[index]);
            },
          )
        : STM().emptyData(ctx, '$sMessage');
  }

  //Item Layout
  Widget itemConversation(ctx, v) {
    return ListTile(
      onTap: () {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (context) => Message(v['user']),
          ),
        ).then((_) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              status('conversation-online');
            },
          );
        });
      },
      contentPadding: EdgeInsets.symmetric(
        vertical: Dim().d8,
        horizontal: Dim().pp,
      ),
      leading: STM().imageView(
        '${v['user']['image']}',
        width: Dim().d60,
        height: Dim().d60,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${v['user']['name']}',
            style: Sty().smallText,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Text(
            '${v['message']['message']}',
            style: Sty().smallText,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            STM().timeAgo(v['date']),
            style: Sty().microText,
          ),
          if (v['count'] > 0)
            Container(
              width: Dim().d24,
              height: Dim().d24,
              margin: EdgeInsets.only(
                top: Dim().d4,
              ),
              decoration: BoxDecoration(
                color: Clr().accentColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${v['count']}',
                  style: Sty().microText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

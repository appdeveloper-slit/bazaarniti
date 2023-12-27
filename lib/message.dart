import 'dart:async';
import 'dart:convert';

import 'package:bazaarniti/conversation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Message extends StatefulWidget {
  final Map<String, dynamic> data;

  const Message(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessagePage();
  }
}

class MessagePage extends State<Message> with WidgetsBindingObserver {
  late BuildContext ctx;
  bool isLoaded = false;

  String? sID, sToID;
  DateTime? time;
  bool fBlock = false, tBlock = false;

  Map<String, dynamic> v = {};

  List<dynamic> resultList = [];
  TextEditingController messageCtrl = TextEditingController();

  static StreamController<PusherEvent> chatCtrl =
      StreamController<PusherEvent>.broadcast();

  @override
  void initState() {
    super.initState();
    v = widget.data;
    sToID = v['id'].toString();
    getSessionData();
    chatCtrl.stream.listen((event) {
      if (event.data.isNotEmpty) {
        Map<String, dynamic> v = jsonDecode(event.data.toString());
        String id = '${v['response']['conversation_id']}';
        if (event.eventName == 'message_$id') {
          var fromID = v['response']['from_id'].toString();
          var toID = v['response']['to_id'].toString();
          if (sID == toID && sToID == fromID) {
            setState(() {
              var list = [];
              Map<String, dynamic> map = {
                "from_id": fromID,
                "to_id": toID,
                "message": v['response']['message'],
                "date": v['response']['created_at'],
              };
              list.add(map);
              list.addAll(resultList);
              resultList = list;
            });
          }
        } else if (event.eventName == 'offline_$sToID') {
          if (sToID == v['response']['user_id'].toString()) {
            setState(() {
              if (v['response']['last_seen'] != 'Online') {
                time = DateTime.parse(v['response']['last_seen']);
              } else {
                time = null;
              }
            });
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    status('message-offline');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        status('message-online');
        break;
      case AppLifecycleState.paused:
        status('message-offline');
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
          getData();
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': sToID,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "get-message", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['result'];
      if (result['last_seen'] != 'Online') {
        time = DateTime.parse(result['last_seen']);
      }
      fBlock = result['f_block'];
      tBlock = result['t_block'];
    });
  }

  //Api Method
  send(text) async {
    messageCtrl.clear();
    setState(() {
      var list = [];
      Map<String, dynamic> map = {
        "from_id": sID,
        "to_id": sToID,
        "message": text,
        "date": DateTime.now().toString(),
      };
      list.add(map);
      list.addAll(resultList);
      resultList = list;
    });
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': sToID,
      'message': text,
    });
    //Output
    STM().postWithoutDialog(ctx,"send-message", body).then((value) {
      ConversationPage.conversationStreamCtrl.sink.add("Updated");
    });
  }

  //Api Method
  delete(id, index) async {
    //Input
    FormData body = FormData.fromMap({
      'message_id': id,
    });
    setState(() {
      resultList.removeAt(index);
    });
    //Output
    STM().postWithoutDialog(ctx,"delete-message", body).then((value) {
      ConversationPage.conversationStreamCtrl.sink.add("Updated");
    });
  }

  //Api Method
  status(type) async {
    //Input
    FormData body = FormData.fromMap({
      'type': type,
      'to_id': sToID,
      'user_id': sID,
    });
    //Output
    STM().postWithoutDialog(ctx,"status", body);
  }

  //Api Method
  block() async {
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': sToID,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "block", body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, widget);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: !isLoaded
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Clr().white,
              ),
              titleSpacing: 0,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  STM().imageView(
                    '${v['image']}',
                    width: Dim().d32,
                    height: Dim().d32,
                  ),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${v['name']}',
                        style: Sty().mediumText,
                      ),
                      if (!tBlock)
                        Text(
                          time == null
                              ? 'Online'
                              : STM().dateFormat('dd/MM/yyyy hh:mm a', time),
                          style: Sty().microText.copyWith(
                                fontSize: 10.0,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                PopupMenuButton(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: Color(0x40000000),
                      shape: CircleBorder(),
                    ),
                    padding: EdgeInsets.all(
                      Dim().d4,
                    ),
                    child: SvgPicture.asset(
                      'assets/more.svg',
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "block",
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/block.svg',
                          ),
                          SizedBox(
                            width: Dim().d8,
                          ),
                          Text(
                            fBlock ? 'Unblock' : 'Block',
                            style: Sty().smallText.copyWith(
                                  color: Clr().black,
                                ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "report",
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/report.svg',
                          ),
                          SizedBox(
                            width: Dim().d8,
                          ),
                          Text(
                            'Report',
                            style: Sty().smallText.copyWith(
                                  color: Clr().black,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'block') {
                      block();
                    } else {
                      STM().successDialogWithAffinity(
                        ctx,
                        value == 'report'
                            ? "This profile has been reported. We'll review & do the needful. Thank you!"
                            : "We've received your request to block this profile. We'll block it for you within 24 hours & also review this profile from our end.",
                        const Conversation(),
                      );
                    }
                  },
                ),
                SizedBox(
                  width: Dim().d20,
                ),
              ],
            ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: Dim().d8,
              ),
              reverse: true,
              physics: const BouncingScrollPhysics(),
              itemCount: resultList.length,
              itemBuilder: (context, index) {
                return itemMessage(ctx, resultList[index], index);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: Dim().d12,
                );
              },
            ),
          ),
          if (fBlock)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Clr().primaryColor2,
              ),
              onPressed: () {
                block();
              },
              child: Text(
                'You blocked this contact Tap to unblock.',
                style: Sty().microText,
              ),
            ),
          if (isLoaded && !tBlock)
            Container(
              margin: EdgeInsets.fromLTRB(
                Dim().d16,
                Dim().d4,
                Dim().d16,
                Dim().d16,
              ),
              child: STM().commentField(
                messageCtrl,
                () {
                  if (messageCtrl.text.isNotEmpty) {
                    if (fBlock) {
                      showDialog(
                        context: ctx,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Clr().primaryColor2,
                            contentPadding: EdgeInsets.fromLTRB(
                              Dim().d20,
                              Dim().d12,
                              Dim().d20,
                              Dim().d0,
                            ),
                            content: Text(
                              'Unblock ${v['name']} to send a message.',
                              style: Sty().smallText,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  STM().back2Previous(ctx);
                                },
                                child: Text(
                                  'Cancel',
                                  style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  block();
                                },
                                child: Text(
                                  'Unblock',
                                  style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      send(messageCtrl.text.trim());
                    }
                  }
                },
                hint: 'Message...',
                isIcon: true,
              ),
            ),
        ],
      ),
    );
  }

//Item Layout
  Widget itemMessage(ctx, v, index) {
    if (v['from_id'].toString() != sID.toString()) {
      return Row(
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                Dim().d0,
                Dim().d0,
                Dim().d100,
                Dim().d0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2023),
                      border: Border.all(
                        color: Clr().primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dim().d8,
                      ),
                    ),
                    child: Text(
                      '${v['message']}',
                      style: Sty().smallText,
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      STM().dateFormat(
                        'dd MMM yy | hh:mm a',
                        DateTime.parse(v['date']),
                      ),
                      style: Sty().microText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                Dim().d100,
                Dim().d0,
                Dim().d0,
                Dim().d0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onLongPressEnd: (LongPressEndDetails details) {
                      showPopupMenu(v, index, details.globalPosition);
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        Dim().d12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6816A8),
                        borderRadius: BorderRadius.circular(
                          Dim().d8,
                        ),
                      ),
                      child: Text(
                        v['message'],
                        style: Sty().smallText.copyWith(
                              color: Clr().white,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      STM().dateFormat(
                        'dd MMM yy | hh:mm a',
                        DateTime.parse(v['date']),
                      ),
                      style: Sty().microText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  //Popup
  void showPopupMenu(v, index, offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          value: 'delete',
          child: Text(
            'Unsend',
            style: Sty().mediumText.copyWith(
                  color: Clr().errorRed,
                ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        delete(v['id'], index);
      }
    });
  }
}

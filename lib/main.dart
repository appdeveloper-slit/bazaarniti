import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'bn_notification.dart';
import 'conversation.dart';
import 'login.dart';
import 'message.dart';
import 'walkthrough.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool("is_login") ?? false;
  String sID = sp.getString("user_id") ?? "0";
  bool isWalkthrough = sp.getBool('is_walkthrough') ?? true;
  sp.setStringList('stack', ['0']);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //For Pusher
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  await pusher.init(
    apiKey: "4938fa737ad2ca9b23c1",
    cluster: "ap2",
    onEvent: (event) async {
      if (event.data.isNotEmpty) {
        Map<String, dynamic> v = jsonDecode(event.data.toString());
        if (event.eventName.contains('message_')) {
          String id = '${v['response']['conversation_id']}';
          if (event.eventName == 'message_$id') {
            MessagePage.chatCtrl.sink.add(event);
          }
        } else if (event.eventName.contains('offline_')) {
          String id = '${v['response']['user_id']}';
          if (event.eventName == 'offline_$id') {
            MessagePage.chatCtrl.sink.add(event);
          }
        } else if (event.eventName.contains('conversation_')) {
          String id = '${v['response']['id']}';
          if (sID == id) {
            ConversationPage.conversationStreamCtrl.sink.add("Updated");
          }
        }
      }
    },
  );
  await pusher.subscribe(channelName: 'bazaar-niti');
  await pusher.connect();

  //For OneSignal
  OneSignal.shared.setAppId("fa82ae2c-25d8-4b2d-ac3e-9949ddeb3c59");
  var status = await OneSignal.shared.getDeviceState();
  var sUUID = status!.userId.toString();
  sp.setString('uuid', sUUID);
  OneSignal.shared.setNotificationOpenedHandler((value) {
    var v = value.notification.additionalData;
    if (v != null) {
      String sType = v['type'];
      switch (sType) {
        case 'message':
          Map<String, dynamic> map = {
            'id': v['array']['id'],
            'username': v['array']['username'],
            'name': v['array']['name'],
            'image': v['array']['image'],
            'is_verified': v['array']['is_verified'],
          };
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => Message(map),
            ),
          );
          break;
        case 'notification':
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => Notifications(),
            ),
          );
          break;
      }
    }
  });

  await Future.delayed(const Duration(seconds: 2));

  runApp(
    MaterialApp(
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: isLogin
          ?  Home(check: true,)
          : isWalkthrough
              ? const Walkthrough()
              : const Login(),
    ),
  );
}

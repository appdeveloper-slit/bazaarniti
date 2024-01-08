import 'dart:io';
import 'package:bazaarniti/demat.dart';
import 'package:bazaarniti/manager/static_method.dart';
import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'bn_home.dart';

class WebViewPage extends StatefulWidget {
  final String? sUrl;

  const WebViewPage(this.sUrl, {Key? key}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            SharedPreferences StockTokens =
                await SharedPreferences.getInstance();
            setState(() {
              final uri = Uri.parse(url.toString());
              if (url.contains('auth_token')) {
                StockTokens.setString(
                    'auth_token', uri.queryParameters['auth_token'].toString());
                StockTokens.setString(
                    'feed_token', uri.queryParameters['feed_token'].toString());
                StockTokens.setString('refresh_token',
                    uri.queryParameters['refresh_token'].toString());
                print(
                    'onPageFinished : ${uri.queryParameters['auth_token'].toString()}');
                print(
                    'onPageFinished : ${uri.queryParameters['feed_token'].toString()}');
                print(
                    'onPageFinished : ${uri.queryParameters['refresh_token'].toString()}');
                // STM().back2Previous(ctx);
                genToken(uri.queryParameters['auth_token'].toString(),
                    uri.queryParameters['refresh_token'].toString());
              }
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.sUrl.toString()));
    super.initState();
  }

  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }

  void genToken(authToken, refreshToken) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'auth_token': authToken,
      'refresh_token': refreshToken,
      'user_id': sp.getString('user_id'),
    });
    var result =
        await STM().post(ctx, Str().processing, 'angel-one-token', body);
    if (result['response_data']['status'] == true) {
      STM().successDialogWithAffinity(
          ctx, 'Demat Account Log-In Successfully', Home());
    } else {
      STM().redirect2page(ctx, Demat());
      Fluttertoast.showToast(
          msg: result['message'],
          fontSize: Dim().d24,
          textColor: Clr().red,
          backgroundColor: Clr().white,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}

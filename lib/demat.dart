import 'package:bazaarniti/bn_home.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

import 'fingerprint.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demat_login.dart';
import 'demat_register.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';
import 'webview.dart';

class Demat extends StatefulWidget {
  const Demat({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DematPage();
  }
}

class DematPage extends State<Demat> {
  late BuildContext ctx;
  String? sName;

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sName = sp.getString("name") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          SizedBox(
            height: Dim().d60,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'hello $sName,',
              style: Sty().mediumText.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          SizedBox(
            height: Dim().d60,
          ),
          Text(
            'open a free Demat Account with',
            style: Sty().mediumText.copyWith(
                  fontSize: 20,
                ),
          ),
          SizedBox(
            height: Dim().d48,
          ),
          STM().imageView(
            'assets/txt_logo_white.png',
            width: Dim().d150,
          ),
          SizedBox(
            height: Dim().d32,
          ),
          ElevatedButton(
            onPressed: () async {
              // SharedPreferences StockTokens = await SharedPreferences.getInstance();
              // print(StockTokens.getString('auth_token'));
              // getProfile();
              STM().redirect2page(ctx, const DematRegister());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Clr().accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dim().d100,
                ),
              ),
            ),
            child: Text(
              'Open Free Account',
              style: Sty().microText,
            ),
          ),
          TextButton(
            onPressed: () {
              STM().redirect2page(ctx, const DematLogin());
            },
            child: Text(
              'I already have a Demat Account',
              style: Sty().mediumText.copyWith(
                    color: Clr().accentColor,
                  ),
            ),
          ),
          SizedBox(
            height: Dim().d150,
          ),
          STM().button(
            'skip',
            () {
              STM().finishAffinity(ctx, Home());
            },
            b: false,
          ),
        ],
      ),
    );
  }
}

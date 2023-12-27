import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FingerPrintPage();
  }
}

class FingerPrintPage extends State<FingerPrint> {
  late BuildContext ctx;
  String? sName;

  TextEditingController passwordCtrl = TextEditingController();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dim().d60,
        ),
        Padding(
          padding: EdgeInsets.all(
            Dim().pp,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              STM().imageView(
                'assets/txt_logo.png',
                width: Dim().d150,
              ),
              SizedBox(
                height: Dim().d32,
              ),
              Text(
                'Hello $sName,',
                style: Sty().extraLargeText,
              ),
              Text(
                'Use touch ID to login to\nyour Acoount',
                style: Sty().smallText.copyWith(
                      color: const Color(0xFF9A9A9A),
                    ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(
              Dim().pp,
            ),
            alignment: Alignment.center,
            child: STM().imageView(
              'assets/fingerprint.png',
            ),
          ),
        ),
        Container(
          color: const Color(0xFF1F1F1F),
          padding: EdgeInsets.fromLTRB(
            Dim().d16,
            Dim().d32,
            0,
            Dim().d32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Or just use password instrad.',
                style: Sty().smallText,
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Row(
                children: [
                  Expanded(
                    child: STM().passwordField(
                      passwordCtrl,
                      isOutline: true,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      STM().finishAffinity(ctx, const Home());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(
                        Dim().d4,
                      ),
                      backgroundColor: const Color(0xFFF4C430),
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.navigate_next_sharp,
                      color: Clr().white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

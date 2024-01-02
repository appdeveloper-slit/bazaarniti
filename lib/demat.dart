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
              getProfile();
              // STM().redirect2page(ctx, const DematRegister());
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
              // STM().redirect2page(ctx, const DematLogin());
              STM().redirect2page(
                  ctx,
                  const WebViewPage(
                      'https://smartapi.angelbroking.com/publisher-login?api_key=RklkUXTQ'));
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
              STM().finishAffinity(ctx, const FingerPrint());
            },
            b: false,
          ),
        ],
      ),
    );
  }

  void getProfile() async {
    SharedPreferences StockTokens = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'refreshToken': 'eyJhbGciOiJIUzUxMiJ9.eyJ0b2tlbiI6IlJFRlJFU0gtVE9LRU4iLCJSRUZSRVNILVRPS0VOIjoiZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnpkV0lpT2lKU1NFaEJNVE14T0NJc0ltVjRjQ0k2TVRjd05ESTNPRGd4Tnl3aWFXRjBJam94TnpBME1Ua3lNelUzTENKcWRHa2lPaUpsTUdNeE5UQXpaaTAwTWpnekxUUmxZV0l0T1RBelpTMHpOekpsTmpJeE9UUmtaR1FpTENKdmJXNWxiV0Z1WVdkbGNtbGtJam93TENKMGIydGxiaUk2SWxKRlJsSkZVMGd0VkU5TFJVNGlMQ0oxYzJWeVgzUjVjR1VpT2lKamJHbGxiblFpTENKMGIydGxibDkwZVhCbElqb2lkSEpoWkdWZmNtVm1jbVZ6YUY5MGIydGxiaUlzSW1SbGRtbGpaVjlwWkNJNkltRTNNbVl4T0RreUxXTTVOR1l0TTJZME55MWlOV001TFdZMk1HUmtNR0k0TnpNd055SjkuVWJudEFTN2FvRUU3UkhCazBJMnI5NkRITDg3aDJOam5HUHpfYXVVOER4RGd2M1dvLXZoQzRuY1ZWN2dYeERvc09xNHJaYVA3dTB1UUU2MzVHUndSdEEiLCJpYXQiOjE3MDQxOTI0MTd9.__aCkio2EjFbO8MmqgzAWK-39oYhpdyQaczADt3lVUYDpdfdUdL3F0mQMeK5-oghEQMGKzbUz58ujQauuw1W-w',
    });
    var result =
        await STM().getGenToken(ctx, body, 'eyJhbGciOiJIUzUxMiJ9.eyJ1c2VybmFtZSI6IlJISEExMzE4Iiwicm9sZXMiOjAsInVzZXJ0eXBlIjoiVVNFUiIsInRva2VuIjoiZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnpkV0lpT2lKU1NFaEJNVE14T0NJc0ltVjRjQ0k2TVRjd05ESTVNakkzT1N3aWFXRjBJam94TnpBME1Ua3lNelUzTENKcWRHa2lPaUprWm1aaU4yRTRaQzFqTkRreExUUTJaamd0T1ROaFppMHdOVFU1WVRReE9EQTNaVFVpTENKdmJXNWxiV0Z1WVdkbGNtbGtJam80TENKemIzVnlZMlZwWkNJNklqTWlMQ0oxYzJWeVgzUjVjR1VpT2lKamJHbGxiblFpTENKMGIydGxibDkwZVhCbElqb2lkSEpoWkdWZllXTmpaWE56WDNSdmEyVnVJaXdpWjIxZmFXUWlPamdzSW5OdmRYSmpaU0k2SWpNaUxDSmtaWFpwWTJWZmFXUWlPaUpoTnpKbU1UZzVNaTFqT1RSbUxUTm1ORGN0WWpWak9TMW1OakJrWkRCaU9EY3pNRGNpZlEubGdxU0lCVS05am1JOFcxWFNoV0JfZElVUVVhZllEeU9IY3JWaHE4eUZUR2dVcy1Jb1ZYM3VRdzdXVkh2cXo0UkJnRjFRemkzbFBJYjVCZnY3Y3lkbkEiLCJBUEktS0VZIjoiUmtsa1VYVFEiLCJpYXQiOjE3MDQxOTI0MTcsImV4cCI6MTcwNDI5MjI3OX0.z6VWhvcGI7moFt4ofctuic65sadW90pZmxGCSnspNuorl_R3Mb-b-qZ38TbrCGlH3nzS3pdq7QGUKK3YlsYdZA');
    print(result);
  }
}

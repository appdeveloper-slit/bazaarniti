import 'dart:async';
import 'package:bazaarniti/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class verifyPin extends StatefulWidget {
  const verifyPin({super.key});

  @override
  State<verifyPin> createState() => _verifyPinState();
}

class _verifyPinState extends State<verifyPin> {
  late BuildContext ctx;
  var sID;
  TextEditingController pinCtrl = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().screenBackground,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Dim().d32, vertical: Dim().d100),
        child: Column(
          children: [
            SizedBox(
              height: Dim().d20,
            ),
            Text('Kindly input your PIN to access the Bazaar Niti App',
                textAlign: TextAlign.center, style: Sty().largeText),
            SizedBox(
              height: Dim().d20,
            ),
            PinCodeTextField(
              key: const ObjectKey('otp-field'),
              controller: pinCtrl,
              errorAnimationController: errorController,
              appContext: ctx,
              enableActiveFill: true,
              textStyle: Sty().extraLargeText.copyWith(
                    color: Clr().black,
                  ),
              length: 4,
              obscureText: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d')),
              ],
              animationType: AnimationType.scale,
              cursorColor: Clr().accentColor,
              pinTheme: PinTheme(
                borderRadius: BorderRadius.circular(
                  Dim().d8,
                ),
                fieldOuterPadding: EdgeInsets.all(
                  Dim().d4,
                ),
                shape: PinCodeFieldShape.box,
                fieldWidth: Dim().d60,
                fieldHeight: Dim().d56,
                activeColor: Clr().accentColor,
                activeFillColor: Clr().white,
                inactiveFillColor: Clr().white,
                inactiveColor: Clr().white,
                errorBorderColor: Clr().errorRed,
                selectedFillColor: Clr().white,
                selectedColor: Clr().white,
              ),
              animationDuration: const Duration(milliseconds: 200),
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
                  return "";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: Dim().d20,
            ),
            ElevatedButton(
                onPressed: () {
                  pinVerifyApi();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Clr().background,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dim().d52)),
                        side: BorderSide(color: Clr().black, width: 1.0))),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Dim().d12),
                  child: Center(
                    child: Text('Submit',
                        style: Sty().mediumText.copyWith(color: Clr().black)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  /// pin verify api
  pinVerifyApi() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
      'pin': pinCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "verify-pin", body);
    if (result['success'] == true) {
      STM().finishAffinity(
          ctx,
          Home(
            check: false,
          ));
    } else {
     STM().errorDialog(ctx, result['message']);
    }
  }
}

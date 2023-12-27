import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'manager/static_method.dart';
import 'register.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'verification.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPage();
  }
}

class LoginPage extends State<Login> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();

  //Api method
  void sendOtp() async {
    //Input
    FormData body = FormData.fromMap({
      'type': 'login',
      'mobile': mobileCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "send-otp", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      STM().redirect2page(
        ctx,
        Verification(
          "login",
          mobileCtrl.text.toString(),
        ),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dim().d60,
            ),
            Text(
              'Welcome Back',
              style: Sty().extraLargeText,
            ),
            SizedBox(
              height: Dim().d40,
            ),
            STM().mobileField(
              mobileCtrl,
              action: TextInputAction.done,
            ),
            SizedBox(
              height: Dim().d48,
            ),
            STM().button(
              'continue',
              () {
                // STM().redirect2page(
                //   ctx,
                //   const Verification("login", "8888888881"),
                // );
                if (formKey.currentState!.validate()) {
                  STM().checkInternet(ctx, widget).then((value) {
                    if (value) {
                      sendOtp();
                    }
                  });
                }
              },
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Don’t have an account?',
                  style: Sty().mediumText,
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: TextButton(
                        onPressed: () {
                          STM().redirect2page(ctx, const Register());
                        },
                        child: Text(
                          'Sign Up',
                          style: Sty().mediumBoldText.copyWith(
                                color: Clr().accentColor,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

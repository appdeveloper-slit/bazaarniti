import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'verification.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterPage();
  }
}

class RegisterPage extends State<Register> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();

  bool isChecked = false;

  //Api method
  void sendOtp() async {
    //Input
    FormData body = FormData.fromMap({
      'type': 'register',
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
          "register",
          mobileCtrl.text.toString(),
          isChecked: isChecked,
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
            IconButton(
              onPressed: () {
                STM().back2Previous(ctx);
              },
              icon: SvgPicture.asset(
                'assets/back.svg',
                height: Dim().d28,
              ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dim().d16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'give us your\nmobile number',
                    style: Sty().extraLargeText,
                  ),
                  SizedBox(
                    height: Dim().d48,
                  ),
                  STM().mobileField(
                    mobileCtrl,
                    hint: 'Your Mobile Number',
                    action: TextInputAction.done,
                  ),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Clr().primaryColor,
                        activeColor: Clr().white,
                        side: BorderSide(
                          color: Clr().white,
                        ),
                        value: isChecked,
                        onChanged: (v) {
                          setState(() {
                            isChecked = v!;
                          });
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Text(
                              'enable whatsapp permission',
                              style: Sty().microText,
                            ),
                            SizedBox(
                              height: Dim().d4,
                            ),
                            Text(
                              'to receive our daily analysis\ndirectly to your whatsapp',
                              style: Sty().microText,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: Dim().d16,
                        ),
                        padding: EdgeInsets.all(
                          Dim().d8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: Dim().d2,
                            color: Clr().white,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dim().d100,
                          ),
                        ),
                        child: STM().imageView(
                          'assets/whatsapp.png',
                          width: Dim().d40,
                          height: Dim().d40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  STM().button(
                    'continue',
                    () {
                      // STM().redirect2page(
                      //   ctx,
                      //   Verification(
                      //     "register",
                      //     "8888888881",
                      //     isChecked: isChecked,
                      //   ),
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
                        text: 'Already have an account?',
                        style: Sty().mediumText,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: TextButton(
                              onPressed: () {
                                STM().finishAffinity(ctx, const Login());
                              },
                              child: Text(
                                'Login',
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
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:bazaarniti/pin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'manager/static_method.dart';
import 'register_detail.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Verification extends StatefulWidget {
  final String sType, sMobile;
  final bool isChecked;

  const Verification(this.sType, this.sMobile,
      {Key? key, this.isChecked = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VerificationPage();
  }
}

class VerificationPage extends State<Verification> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool isResend = false;
  int secondsRemaining = 60;

  // String sTime = '01:00';
  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
          // Duration duration = Duration(seconds: secondsRemaining);
          // sTime = [duration.inMinutes, duration.inSeconds]
          //     .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          //     .join(':');
        });
      } else {
        setState(() {
          isResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  //Api method
  resend() async {
    //Input
    FormData body = FormData.fromMap({
      'mobile': widget.sMobile,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resend-otp", body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      function() {
        otpCtrl.clear();
        setState(() {
          isResend = false;
          secondsRemaining = 60;
        });
      }

      STM().successWithButton(ctx, message, function).show();
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  //Api method
  verify() async {
    //Input
    FormData body = FormData.fromMap({
      'type': widget.sType,
      'mobile': widget.sMobile,
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().verifying, "verify-otp", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      switch (widget.sType) {
        case "login":
          sp.setString('user_id', '${result['user']['id']}');
          sp.setString('user_name', '${result['user']['username']}');
          sp.setString('name', '${result['user']['name']}');
          sp.setString('mobile', '${result['user']['mobile']}');
          sp.setString('email', '${result['user']['email']}');
          sp.setString('image', '${result['user']['image']}');
          sp.setBool('is_login', true);
          STM().finishAffinity(ctx, const Home(check: false,));
          STM().displayToast(message);
          break;
        case "register":
          STM().redirect2page(
            ctx,
            PinSave(
              widget.sMobile,
              widget.isChecked,
            ),
          );
          break;
      }
    } else {
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
                  'Please enter the OTP we sent you on\n\n+91 ${widget.sMobile}',
                  style: Sty().extraLargeText.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                PinCodeTextField(
                  key: const ObjectKey('otp-field'),
                  controller: otpCtrl,
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
                  height: Dim().d32,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: !isResend,
                    child: Text(
                        'I didn’t receive a code! ($secondsRemaining Sec)',
                        style: Sty().mediumText),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: isResend,
                    child: TextButton(
                      onPressed: () {
                        STM().checkInternet(context, widget).then((value) {
                          if (value) {
                            resend();
                          }
                        });
                      },
                      child: Text(
                        'Resend OTP',
                        style: Sty().mediumBoldText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                STM().button(
                  'continue',
                  () {
                    // if (widget.sType == "login") {
                    //   STM().finishAffinity(ctx, const Home());
                    //   STM().displayToast("Login successful");
                    // } else {
                    //   STM().finishAffinity(
                    //     ctx,
                    //     RegisterDetail(
                    //       widget.sMobile,
                    //       widget.isChecked,
                    //     ),
                    //   );
                    // }
                    if (otpCtrl.text.length > 3) {
                      STM().checkInternet(context, widget).then((value) {
                        if (value) {
                          verify();
                        }
                      });
                    } else {
                      STM().displayToast(Str().invalidOtp);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

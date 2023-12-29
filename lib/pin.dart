import 'dart:async';
import 'package:bazaarniti/manager/static_method.dart';
import 'package:bazaarniti/register_detail.dart';
import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinSave extends StatefulWidget {
  final String sMobile;
  final bool isChecked;

  const PinSave(this.sMobile, this.isChecked, {super.key});

  @override
  State<PinSave> createState() => _PinSaveState();
}

class _PinSaveState extends State<PinSave> {
  late BuildContext ctx;
  TextEditingController pinCtrl = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      // appBar: AppBar(
      //   leading: Icon(Icons.arrow_back, color: Clr().white),
      //   backgroundColor: Clr().transparent,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Dim().d100,
              ),
              Text(
                'Please create your PIN for setup',
                textAlign: TextAlign.center,
                style: Sty().mediumText.copyWith(
                    color: Clr().white,
                    fontSize: Dim().d32,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: Dim().d36,
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
                  borderRadius: BorderRadius.circular(Dim().d8),
                  fieldOuterPadding: EdgeInsets.all(Dim().d4),
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
              STM().button('Continue', () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                if (pinCtrl.text.isNotEmpty) {
                  STM().finishAffinity(
                    ctx,
                    RegisterDetail(
                      widget.sMobile,
                      widget.isChecked,
                      pinCtrl.text,
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

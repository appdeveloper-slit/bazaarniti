import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bazaarniti/bn_home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demat.dart';
import 'dialog/dialog_disclaimer.dart';
import 'manager/app_url.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class RegisterDetail extends StatefulWidget {
  final String sMobile;
  final bool isChecked;
  final pinnum;
  const RegisterDetail(this.sMobile, this.isChecked, this.pinnum,{Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterDetailPage();
  }
}

class RegisterDetailPage extends State<RegisterDetail> {
  late BuildContext ctx;
  bool isLoaded = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  File? file;
  String? sUserImg;
  bool isFileImage = false;

  bool isSheet = false;

  static StreamController<dynamic> controller =
      StreamController<dynamic>.broadcast();



  //Api method
  void register() async {
    //Input
    FormData body = FormData.fromMap({
      'is_checked': widget.isChecked,
      'pin': widget.pinnum,
      'mobile': widget.sMobile,
      'name': nameCtrl.text,
      'username': usernameCtrl.text,
      'email': emailCtrl.text,
      'image': sUserImg,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "register-user", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      sp.setString('user_id', '${result['user']['id']}');
      sp.setString('user_name', '${result['user']['username']}');
      sp.setString('name', '${result['user']['name']}');
      sp.setString('mobile', '${result['user']['mobile']}');
      sp.setString('email', '${result['user']['email']}');
      sp.setString('image', '${result['user']['image']}');
      // sp.setBool('is_login', true);
      STM().successDialogWithAffinity(ctx, message, const Demat());
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  //Profile image
  void singleImagePicker() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      var bytes = File(image.path).readAsBytesSync();
      setState(() {
        file = File(image.path);
        isFileImage = true;
        sUserImg = base64Encode(bytes).toString();
      });
    }
  }

  @override
  void initState() {
    controller.stream.listen((event) {
      setState(() {
        isSheet = true;
        register();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: null,
      backgroundColor: Clr().screenBackground,
      body: bodyLayout(),
    );
  }

  //Body3
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
              height: Dim().d40,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Join Us',
                style: Sty().extraLargeText.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            STM().circleProfile(
              file,
              isFileImage,
              singleImagePicker,
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Upload Profile Photo',
                style: Sty().mediumText.copyWith(
                      color: Clr().accentColor,
                    ),
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            STM().nameField(
              nameCtrl,
              hint: 'tell us your name',
            ),
            SizedBox(
              height: Dim().d12,
            ),
            STM().nameField(
              usernameCtrl,
              hint: 'give us a unique username',
              isUser: true,
            ),
            SizedBox(
              height: Dim().d12,
            ),
            STM().emailField(
              emailCtrl,
              hint: 'your email (optional)',
              action: TextInputAction.done,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'By continuing I agree to',
                  style: Sty().smallText,
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: TextButton(
                        onPressed: () {
                          STM().openWeb(AppUrl().termsUrl);
                        },
                        child: Text(
                          'Terms & Conditions',
                          style: Sty().smallText.copyWith(
                                color: Clr().accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            STM().button(
              'continue',
              () {
                if (formKey.currentState!.validate()) {
                  if (isSheet) {
                    register();
                  } else {
                    showModalBottomSheet(
                      context: ctx,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            Dim().d20,
                          ),
                        ),
                      ),
                      builder: (context) {
                        return dialogDisclaimer(context);
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

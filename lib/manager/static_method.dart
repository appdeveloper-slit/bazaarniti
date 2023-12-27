import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

import '../bn_explore.dart';
import '../bn_home.dart';
import '../bn_mic.dart';
import '../bn_notification.dart';
import '../login.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'app_url.dart';

class STM {
  void redirect2page(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void replacePage(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }

  void back2Previous(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      SystemNavigator.pop();
    }
  }

  void displayToast(String string) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  openWeb(String url) async {
    await launchUrl(Uri.parse(url.toString()),
        mode: LaunchMode.externalApplication);
  }

  void finishAffinity(final BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
  }

  void successDialog(context, message, widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: 'OK',
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  AwesomeDialog successWithButton(context, message, function) {
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        headerAnimationLoop: true,
        title: 'Success',
        desc: message,
        btnOkText: 'OK',
        btnOkOnPress: function,
        btnOkColor: Clr().successGreen);
  }

  void successDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: 'OK',
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void successDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: 'OK',
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void errorDialog(BuildContext context, String message) {
    AwesomeDialog(
            context: context,
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: 'OK',
            btnOkOnPress: () {
              message == 'The selected user id is invalid.' ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
                    (Route<dynamic> route) => false,
              ) : null;
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  void errorDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: 'OK',
            btnOkOnPress: () {
              message == 'The selected user id is invalid.' ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
                    (Route<dynamic> route) => false,
              ) : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  void errorDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: 'OK',
            btnOkOnPress: () {
              message == 'The selected user id is invalid.' ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
                    (Route<dynamic> route) => false,
              ) : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  AwesomeDialog loadingDialog(BuildContext context, String title) {
    AwesomeDialog dialog = AwesomeDialog(
      isDense: true,
      width: 200,
      context: context,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: WillPopScope(
        onWillPop: () async {
          displayToast('Something went wrong try again.');
          return true;
        },
        child: Container(
          height: Dim().d160,
          padding: EdgeInsets.all(Dim().d16),
          decoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.circular(Dim().d32),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: SpinKitDoubleBounce(
                  color: Clr().primaryColor,
                ),
              ),
              SizedBox(
                height: Dim().d16,
              ),
              Text(
                title,
                style: Sty().mediumBoldText.copyWith(
                      color: Clr().primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
    return dialog;
  }

  void alertDialog(context, message, widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialog dialog = AlertDialog(
          title: Text(
            "Confirmation",
            style: Sty().largeText,
          ),
          content: Text(
            message,
            style: Sty().smallText,
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {},
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        return dialog;
      },
    );
  }

  AwesomeDialog modalDialog(context, widget, color) {
    AwesomeDialog dialog = AwesomeDialog(
      isDense: true,
      dialogBackgroundColor: color,
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: widget,
    );
    return dialog;
  }

  void mapDialog(BuildContext context, Widget widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      padding: EdgeInsets.zero,
      animType: AnimType.scale,
      body: widget,
      btnOkText: 'Done',
      btnOkColor: Clr().successGreen,
      btnOkOnPress: () {},
    ).show();
  }

  Widget setSVG(name, size) {
    return SvgPicture.asset(
      'assets/$name.svg',
      height: size,
      width: size,
    );
  }

  Widget emptyData(ctx, message) {
    return SizedBox(
      width: MediaQuery.of(ctx).size.width,
      height: MediaQuery.of(ctx).size.height / 1.4,
      child: Center(
        child: Text(
          message,
          style: Sty().smallText.copyWith(
                color: Clr().white,
                fontSize: 18.0,
              ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> getBottomList(index) {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/bn_explore.svg",
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/bn_tv.svg",
        ),
        label: 'Live T.V.',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/bn_short.svg",
        ),
        label: 'Shorts',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/bn_event.svg",
        ),
        label: 'Events',
      ),
    ];
  }

  //Dialer
  Future<void> openDialer(String phoneNumber) async {
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(Uri.parse(launchUri.toString()));
  }

  //WhatsApp
  Future<void> openWhatsApp(String phoneNumber) async {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse("whatsapp:wa.me/$phoneNumber"));
    } else {
      await launchUrl(Uri.parse("whatsapp:send?phone=$phoneNumber"));
    }
  }

  Future<bool> checkInternet(context, widget) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      internetAlert(context, widget);
      return false;
    }
  }

  internetAlert(context, widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Padding(
        padding: EdgeInsets.all(Dim().d20),
        child: Column(
          children: [
            // SizedBox(child: Lottie.asset('assets/no_internet_alert.json')),
            Text(
              'Connection Error',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontSize: 18.0,
                  ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'No Internet connection found.',
              style: Sty().smallText,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    Navigator.pop(context);
                    STM().replacePage(context, widget);
                  }
                },
                child: Text(
                  "Try Again",
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  String dateFormat(format, date) {
    return DateFormat(format).format(date).toString();
  }

  Future<dynamic> get(ctx, title, name) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl().mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      dialog.dismiss();

      e.message == 'Http status error [403]'
          ? STM().finishAffinity(ctx, const Login())
          : STM().errorDialog(ctx, e.message.toString());
    }
    return result;
  }

  Future<dynamic> getWithoutDialog(ctx, name) async {
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl().mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      e.message == 'Http status error [403]'
          ? STM().finishAffinity(ctx, const Login())
          : STM().errorDialog(ctx, e.message.toString());
    }
    return result;
  }

  Future<dynamic> post(ctx, title, name, body) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    String url = AppUrl().mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        // result = json.decode(response.data.toString());
        result = response.data;
      }
    } on DioError catch (e) {
      dialog.dismiss();
      e.message == 'Http status error [403]'
          ? STM().finishAffinity(ctx, const Login())
          : STM().errorDialog(ctx, e.message.toString());
    }
    return result;
  }

  Future<dynamic> postWithoutDialog(ctx, name, body) async {
    //Dialog
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl().mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Url = $url\nBody = ${body.fields}\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      e.message == 'Http status error [403]'
          ? STM().finishAffinity(ctx, const Login())
          : STM().errorDialog(ctx, e.message.toString());
    }
    return result;
  }

  Widget loadingPlaceHolder() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 0.6,
        color: Clr().white,
      ),
    );
  }

  String nameShort(name) {
    return name.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase();
  }

  Widget primaryButton(Map<String, dynamic> v, Function function) {
    return SizedBox(
      width: v.containsKey('width') ? v['width'] : double.infinity,
      child: ElevatedButton(
        style: Sty().primaryButton,
        onPressed: () {
          function;
        },
        child: Text(
          '${v['title']}',
          style: Sty().largeText.copyWith(
                color: Clr().white,
              ),
        ),
      ),
    );
  }

  AwesomeDialog modalDialogWithZeroPadding(ctx, widget) {
    AwesomeDialog dialog = AwesomeDialog(
      context: ctx,
      borderSide: BorderSide.none,
      dialogBorderRadius: BorderRadius.all(
        Radius.circular(Dim().d16),
      ),
      dialogType: DialogType.noHeader,
      padding: EdgeInsets.zero,
      animType: AnimType.scale,
      body: widget,
    );
    return dialog;
  }

  Widget roundImage(url, {width, height}) {
    return url.toString().contains('assets')
        ? ClipRRect(
            borderRadius: BorderRadius.circular(
              Dim().d100,
            ),
            child: Image.asset(
              '$url',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(
              Dim().d100,
            ),
            child: CachedNetworkImage(
              width: width,
              height: height,
              fit: BoxFit.cover,
              imageUrl: url ??
                  'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
              placeholder: (context, url) => STM().loadingPlaceHolder(),
            ),
          );
  }

  Widget imageView(url, {width, height, fit = BoxFit.fill}) {
    return url.toString().contains('assets')
        ? Image.asset(
            '$url',
            width: width,
            height: height,
            fit: fit,
          )
        : CachedNetworkImage(
            width: width,
            height: height,
            fit: fit,
            imageUrl: url ??
                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
            placeholder: (context, url) => STM().loadingPlaceHolder(),
          );
  }

  Widget button(title, function,
      {b = true,
      color = const Color(0xFF636A70),
      width = double.infinity,
      height,
      style = 'large'}) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: height != null
                ? style != 'large'
                    ? Dim().d0
                    : Dim().d8
                : Dim().d12,
          ),
        ),
        onPressed: function,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '$title',
              style: style == 'large'
                  ? Sty().largeText.copyWith(
                        color: Clr().white,
                      )
                  : Sty().smallText.copyWith(
                        color: Clr().white,
                      ),
            ),
            if (b)
              SizedBox(
                width: Dim().d12,
              ),
            if (b) SvgPicture.asset('assets/next.svg')
          ],
        ),
      ),
    );
  }

  Widget mobileField(
    ctrl, {
    action = TextInputAction.next,
    hint = "Enter Mobile Number",
  }) {
    return TextFormField(
      cursorColor: Clr().white,
      controller: ctrl,
      style: Sty().mediumText,
      maxLength: 10,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'\d')),
      ],
      textInputAction: action,
      decoration: Sty().textFieldUnderlineStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: hint,
            counterText: '',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(
                14,
              ),
              child: SvgPicture.asset(
                'assets/call.svg',
              ),
            ),
          ),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'([5-9]\d{9})').hasMatch(value)) {
          return Str().invalidMobile;
        } else {
          return null;
        }
      },
    );
  }

  Widget emailField(
    ctrl, {
    action = TextInputAction.next,
    hint = "Enter Email Address",
  }) {
    return TextFormField(
      controller: ctrl,
      cursorColor: Clr().white,
      style: Sty().mediumText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: action,
      decoration: Sty().textFieldUnderlineStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(
                14,
              ),
              child: SvgPicture.asset(
                'assets/email.svg',
              ),
            ),
          ),
      validator: (value) {
        if (value!.isNotEmpty && !isEmail(value)) {
          return Str().invalidEmail;
        }
        return null;
      },
    );
  }

  Widget passwordField(
    ctrl, {
    action = TextInputAction.next,
    hint = "Enter Password",
    isOutline = false,
  }) {
    bool isHidden = true;
    return StatefulBuilder(builder: (context, setState) {
      return TextFormField(
        controller: ctrl,
        cursorColor: Clr().white,
        style: Sty().mediumText,
        keyboardType: TextInputType.visiblePassword,
        obscureText: isHidden,
        textInputAction: action,
        decoration: isOutline
            ? Sty().textFieldOutlineStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().hintColor,
                      ),
                  hintText: hint,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: InkWell(
                      child: Icon(
                        isHidden
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          isHidden ^= true;
                        });
                      },
                    ),
                  ),
                )
            : Sty().textFieldUnderlineStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().hintColor,
                      ),
                  hintText: hint,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: InkWell(
                      child: Icon(
                        isHidden
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          isHidden ^= true;
                        });
                      },
                    ),
                  ),
                ),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'(.{6,})').hasMatch(value)) {
            return Str().invalidPassword;
          } else {
            return null;
          }
        },
      );
    });
  }

  Widget nameField(
    ctrl, {
    isUser = false,
    action = TextInputAction.next,
    hint = "Enter Your Name",
    iconColor = Colors.white,
  }) {
    return TextFormField(
      controller: ctrl,
      cursorColor: Clr().white,
      style: Sty().mediumText,
      keyboardType: TextInputType.name,
      textInputAction: action,
      decoration: Sty().textFieldUnderlineStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(
                14,
              ),
              child: SvgPicture.asset(
                'assets/user.svg',
                color: iconColor,
              ),
            ),
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return isUser ? Str().invalidUsername : Str().invalidName;
        } else {
          return null;
        }
      },
    );
  }

  Widget bioField(
    ctrl, {
    action = TextInputAction.next,
    hint = "Bio",
  }) {
    return TextFormField(
      controller: ctrl,
      cursorColor: Clr().white,
      style: Sty().mediumText,
      keyboardType: TextInputType.text,
      textInputAction: action,
      decoration: Sty().textFieldUnderlineStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(
                14,
              ),
            ),
          ),
    );
  }

  Widget commentField(
    ctrl,
    function, {
    action = TextInputAction.done,
    hint = "Write a Comment",
    isIcon = false,
  }) {
    return TextFormField(
      controller: ctrl,
      cursorColor: Clr().white,
      style: Sty().mediumText,
      keyboardType: TextInputType.text,
      textInputAction: action,
      decoration: Sty().textFieldWithoutStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFF1F1F1F),
            suffixIcon: isIcon
                ? IconButton(
                    onPressed: function,
                    splashRadius: Dim().d24,
                    icon: Icon(
                      Icons.send_sharp,
                      color: Clr().accentColor,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(
                      Dim().d0,
                      Dim().d4,
                      Dim().d12,
                      Dim().d4,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Clr().accentColor,
                      ),
                      onPressed: function,
                      child: Text(
                        'Submit',
                        style: Sty().smallText,
                      ),
                    ),
                  ),
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return Str().invalidEmpty;
        } else {
          return null;
        }
      },
    );
  }

  Widget searchField(ctrl, function, {hint = 'Stocks, people, Podcast, etc'}) {
    return TextFormField(
      controller: ctrl,
      cursorColor: Clr().white,
      style: Sty().mediumText,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: Sty().textFieldWhiteOutlineStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: hint,
            prefixIcon: Icon(
              Icons.search,
              color: Clr().white,
            ),
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return Str().invalidEmpty;
        } else {
          return null;
        }
      },
      onFieldSubmitted: function,
    );
  }

  Widget tweetField(ctrl) {
    return TextFormField(
      controller: ctrl,
      cursorColor: Clr().white,
      style: Sty().mediumText,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      textInputAction: TextInputAction.done,
      decoration: Sty().textFieldWithoutStyle.copyWith(
            hintStyle: Sty().mediumText.copyWith(
                  color: Clr().hintColor,
                ),
            hintText: 'What’s Up?',
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return Str().invalidEmpty;
        } else {
          return null;
        }
      },
    );
  }

  Widget circleProfile(file, isFile, function) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              function();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                Dim().d100,
              ),
              child: isFile
                  ? Image.file(
                      file!,
                      width: Dim().d150,
                      height: Dim().d150,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/dummy_profile.png",
                      width: Dim().d150,
                      height: Dim().d150,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            bottom: Dim().d4,
            right: Dim().d4,
            child: Container(
              width: Dim().d40,
              height: Dim().d40,
              decoration: BoxDecoration(
                color: Clr().accentColor,
                borderRadius: BorderRadius.circular(
                  Dim().d100,
                ),
              ),
              child: Icon(
                Icons.add,
                color: Clr().white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar(ctrl, list, function, {isScrollable = true}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(
            0xFF292929,
          ),
          borderRadius: BorderRadius.circular(
            Dim().d12,
          ),
        ),
        padding: EdgeInsets.all(
          Dim().d8,
        ),
        child: TabBar(
          onTap: function,
          controller: ctrl,
          isScrollable: isScrollable,
          labelColor: Clr().white,
          labelStyle: Sty().largeText,
          unselectedLabelColor: Clr().white,
          indicator: BoxDecoration(
            color: Clr().accentColor,
            borderRadius: BorderRadius.circular(
              Dim().d100,
            ),
          ),
          tabs: list,
        ),
      ),
    );
  }

  void switchCondition(ctx, position) {
    switch (position) {
      case '0':
        STM().replacePage(ctx, const Home());
        break;
      case '1':
        STM().replacePage(ctx, Explore());
        break;
      case '2':
        STM().replacePage(ctx, Mic());
        break;
      case '3':
        STM().replacePage(ctx, Notifications());
        break;
      case '100':
        STM().back2Previous(ctx);
        break;
    }
  }

  String timeAgo(date) {
    return Jiffy.parse(date).fromNow();
  }

  RichText buildColoredText(sentence, ctx, type) {
    RegExp hashTagRegExp = RegExp(r'#\w+');
    RegExp addTagRegExp = RegExp(r'@\w+');
    return sentence.toString().contains('#')
        ? funt(sentence, hashTagRegExp, ctx, type)
        : funt(sentence, addTagRegExp, ctx, type);
  }

  funt(sentence, regExp, ctx, type) {
    List<WidgetSpan> spans = [];
    List<String> words = sentence.split(' ');

    for (String word in words) {
      if (regExp.hasMatch(word)) {
        spans.add(WidgetSpan(
          child: InkWell(
            onTap: () {
              if (word.contains('#')) STM().displayToast('#Selected');
            },
            child: Text(word + ' ',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: type == 'comment' ? Dim().d12 : Dim().d16,
                )),
          ),
        ));
      } else {
        spans.add(
          WidgetSpan(
              child: Text(word + ' ',
                  style: Sty().mediumText.copyWith(
                      color: Color(0xFF626262),
                      fontSize: type == 'comment' ? Dim().d12 : Dim().d14))),
        );
      }
    }

    return RichText(
      maxLines: type == 'detail' ? null : 3,
      text: TextSpan(
        children: spans,
      ),
    );
  }
}

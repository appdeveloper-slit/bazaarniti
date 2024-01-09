import 'dart:convert';
import 'dart:io';
import 'package:bazaarniti/bn_home.dart';
import 'package:bazaarniti/login.dart';
import 'package:bazaarniti/toolbar/toolbar.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/strings.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'public_profile.dart';
import 'texformfiledLayout/comTextFiled.dart';
import 'values/colors.dart';

class profileEdit extends StatefulWidget {
  final detail, data;

  const profileEdit({super.key, this.detail, this.data});

  @override
  State<profileEdit> createState() => _profileEditState();
}

class _profileEditState extends State<profileEdit> {
  late BuildContext ctx;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
    });
  }

  var profile, sID;
  XFile? image;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController bioCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController urlCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    setState(() {
      nameCtrl = TextEditingController(text: widget.data['name']);
      bioCtrl = TextEditingController(text: widget.detail['user']['bio']);
      cityCtrl = TextEditingController(text: widget.detail['user']['location']);
      mobileCtrl = TextEditingController(text: widget.detail['user']['mobile']);
      urlCtrl =
          TextEditingController(text: widget.detail['user']['twitter_url']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().replacePage(ctx, PublicProfile(widget.data));
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: commonAppBar(widget.data['name'], ctx, widget.data),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            STM().redirect2page(ctx, AddTweet());
          },
          backgroundColor: Clr().accentColor,
          child: SvgPicture.asset(
            'assets/tweet.svg',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: bottomNavigation(ctx, 0, setState),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dim().d20,
                ),
                editContainer(),
                SizedBox(height: Dim().d20),
                comTextFiled(
                    controller: nameCtrl,
                    maxlines: null,
                    readonly: false,
                    keyboardType: TextInputType.text,
                    textinputaction: TextInputAction.done,
                    icon: Icon(Icons.person, color: Clr().yellow),
                    hintext: 'Full Name'),
                SizedBox(height: Dim().d20),
                comTextFiled(
                    controller: bioCtrl,
                    maxlength: 200,
                    readonly: false,
                    keyboardType: TextInputType.text,
                    textinputaction: TextInputAction.done,
                    hintext: 'Bio'),
                SizedBox(height: Dim().d20),
                comTextFiled(
                    maxlength: 10,
                    controller: mobileCtrl,
                    readonly: false,
                    icon: Icon(
                      Icons.call,
                      color: Clr().yellow,
                      size: Dim().d20,
                    ),
                    keyboardType: TextInputType.number,
                    suffix:
                        Icon(Icons.edit, color: Clr().yellow, size: Dim().d16),
                    textinputaction: TextInputAction.done,
                    hintext: 'Mobile Number'),
                comTextFiled(
                    controller: cityCtrl,
                    readonly: false,
                    keyboardType: TextInputType.text,
                    textinputaction: TextInputAction.done,
                    icon: Icon(
                      Icons.location_on_sharp,
                      color: Clr().yellow,
                      size: Dim().d20,
                    ),
                    hintext: 'City Name'),
                SizedBox(height: Dim().d20),
                comTextFiled(
                    controller: urlCtrl,
                    maxlines: null,
                    readonly: false,
                    keyboardType: TextInputType.text,
                    textinputaction: TextInputAction.done,
                    icon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset('assets/twitter.svg',
                          color: Clr().yellow),
                    ),
                    hintext: 'Twitter Url'),
                SizedBox(
                  height: Dim().d20,
                ),
                commPort(),
                SizedBox(
                  height: Dim().d16,
                ),
                commonButton('Save'),
                SizedBox(
                  height: Dim().d20,
                ),
                commInfo(),
                SizedBox(
                  height: Dim().d20,
                ),
                commonButton('Logout'),
                SizedBox(
                  height: Dim().d20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// profile Container
  editContainer() {
    return Center(
      child: Stack(
        children: [
          DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Clr().yellow, width: 3.0)),
              child: image != null
                  ? ClipOval(
                      child: Image.file(
                        File(image!.path.toString()),
                        width: Dim().d180,
                        height: Dim().d180,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        color: Clr().transparent.withOpacity(0.2),
                        colorBlendMode: BlendMode.dstATop,
                      ),
                    )
                  : widget.detail != null
                      ? ClipOval(
                          child: Image.network(
                            widget.data['image'].toString(),
                            width: Dim().d180,
                            height: Dim().d180,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            color: Clr().transparent.withOpacity(0.2),
                            colorBlendMode: BlendMode.dstATop,
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                            'https://i.stack.imgur.com/l60Hf.png',
                            fit: BoxFit.cover,
                            width: Dim().d180,
                            height: Dim().d180,
                            filterQuality: FilterQuality.high,
                            color: Clr().transparent.withOpacity(0.2),
                            colorBlendMode: BlendMode.dstATop,
                          ),
                        )),
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            top: 20,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Clr().grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dim().d14),
                            topRight: Radius.circular(Dim().d14))),
                    builder: (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dim().d12, vertical: Dim().d20),
                            child: Text('Profile Photo',
                                style: Sty().mediumBoldText),
                          ),
                          SizedBox(height: Dim().d28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  _getImage(ImageSource.camera);
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Clr().white,
                                  size: Dim().d32,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    _getImage(ImageSource.gallery);
                                  },
                                  child: Icon(
                                    Icons.yard_outlined,
                                    size: Dim().d32,
                                    color: Clr().white,
                                  )),
                            ],
                          ),
                          SizedBox(height: Dim().d40),
                        ],
                      );
                    });
              },
              child: Center(
                child: Icon(Icons.camera_alt_outlined,
                    color: Clr().white, size: Dim().d36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// portfolio container
  commPort() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Privacy Status',
            style: Sty().mediumText.copyWith(
                color: Clr().white,
                fontSize: Dim().d14,
                fontWeight: FontWeight.w500)),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  widget.detail['user']['is_private'] = false;
                  privacyApi();
                });
              },
              child: Container(
                height: Dim().d32,
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                decoration: BoxDecoration(
                  border: Border.all(color: Clr().white),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dim().d20),
                      bottomLeft: Radius.circular(Dim().d20)),
                  color: widget.detail['user']['is_private'] == false
                      ? Clr().successGreen
                      : Clr().transparent,
                ),
                child: Center(child: Text('Public', style: Sty().smallText)),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  widget.detail['user']['is_private'] = true;
                  privacyApi();
                });
              },
              child: Container(
                height: Dim().d32,
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                decoration: BoxDecoration(
                    border: Border.all(color: Clr().white),
                    color: widget.detail['user']['is_private'] == true
                        ? Clr().red
                        : Clr().transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dim().d20),
                        bottomRight: Radius.circular(Dim().d20))),
                child: Center(child: Text('Private', style: Sty().smallText)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// change privacy status
  void privacyApi() async {
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'change-privacy-status', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// Others Information
  commInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Others Information :-',
            style: Sty().mediumText.copyWith(
                color: Clr().white,
                fontSize: Dim().d14,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: Dim().d8,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.0,
          children: [
            SvgPicture.asset('assets/privacy.svg'),
            Text('Privacy Policy',
                style: Sty().mediumText.copyWith(
                    color: Clr().white,
                    fontSize: Dim().d14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.0,
          children: [
            SvgPicture.asset('assets/terms.svg'),
            Text('Terms & Conditions',
                style: Sty().mediumText.copyWith(
                    color: Clr().white,
                    fontSize: Dim().d14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  /// common button
  commonButton(type) {
    return ElevatedButton(
        onPressed: () async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          if (type == 'Logout') {
            setState(() {
              sp.clear();
              STM().finishAffinity(ctx, Login());
            });
          }
          if (type == 'Save') {
            updateProfile();
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Clr().yellow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(Dim().d8)))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dim().d12),
          child: Center(
            child: Text(type,
                style: Sty().mediumText.copyWith(color: Clr().white)),
          ),
        ));
  }

  /// getImage from gallary, camera
  _getImage(source) async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: source);
    if (image != null) {
      var f = await image!.readAsBytes();
      setState(() {
        profile = base64Encode(f);
        STM().back2Previous(ctx);
        print(profile);
      });
    }
  }

  /// update profile
  void updateProfile() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
      'name': nameCtrl.text,
      'bio': bioCtrl.text,
      'location': cityCtrl.text,
      'url': urlCtrl.text,
      'image': profile,
    });
    //Output
    var result = await STM().post(ctx, Str().updating, "update-profile", body);
    var success = result['success'];
    if (success) {
      STM().successDialogWithAffinity(ctx, result['message'], Home());
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
}

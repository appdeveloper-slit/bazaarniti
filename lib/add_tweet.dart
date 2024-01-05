import 'dart:convert';
import 'dart:io';
import 'package:bazaarniti/bn_home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class AddTweet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddTweetPage();
  }
}

class AddTweetPage extends State<AddTweet> {
  late BuildContext ctx;

  String? sID, sImage;
  TextEditingController tweetCtrl = TextEditingController();
  List<String> imageList = [];

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
      sImage = sp.getString("image");
    });
  }

  //Api method
  void post() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
      'message': tweetCtrl.text.trim(),
      'images': jsonEncode(imageList),
    });
    //Output
    var result = await STM().post(ctx, Str().processing, "add-post", body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(ctx, message, const Home());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  List fileList = [];

  //Profile image
  void multipleImagePicker() async {
    var list = await ImagePicker().pickMultiImage();
    if (list.isNotEmpty) {
      for (int a = 0; a < list.length; a++) {
        setState(() {
          fileList.add(list[a].path.toString());
        });
      }
      for (int b = 0; b < fileList.length; b++) {
        var image = File(fileList[b]).readAsBytesSync();
        imageList.add(base64Encode(image));
      }
      print(fileList);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarWithTitleLayout(ctx, 'Add Post'),
      body: bodyLayout(),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dim().d12,
        horizontal: Dim().d24,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                STM().back2Previous(ctx);
              },
              icon: Icon(
                Icons.close,
                color: Clr().white,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: Dim().d4,
                ),
                child: STM().roundImage(
                  sImage,
                  width: Dim().d40,
                  height: Dim().d40,
                ),
              ),
              Expanded(
                child: STM().tweetField(
                  tweetCtrl,
                ),
              ),
            ],
          ),
          if (fileList.isNotEmpty)
            Expanded(
              child: GridView.builder(
                itemCount: fileList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 120.0,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: Dim().d120,
                        width: Dim().d180,
                        decoration: BoxDecoration(
                            border: Border.all(color: Clr().white, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dim().d12))),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dim().d12)),
                            child: Image.file(File(fileList[index]),
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              fileList.removeAt(index);
                              imageList.removeAt(index);
                            });
                          },
                          child: Icon(
                            Icons.delete_forever_sharp,
                            color: Clr().red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  multipleImagePicker();
                },
                child: SvgPicture.asset(
                  'assets/add_image.svg',
                ),
              ),
              STM().button(
                'Publish',
                () {
                 if(tweetCtrl.text.length > 30){
                   post();
                 }else{
                   STM().displayToast('Please write tweet at-least 30 Characters');
                 }
                },
                width: Dim().d100,
                height: Dim().d40,
                color: Clr().accentColor,
                b: false,
              ),
            ],
          )
        ],
      ),
    );
  }
}

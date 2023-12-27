import 'dart:io';
import 'package:bazaarniti/manager/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pusher_channels_flutter/pusher-js/core/transports/url_schemes.dart';
import 'adapter/item_episode.dart';
import 'add_tweet.dart';
import 'bn_home.dart';
import 'manager/static_method.dart';
import 'public_profile.dart';
import 'toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class EpisodeList extends StatefulWidget {
  final Map<String, dynamic> data;
  final details;

  EpisodeList(this.data, {Key? key, this.details}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EpisodeListPage();
  }
}

class EpisodeListPage extends State<EpisodeList> {
  late BuildContext ctx;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Map<String, dynamic> v = {};
  TextEditingController epNameCtrl = TextEditingController();
  var _selectIndex;
  String? AudioFile;

  Future<void> pickAudio() async {

  }

  @override
  void initState() {
    v = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarWithTitleLayout(ctx, '${v['name']}'),
      body: Padding(
        padding: EdgeInsets.all(
          Dim().pp,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dim().d32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${v['name']}',
                    style: Sty().largeText.copyWith(
                          color: Clr().accentColor,
                        ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Play All',
                        style: Sty().smallText,
                      ),
                      SizedBox(
                        width: Dim().d8,
                      ),
                      SvgPicture.asset(
                        'assets/play.svg',
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Text(
                '${v['description']}',
                style: Sty().microText.copyWith(
                      color: const Color(0xFFCACACA),
                    ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: v['episodes'].length,
                itemBuilder: (context, index) {
                  return itemEpisode(ctx, v['episodes'][index]);
                },
              ),
              SizedBox(
                height: Dim().d12,
              ),
              int.parse(v['user_id'].toString()) == int.parse(sID.toString())
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d28),
                      child: ElevatedButton(
                          onPressed: () {
                            epDailog();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(Dim().d8)),
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Dim().d12),
                            child: Center(
                              child: Text('Create Episode',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dim().d16)),
                            ),
                          )),
                    )
                  : Container(),
              SizedBox(
                height: Dim().d100,
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
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
      bottomNavigationBar: bottomNavigation(ctx, -1),
    );
  }

  epDailog() {
    AudioFile = null;
    return AwesomeDialog(
        context: ctx,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        dialogBackgroundColor: const Color(0xff11161E),
        dialogBorderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
        body: Form(
          key: _formkey,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                    child: Text(
                      '${v['name']}',
                      style: Sty().mediumText.copyWith(
                          color: const Color(0xffFFC107),
                          fontSize: Dim().d28,
                          fontWeight: FontWeight.w500),
                    ),
                    // Align(
                  ),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: epNameCtrl,
                        maxLength: 200,
                        maxLines: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Episode Name is required';
                          }
                        },
                        style: Sty().mediumText.copyWith(color: Clr().white),
                        decoration: Sty().textFieldUnderlineStyle.copyWith(
                            counterText: '',
                            hintText: 'Episode Name',
                            hintStyle: Sty()
                                .smallText
                                .copyWith(color: const Color(0xff898989))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  if (v['languages'].length > 1)
                    Text(
                      'Select Language',
                      style: Sty().mediumText.copyWith(
                          color: const Color(0xffFFC107),
                          fontSize: Dim().d16,
                          fontWeight: FontWeight.w500),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: Dim().d20),
                    child: ListView.builder(
                      itemCount: v['languages'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dim().d20),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectIndex =
                                          v['languages'][index]['id'];
                                    });
                                  },
                                  child: _selectIndex ==
                                          v['languages'][index]['id']
                                      ? Icon(
                                          Icons.circle,
                                          color: Clr().white,
                                        )
                                      : Icon(Icons.circle_outlined,
                                          color: Clr().white)),
                              SizedBox(width: Dim().d12),
                              Text(v['languages'][index]['name'].toString(),
                                  style: Sty()
                                      .smallText
                                      .copyWith(color: Clr().white)),
                              SizedBox(width: Dim().d20),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    child: InkWell(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.audio,
                          );
                          if (result != null) {
                            print(result.files.single.path);
                            setState(() {
                              AudioFile = result.files.single.path;
                            });
                          } else {
                            STM().displayToast('Please select audio file');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dim().d12)),
                            border: Border.all(color: Clr().white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dim().d12, vertical: Dim().d14),
                            child: Text(
                              AudioFile != null
                                  ? 'Audio File Selected'
                                  : 'Select Audio File',
                              style: Sty().mediumText.copyWith(
                                    color: AudioFile != null
                                        ? Clr().white
                                        : Clr().hintColor,
                                  ),
                            ),
                          ),
                        )
                        // TextFormField(
                        //   readOnly: true,
                        //   decoration: Sty().textFieldOutlineDarkStyle.copyWith(
                        //       filled: true,
                        //       fillColor: const Color(0xff11161E),
                        //       enabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.all(
                        //               Radius.circular(Dim().d12)),
                        //           borderSide:
                        //               BorderSide(color: Clr().white, width: 1)),
                        //       hintText: 'Select Audio',
                        //       hintStyle: Sty()
                        //           .smallText
                        //           .copyWith(color: Clr().hintColor)),
                        // ),
                        ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d56),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate() &&
                              AudioFile != null) {
                            if (_selectIndex != null) {
                              epAdd(AudioFile);
                              // audioLayout(AudioFile);
                            } else {
                              STM().displayToast('Please Select Language');
                            }
                          } else {
                            STM().displayToast('Please Select Audio File');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Clr().yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d8)))),
                        child: Center(
                          child: Text('ADD',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().white)),
                        )),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                ],
              );
            },
          ),
        )).show();
  }

  epAdd(music) async {
    var body = FormData.fromMap({
      'audio': await MultipartFile.fromFile(music, filename: basename(music)),
      'user_id': sID,
      'name': epNameCtrl.text,
      'podcast': v['id'],
      'language': _selectIndex,
    });
    var result = await STM().postWithoutDialog(ctx,'podcast-episode-add', body);
    if (result['success'] == true) {
      STM().successDialogWithReplace(
          ctx, result['message'], PublicProfile(widget.details));
    } else {
      STM().errorDialog(ctx, result['message']);
    }
    // var request = http.MultipartRequest(
    //     'POST', Uri.parse('${AppUrl().mainUrl}podcast-episode-add'));
    // request.fields['user_id'] = sID.toString();
    // request.fields['name'] = epNameCtrl.text;
    // request.fields['podcast'] = v['id'].toString();
    // request.fields['language'] = _selectIndex.toString();
    // request.files.add(
    //   await http.MultipartFile.fromPath(
    //     'audio',
    //     music,
    //   ),
    // );
    // var response = await request.send();
    // var file = await http.MultipartFile.fromPath(
    //   'audio',
    //   music,
    // );
    // print('File field name: ${file.field}');
    // print('File length: ${file.length}');
    // print('File length: ${file.filename}');
    // print('File length: ${file.contentType}');
    // try {
    //   if (response.statusCode == 200) {
    //     // Successfully uploaded
    //     print('Audio file uploaded successfully');
    //     print(await response.stream.bytesToString());
    //   } else {
    //     // Handle the error case
    //     print(
    //         'Failed to upload audio file. Status code: ${response.statusCode}');
    //     print(await response.stream.bytesToString());
    //   }
    // } catch (error) {
    //   // Handle exceptions
    //   print('Error uploading audio file: $error');
    // }
  }

  audioLayout(music) async {
    print(MultipartFile.fromFile(music, filename: '${basename(music)}.MP3'));
    return MultipartFile.fromFile(music, filename: '${basename(music)}.MP3');
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imageslayout.dart';
import 'manager/expandable.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class TweetDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const TweetDetail(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TweetDetailPage();
  }
}

class TweetDetailPage extends State<TweetDetail> {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

  String? sID;
  TextEditingController commentCtrl = TextEditingController();

  @override
  void initState() {
    v = widget.data;
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

  //Api method
  void like() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
      'post_id': v['id'],
    });
    //Output
    var result = await STM().postWithoutDialog(ctx,"like", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      setState(() {
        if (!v['is_liked']) {
          v['like']++;
          v['is_liked'] = true;
        } else {
          v['like']--;
          v['is_liked'] = false;
        }
      });
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  //Api method
  void comment() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
      'post_id': v['id'],
      'comment': commentCtrl.text.trim(),
    });
    //Output
    var result = await STM().post(ctx, Str().processing, "comment", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      setState(() {
        commentCtrl.clear();
        var chatList2 = [];
        chatList2.add(result['result']);
        chatList2.addAll(v['comments']);
        v['comments'] = chatList2;
        v['comment']++;
      });
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
      appBar: toolbarWithTitleLayout(ctx, 'Post'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                Dim().d16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      STM().roundImage(
                        '${v['user']['image']}',
                        width: Dim().d60,
                        height: Dim().d60,
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '${v['user']['name']}',
                                  style: Sty().mediumBoldText,
                                ),
                                if (v['user']['is_verified'])
                                  STM().imageView(
                                    'assets/verified.png',
                                    height: Dim().d16,
                                  ),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                Text(
                                  '@${v['user']['username']} | ${v['time_ago']}',
                                  style: Sty().smallText.copyWith(
                                        color: const Color(0xFF626262),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: Dim().d4,
                                horizontal: Dim().d12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF292929,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dim().d8,
                                ),
                              ),
                              child: Html(
                                data: '${v['returns']}',
                                shrinkWrap: true,
                                style: {
                                  'body': Style(
                                    margin: Margins.zero,
                                    padding: EdgeInsets.zero,
                                    fontFamily: 'Regular',
                                    letterSpacing: 0.5,
                                    color: Clr().white,
                                    fontSize: FontSize(14.0),
                                  ),
                                },
                                onLinkTap: (url, context, attrs, element) {
                                  STM().openWeb(url!);
                                },
                              ),
                            ),
                            if (v['can_follow'])
                              SizedBox(
                                height: Dim().d12,
                              ),
                            if (v['can_follow'])
                              SizedBox(
                                height: Dim().d24,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Clr().blueColor2,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d24,
                                    ),
                                  ),
                                  child: Text(
                                    'Follow',
                                    style: Sty().microText.copyWith(
                                          color: Clr().white,
                                        ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            STM().buildColoredText(v['tweet'],ctx,'detail'),
                            // Html(
                            //   data: '${v['tweet']}',
                            //   shrinkWrap: true,
                            //   style: {
                            //     'body': Style(
                            //       margin: Margins.zero,
                            //       padding: EdgeInsets.zero,
                            //       fontFamily: 'Regular',
                            //       letterSpacing: 0.5,
                            //       color: const Color(0xFF626262),
                            //       fontSize: FontSize(14.0),
                            //     ),
                            //   },
                            //   onLinkTap: (url, context, attrs, element) {
                            //     STM().openWeb(url!);
                            //   },
                            // ),
                            // if (v['image1'] != null && v['image1'].isNotEmpty)
                            //   SizedBox(
                            //     height: Dim().d12,
                            //   ),
                            // if (v['image1'] != null && v['image1'].isNotEmpty)
                            //   Row(
                            //     children: [
                            //       if (v['image1'] != null &&
                            //           v['image1'].isNotEmpty)
                            //         Expanded(
                            //           child: ClipRRect(
                            //             borderRadius: BorderRadius.circular(
                            //               Dim().d12,
                            //             ),
                            //             child: STM().imageView(
                            //               '${v['image1']}',
                            //               height: Dim().d120,
                            //               fit: BoxFit.fitHeight,
                            //             ),
                            //           ),
                            //         ),
                            //       if (v['image2'] != null &&
                            //           v['image2'].isNotEmpty)
                            //         Expanded(
                            //           child: Container(
                            //             margin: EdgeInsets.only(
                            //               left: Dim().d12,
                            //             ),
                            //             child: ClipRRect(
                            //               borderRadius: BorderRadius.circular(
                            //                 Dim().d12,
                            //               ),
                            //               child: STM().imageView(
                            //                 '${v['image2']}',
                            //                 height: Dim().d120,
                            //                 fit: BoxFit.fitHeight,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //     ],
                            //   ),
                            if (v['images'] != null)
                              SizedBox(
                                height: Dim().d12,
                              ),
                            if (v['images'].length != 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.builder(
                                    itemCount: v['images'].length,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12.0,
                                        crossAxisSpacing: 12.0,
                                        childAspectRatio: 12 / 7,
                                        mainAxisExtent: 120.0),
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx,
                                              imagesLayout(
                                                  vImage: v['images'][index]
                                                  ['image_path']));
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dim().d12,
                                          ),
                                          child: STM().imageView(
                                            '${v['images'][index]['image_path']}',
                                            height: Dim().d120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    like();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/like.svg',
                                        color: v['is_liked']
                                            ? Clr().accentColor
                                            : Clr().white,
                                      ),
                                      SizedBox(
                                        width: Dim().d4,
                                      ),
                                      Text(
                                        '${v['like']}',
                                        style: Sty().microText.copyWith(
                                              color: v['is_liked']
                                                  ? Clr().accentColor
                                                  : Clr().white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: null,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      STM().imageView(
                                        'assets/comment.png',
                                        height: Dim().d20,
                                      ),
                                      SizedBox(
                                        width: Dim().d4,
                                      ),
                                      Text(
                                        '${v['comment']}',
                                        style: Sty().microText,
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/share.svg',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color(0xFFFFFFFF),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: v['comments'].length,
                    itemBuilder: (context, index) {
                      // int index2 = v['comments'].length - 1 - index;
                      return itemLayout(v['comments'][index],ctx);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: Dim().d12,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dim().d12,
              horizontal: Dim().d16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Replying to ',
                    style: Sty().mediumText,
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          onTap: () {
                            // STM().redirect2page(ctx, const Register());
                          },
                          child: Text(
                            '@${v['user']['username']}',
                            style: Sty().mediumBoldText.copyWith(
                                  color: Clr().accentColor,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                STM().commentField(commentCtrl, () {
                  comment();
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget itemLayout(v,ctx) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      STM().roundImage(
        '${v['user']['image']}',
        width: Dim().d40,
        height: Dim().d40,
      ),
      SizedBox(
        width: Dim().d12,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${v['user']['name']}',
                  style: Sty().smallText,
                ),
                // STM().imageView(
                //   'assets/verified.png',
                //   height: Dim().d16,
                // ),
                SizedBox(
                  width: Dim().d4,
                ),
                Text(
                  '@${v['user']['username']} | ${STM().timeAgo(v['time'])}',
                  style: Sty().microText.copyWith(
                        color: const Color(0xFF626262),
                      ),
                ),
              ],
            ),
            STM().buildColoredText(v['comment'],ctx,'detail'),
          ],
        ),
      ),
    ],
  );
}

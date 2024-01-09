import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bazaarniti/manager/app_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import '../anotherprofile.dart';
import '../bn_explore.dart';
import '../imageslayout.dart';
import '../manager/expandable.dart';
import '../manager/static_method.dart';
import '../public_profile.dart';
import '../tweet_detail.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

int? selectIndex;

Widget itemHomeTweet(ctx, v, sID, setState, index) {
  return Container(
    margin: EdgeInsets.only(
      bottom: Dim().d12,
    ),
    child: v['user'] == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          int.parse(sID) == int.parse(v['user_id'].toString())
                              ? STM().redirect2page(
                                  ctx,
                                  PublicProfile(v['user']),
                                )
                              : STM().redirect2page(
                                  ctx,
                                  anotherProfile(v['user']),
                                );
                        },
                        iconSize: Dim().d60,
                        splashRadius: Dim().d40,
                        icon: STM().roundImage(
                          '${v['user']['image']}',
                          width: Dim().d60,
                          height: Dim().d60,
                        ),
                      ),
                      int.parse(sID) == int.parse(v['user_id'].toString())
                          ? Container()
                          : !v['can_follow']
                              ? Container()
                              : Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: InkWell(
                                    onTap: () {
                                      follow(ctx, v, setState, sID);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Clr().accentColor,
                                        borderRadius: BorderRadius.circular(
                                          Dim().d100,
                                        ),
                                      ),
                                      child: Icon(
                                        v['can_follow']
                                            ? Icons.add
                                            : Icons.remove,
                                        size: Dim().d20,
                                        color: Clr().white,
                                      ),
                                    ),
                                  ),
                                ),
                    ],
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
                            SizedBox(width: Dim().d2),
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
                        // SizedBox(
                        //   height: Dim().d8,
                        // ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: Dim().d4,
                        //     horizontal: Dim().d12,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: const Color(
                        //       0xFF292929,
                        //     ),
                        //     borderRadius: BorderRadius.circular(
                        //       Dim().d8,
                        //     ),
                        //   ),
                        //   child: Html(
                        //     data: '${v['returns']}',
                        //     shrinkWrap: true,
                        //     style: {
                        //       'body': Style(
                        //         margin: Margins.zero,
                        //         padding: EdgeInsets.zero,
                        //         fontFamily: 'Regular',
                        //         letterSpacing: 0.5,
                        //         color: Clr().white,
                        //         fontSize: FontSize(14.0),
                        //       ),
                        //     },
                        //     onLinkTap: (url, context, attrs, element) {
                        //       STM().openWeb(url!);
                        //     },
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: Dim().d12,
                        // ),
                        buildColoredText(v['tweet'], ctx, 'post'),
                        if (v['tweet'].toString().length > 80)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              STM().redirect2page(ctx, TweetDetail(v));
                            },
                            child: Text(
                              'Show More',
                              style:
                                  Sty().smallText.copyWith(fontSize: Dim().d12),
                            ),
                          ),
                        if (v['images'] != null)
                          SizedBox(
                            height: Dim().d12,
                          ),
                        if (v['images'].length != 0)
                          selectIndex == index
                              ? Column(
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
                                    SizedBox(height: Dim().d8),
                                    Align(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectIndex = -1;
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_drop_up,
                                            color: Clr().white,
                                            size: Dim().d32,
                                          )),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx,
                                              imagesLayout(
                                                  vImage: v['images'][0]
                                                      ['image_path']));
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dim().d12,
                                          ),
                                          child: STM().imageView(
                                            '${v['images'][0]['image_path']}',
                                            height: Dim().d120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (v['images'].length > 2)
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectIndex = index;
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Opacity(
                                                opacity: v['images'].length > 2
                                                    ? 0.4
                                                    : 1,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    left: Dim().d12,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      Dim().d12,
                                                    ),
                                                    child: STM().imageView(
                                                      '${v['images'][1]['image_path']}',
                                                      height: Dim().d120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (v['images'].length > 2)
                                                Positioned(
                                                  top: Dim().d48,
                                                  left: Dim().d60,
                                                  child: Text(
                                                    '+${v['images'].length - 2}',
                                                    style: Sty().extraLargeText,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (v['images'].length == 2)
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                STM().redirect2page(
                                                    ctx,
                                                    imagesLayout(
                                                        vImage: v['images'][1]
                                                            ['image_path']));
                                              },
                                              child: Opacity(
                                                opacity: v['images'].length > 2
                                                    ? 0.4
                                                    : 1,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    left: Dim().d12,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      Dim().d12,
                                                    ),
                                                    child: STM().imageView(
                                                      '${v['images'][1]['image_path']}',
                                                      height: Dim().d120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // if (v['images'].length > 2)
                                            //   Positioned(
                                            //     top: Dim().d48,
                                            //     left: Dim().d60,
                                            //     child: Text(
                                            //       '+${v['images'].length - 2}',
                                            //       style: Sty().extraLargeText,
                                            //     ),
                                            //   ),
                                          ],
                                        ),
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
                                like(ctx, v, setState, sID);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
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
                              onPressed: () {
                                STM().redirect2page(ctx, TweetDetail(v));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/comment.svg',
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
                              onPressed: () {
                                Share.share(
                                    '*${v['user']['name']}*\n${v['tweet'].toString().replaceRange(30, v['tweet'].toString().length, '......')}\n\n  https://lawmakers.co.in/bazaarniti/deeplink/?playmarket=true&id=${v['id']}',
                                    subject:
                                        'Click on deep link and go to this page!!!!');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              SizedBox(height: Dim().d12),
              Padding(
                padding: EdgeInsets.only(left: Dim().d20),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      v['comments'].length > 2 ? 1 : v['comments'].length,
                  itemBuilder: (context, index) {
                    return itemLayout(ctx, v['comments'][index], sID);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: Dim().d12,
                    );
                  },
                ),
              ),
              if (v['comments'].length != 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      STM().redirect2page(ctx, TweetDetail(v));
                    },
                    child: Text(
                      v['comments'].length == 1
                          ? 'View Comment'
                          : 'View All ${v['comments'].length} Comments',
                      style: Sty().microText.copyWith(
                          // decoration: TextDecoration.underline,
                          color: Clr().accentColor,
                          decorationColor: Clr().white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.0),
                    ),
                  ),
                ),
            ],
          ),
  );
}

Widget itemLayout(ctx, v, sID) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {
          int.parse(sID) == int.parse(v['user_id'].toString())
              ? STM().redirect2page(
                  ctx,
                  PublicProfile(v['user']),
                )
              : STM().redirect2page(
                  ctx,
                  anotherProfile(v['user']),
                );
        },
        child: STM().roundImage(
          '${v['user']['image']}',
          width: Dim().d40,
          height: Dim().d40,
        ),
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
            buildColoredText('${v['comment']}', ctx, 'comment'),
            // ExpandableText(
            //   '${v['comment']}',
            // ),
          ],
        ),
      ),
    ],
  );
}

//Api method
void follow(ctx, v, setState, sID) async {
  //Input
  FormData body = FormData.fromMap({
    'from_id': sID,
    'to_id': v['user_id'],
  });
  //Output
  var result = await STM().postWithoutDialog(ctx, "follow", body);
  var success = result['success'];
  var message = result['message'];
  if (success) {
    setState(() {
      if (v['can_follow']) {
        v['can_follow'] = false;
      } else {
        v['can_follow'] = true;
      }
    });
    STM().displayToast(message);
  } else {
    STM().errorDialog(ctx, message);
  }
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
            // if (word.contains('#')) STM().displayToast('#Selected');
            STM().replacePage(
                ctx,
                Explore(
                  name: word
                      .toString()
                      .replaceAll('#', '')
                      .replaceAll('@', '')
                      .replaceAll('.', ''),
                  type: 'search',
                ));
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
            child: InkWell(
          onTap: () {
            STM().replacePage(
                ctx,
                Explore(
                  name: word
                      .toString()
                      .replaceAll('@', '')
                      .replaceAll('#', '')
                      .replaceAll('.', ''),
                  type: 'search',
                ));
          },
          child: Text(word + ' ',
              style: Sty().mediumText.copyWith(
                  color: Color(0xFF626262),
                  fontSize: type == 'comment' ? Dim().d12 : Dim().d14)),
        )),
      );
    }
  }

  return RichText(
    maxLines: 3,
    text: TextSpan(
      children: spans,
    ),
  );
}

//Api method
void like(ctx, v, setState, sID) async {
  //Input
  FormData body = FormData.fromMap({
    'user_id': sID,
    'post_id': v['id'],
  });
  //Output
  var result = await STM().postWithoutDialog(ctx, "like", body);
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

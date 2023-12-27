import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../manager/static_method.dart';
import '../public_profile.dart';
import '../tweet_detail.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemProfileTweet(ctx, v) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Dim().d12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  STM().redirect2page(
                    ctx,
                    PublicProfile(
                      {
                        'user_id': '${v['user_id']}',
                        'name': '${v['name']}',
                      },
                    ),
                  );
                },
                iconSize: Dim().d60,
                splashRadius: Dim().d40,
                icon: STM().imageView(
                  '${v['image']}',
                  width: Dim().d60,
                  height: Dim().d60,
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
                          '${v['name']}',
                          style: Sty().mediumBoldText,
                        ),
                        if (v['is_verified'])
                          STM().imageView(
                            'assets/verified.png',
                            height: Dim().d16,
                          ),
                        SizedBox(
                          width: Dim().d4,
                        ),
                        Text(
                          '${v['username']} | ${v['time']}',
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
                    SizedBox(
                      height: Dim().d12,
                    ),
                    Text(
                      '${v['tweet']}',
                      style: Sty().mediumText.copyWith(
                            color: const Color(0xFF626262),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                        style: Sty().mediumBoldText,
                      ),
                    ),
                    if (v['image1'] != null && v['image1'].isNotEmpty)
                      SizedBox(
                        height: Dim().d12,
                      ),
                    if (v['image1'] != null && v['image1'].isNotEmpty)
                      Row(
                        children: [
                          if (v['image1'] != null && v['image1'].isNotEmpty)
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dim().d12,
                                ),
                                child: STM().imageView(
                                  '${v['image1']}',
                                  height: Dim().d120,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          if (v['image2'] != null && v['image2'].isNotEmpty)
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: Dim().d12,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dim().d12,
                                  ),
                                  child: STM().imageView(
                                    '${v['image2']}',
                                    height: Dim().d120,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
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
                            setState(() {
                              if (!v['is_liked']) {
                                v['like']++;
                                v['is_liked'] = true;
                              } else {
                                v['like']--;
                                v['is_liked'] = false;
                              }
                            });
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
                                    ? Clr().blueColor
                                    : Clr().white,
                              ),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Text(
                                '${v['like']}',
                                style: Sty().microText.copyWith(
                                      color: v['is_liked']
                                          ? Clr().blueColor
                                          : Clr().white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: SvgPicture.asset(
                            'assets/share.svg',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: Dim().d4,
                ),
                child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/edit.svg',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
}

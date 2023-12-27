import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemHeaderDetail(ctx, v) {
  return InkWell(
    onTap: () {
      // STM().redirect2page(ctx, EpisodeList(v));
    },
    child: Container(
      margin: EdgeInsets.only(
        bottom: Dim().d12,
      ),
      padding: EdgeInsets.all(
        Dim().d8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${v['name']}',
                        style: Sty().smallText,
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        '${v['description']}',
                        style: Sty().smallText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${v['price']}',
                      style: Sty().smallText,
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      '${v['change']}',
                      style: Sty().smallText.copyWith(
                            color: v['change'].contains('-')
                                ? Clr().red2
                                : Clr().green2,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dim().d12,
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/bookmark.svg',
            ),
          ),
        ],
      ),
    ),
  );
}

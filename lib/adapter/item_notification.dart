import 'package:flutter/material.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemNotification(ctx, v) {
  return InkWell(
    onTap: () {
      // STM().redirect2page(ctx, EpisodeList(v));
    },
    child: Container(
      padding: EdgeInsets.all(
        Dim().d8,
      ),
      child: Row(
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
                SizedBox(
                  height: Dim().d8,
                ),
                Text(
                  '${v['message']}',
                  style: Sty().smallText,
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dim().d12,
          ),
          Text(
            STM().timeAgo(v['time']),
            style: Sty().microText,
          ),
        ],
      ),
    ),
  );
}

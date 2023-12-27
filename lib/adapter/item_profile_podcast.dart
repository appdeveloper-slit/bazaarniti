import 'package:flutter/material.dart';

import '../episode_list.dart';
import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemProfilePodcast(ctx, v) {
  return InkWell(
    onTap: () {
      STM().redirect2page(ctx, EpisodeList(v));
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF292929,
        ),
        borderRadius: BorderRadius.circular(
          Dim().d8,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: Dim().d12,
      ),
      padding: EdgeInsets.all(
        Dim().d8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${v['name']}',
                      style: Sty().largeText.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${v['episodes']} Episodes',
                      style: Sty().smallText,
                    ),
                    Text(
                      '${v['language']}',
                      style: Sty().smallText,
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Text(
                  '${v['description']}',
                  style: Sty().smallText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dim().d12,
          ),
          Icon(
            Icons.navigate_next,
            size: Dim().d32,
            color: Clr().white,
          ),
        ],
      ),
    ),
  );
}

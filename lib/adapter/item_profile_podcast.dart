import 'package:flutter/material.dart';

import '../episode_list.dart';
import '../manager/static_method.dart';
import '../public_profile.dart';
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
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${v['name']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Sty().mediumText.copyWith(
                    color: Clr().white,
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Wrap(
                  crossAxisAlignment:
                  WrapCrossAlignment.center,
                  children: [
                    if (v['episodes']
                        .length !=
                        0)
                      Text(
                        '${v['episodes'].length} Episodes',
                        style: Sty()
                            .mediumText
                            .copyWith(color: Clr().white),
                      ),
                    if (v['episodes']
                        .length !=
                        0)
                      SizedBox(
                        width: Dim().d12,
                      ),
                    listOfLanguage(
                        v['languages']),
                  ],
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Text('${v['description']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Sty()
                        .microText
                        .copyWith(color: Clr().white)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: Dim().d32, color: Clr().white)
        ],
      ),
    ),
  );
}

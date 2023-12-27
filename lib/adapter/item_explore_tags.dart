import 'package:bazaarniti/manager/static_method.dart';
import 'package:flutter/material.dart';

import '../bn_home.dart';
import '../tagdeatils.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'item_home_tweet.dart';

Widget itemExploreTags(ctx, v) {
  return ListTile(
    onTap: () {
      STM().redirect2page(
          ctx,
          tagdetails(
            details: v['tag'],
          ));
    },
    leading: Container(
      padding: EdgeInsets.all(
        Dim().d16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Clr().accentColor,
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: EdgeInsets.only(
          bottom: Dim().d8,
        ),
        child: Text(
          '#',
          style: Sty().largeText,
        ),
      ),
    ),
    title: Text(
      '${v['tag']}',
      style: Sty().largeText,
    ),
  );
}

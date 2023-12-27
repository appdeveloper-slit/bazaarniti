import 'package:flutter/material.dart';

import '../anotherprofile.dart';
import '../message.dart';
import '../manager/static_method.dart';
import '../public_profile.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemFollower(ctx, v,sID) {
  return ListTile(
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
    contentPadding: EdgeInsets.symmetric(
      vertical: Dim().d8,
      horizontal: Dim().pp,
    ),
    leading: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(Dim().d56)),
      child: STM().imageView(
        '${v['image']}',
        width: Dim().d60,
        height: Dim().d60,
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${v['name']}',
          style: Sty().mediumText,
        ),
        Text(
          '${v['username']}',
          style: Sty().smallText.copyWith(
                color: const Color(0xFF898989),
              ),
        ),
      ],
    ),
    trailing: STM().button('Remove', () {},
        width: Dim().d80,
        height: Dim().d32,
        color: Clr().accentColor,
        b: false,
        style: 'small'),
  );
}

import 'package:flutter/material.dart';

import '../anotherprofile.dart';
import '../bn_home.dart';
import '../manager/static_method.dart';
import '../public_profile.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemExplorePeople(
  ctx,
  v,
) {
  return ListTile(
    onTap: () {
      int.parse(sID!) == int.parse(v['id'].toString())
          ? STM().redirect2page(
              ctx,
              PublicProfile(v),
            )
          : STM().redirect2page(
              ctx,
              anotherProfile(v),
            );
    },
    leading: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(Dim().d56)),
      child: STM().imageView(
        '${v['image']}',
        height: Dim().d60,
        width: Dim().d60,
      ),
    ),
    title: Text(
      '${v['name']}',
      style: Sty().largeText,
    ),
    subtitle: Text(
      '${v['username']}',
      style: Sty().smallText.copyWith(
            color: const Color(0xFF626262),
          ),
    ),
  );
}

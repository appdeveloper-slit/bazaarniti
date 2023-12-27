import 'package:flutter/material.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemDematLogin(ctx, v) {
  return Container(
    margin: EdgeInsets.all(
      Dim().d4,
    ),
    child: Column(
      children: [
        STM().imageView(
          v['image'],
          height: Dim().d60,
        ),
        SizedBox(
          height: Dim().d4,
        ),
        Text(
          '${v['name']}',
          style: Sty().mediumText,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

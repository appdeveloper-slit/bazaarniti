import 'package:flutter/material.dart';

import '../header_detail.dart';
import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemHomeHeader(ctx, index, v) {
  return InkWell(
    onTap: () {
      STM().redirect2page(ctx, HeaderDetail(index));
    },
    child: Container(
      height: Dim().d100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(-1, 0),
            color: Clr().accentColor,
          ),
        ],
        color: const Color(
          0xFF292929,
        ),
        borderRadius: BorderRadius.circular(
          Dim().d8,
        ),
      ),
      padding: EdgeInsets.all(
        Dim().d8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${v['name']}',
            style: Sty().mediumText,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${v['price']}',
            style: Sty().smallText,
            overflow: TextOverflow.ellipsis,
          ),
          Flexible(
            child: Text(
              '${v['change']}',
              style: Sty().smallText.copyWith(
                    color: v['change'].toString().contains('+')
                        ? Clr().green2
                        : Clr().red2,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

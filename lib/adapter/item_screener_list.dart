import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../manager/static_method.dart';
import '../screener_detail.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemScreenerList(ctx, v, {b = false}) {
  return ListTile(
    onTap: () {
      if (b) {
      } else {
        STM().redirect2page(ctx, ScreenerDetail(v));
      }
    },
    contentPadding: EdgeInsets.symmetric(
      vertical: Dim().d8,
      horizontal: Dim().d20,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    tileColor: b
        ? v['color']
        : const Color(
            0xFF292929,
          ),
    title: Text(
      '${v['name']}',
      style: b ? Sty().extraLargeText : Sty().largeText,
    ),
    trailing: SvgPicture.asset(
      'assets/circle_next.svg',
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemHomeSlider(v) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(
        0xFF292929,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d4,
      ),
    ),
    margin: EdgeInsets.all(
      Dim().d2,
    ),
    padding: EdgeInsets.all(
      Dim().d8,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: itemLayout(
            v['data1'],
          ),
        ),
        Expanded(
          child: itemLayout(
            v['data2'],
          ),
        ),
        Expanded(
          child: itemLayout(
            v['data3'],
          ),
        ),
      ],
    ),
  );
}

Widget itemLayout(v) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/vertical_line.svg',
        height: Dim().d80,
      ),
      SizedBox(
        width: Dim().d8,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${v['name']}',
              style: Sty().largeText,
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
      )
    ],
  );
}

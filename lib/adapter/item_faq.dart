import 'package:flutter/material.dart';

import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemFAQ(ctx, v) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(
        0xFF292929,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    padding: EdgeInsets.all(
      Dim().d8,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${v['question']}',
          style: Sty().smallText.copyWith(
                color: Clr().accentColor,
              ),
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Text(
          '${v['answer']}',
          style: Sty().smallText,
        ),
      ],
    ),
  );
}

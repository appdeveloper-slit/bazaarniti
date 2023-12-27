import 'package:flutter/material.dart';

import '../message.dart';
import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemMic(ctx, v) {
  return ListTile(
    onTap: () {
      // STM().redirect2page(ctx, Message(v));
    },
    contentPadding: EdgeInsets.symmetric(
      vertical: Dim().d8,
      horizontal: Dim().pp,
    ),
    visualDensity: const VisualDensity(vertical: 4),
    leading: Column(
      children: [
        Text(
          '${v['day']}',
          style: Sty().smallText,
        ),
        Container(
          width: Dim().d48,
          height: Dim().d48,
          decoration: BoxDecoration(
            color: Clr().accentColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${v['date']}',
              style: Sty().largeText,
            ),
          ),
        ),
      ],
    ),
    title: ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: v['array'].length,
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(
              0xFF292929,
            ),
          ),
          padding: EdgeInsets.all(
            Dim().d12,
          ),
          child: Text(
            '${v['array'][index]}',
            style: Sty().mediumText,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(ctx).size.width,
          height: 0.5,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Clr().white,
              blurRadius: 1,
              offset: const Offset(
                0,
                1,
              ),
            ),
          ]),
        );
      },
    ),
  );
}

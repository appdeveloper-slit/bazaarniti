import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:flutter/material.dart';
import '../values/colors.dart';

Widget itemPeopleToFollow(ctx, v) {
  return Padding(
    padding:  EdgeInsets.only(right: Dim().d12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: Dim().d120,
          width: Dim().d120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Clr().white,
          ),
          child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dim().d56)),child: Image.network('${v['image']}', fit: BoxFit.cover)),
        ),
        SizedBox(
          height: Dim().d4,
        ),
        Text('${v['name']}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Sty().mediumText.copyWith(color: Clr().white)),
        SizedBox(
          height: Dim().d4,
        ),
        Text('Follow',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Sty().mediumText.copyWith(color: const Color(0xff3091EE))),
      ],
    ),
  );
}


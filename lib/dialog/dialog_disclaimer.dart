import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../manager/static_method.dart';
import '../register_detail.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget dialogDisclaimer(ctx) {
  return Container(
    padding: EdgeInsets.all(
      Dim().d16,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        Dim().d20,
      ),
    ),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Text(
          'Disclaimer',
          style: Sty().extraLargeText.copyWith(
                color: Clr().black,
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: Dim().d20,
          ),
          child: SvgPicture.asset(
            'assets/disclaimer1.svg',
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: Dim().d20,
          ),
          child: SvgPicture.asset(
            'assets/disclaimer2.svg',
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: Dim().d20,
          ),
          child: STM().button(
            'I Agree',
            () {
              RegisterDetailPage.controller.sink.add("Updated");
              STM().back2Previous(ctx);
            },
            color: Clr().accentColor,
            b: false,
          ),
        ),
      ],
    ),
  );
}

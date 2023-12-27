import 'package:flutter/material.dart';

import '../demat_detail.dart';
import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemDematRegister(ctx, v) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0x80323232),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(
        Dim().d8,
      ),
    ),
    margin: EdgeInsets.all(
      Dim().d4,
    ),
    child: InkWell(
      onTap: () {
        STM().redirect2page(ctx, DematDetail(v['name']));
      },
      child: Padding(
        padding: EdgeInsets.all(
          Dim().d12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${v['name']}',
                        style: Sty().largeText,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      Text(
                        '${v['points']}',
                        style: Sty().smallText,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Dim().d12,
                ),
                STM().imageView(
                  v['image'],
                  height: Dim().d40,
                ),
              ],
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '${v['description']}',
              style: Sty().microText.copyWith(
                    color: const Color(0xFF9C9C9C),
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

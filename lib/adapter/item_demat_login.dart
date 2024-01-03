import 'package:flutter/material.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import '../webview.dart';

Widget itemDematLogin(ctx, v) {
  return InkWell(
    onTap: () {
      STM().redirect2page(
          ctx,
          const WebViewPage('https://smartapi.angelbroking.com/publisher-login?api_key=RklkUXTQ'));
    },
    child: Container(
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
    ),
  );
}

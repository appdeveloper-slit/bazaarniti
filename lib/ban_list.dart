import 'adapter/item_header_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class BanList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BanListPage();
  }
}

class BanListPage extends State<BanList> {
  late BuildContext ctx;

  String? sMessage;
  List<dynamic> resultList = [
    {
      'id': 1,
      'name': 'HNDFDS',
      'price': '₹207.55',
      'change': '+4.99%',
      'description': 'Hindustan Foods',
    },
    {
      'id': 2,
      'name': 'HNDFDS',
      'price': '₹207.55',
      'change': '-4.99%',
      'description': 'Hindustan Foods',
    },
    {
      'id': 3,
      'name': 'HNDFDS',
      'price': '₹207.55',
      'change': '+4.99%',
      'description': 'Hindustan Foods',
    },
    {
      'id': 4,
      'name': 'HNDFDS',
      'price': '₹207.55',
      'change': '-4.99%',
      'description': 'Hindustan Foods',
    },
  ];

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarWithTitleLayout(ctx,'Watch List', b: true),
      body: bodyLayout(),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          STM().redirect2page(ctx, AddTweet());
        },
        backgroundColor: Clr().accentColor,
        child: SvgPicture.asset(
          'assets/tweet.svg',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigation(ctx, -1),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return resultList.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dim().d8,
              horizontal: Dim().pp,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Banned in FnO as on 15/09/2022',
                  style: Sty().mediumText,
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: resultList.length,
                  itemBuilder: (context, index) {
                    return itemHeaderDetail(ctx, resultList[index]);
                  },
                ),
              ],
            ),
          )
        : STM().emptyData(ctx,'$sMessage');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_mic.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class Mic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExplorePage();
  }
}

class ExplorePage extends State<Mic> {
  late BuildContext ctx;

  String? sMessage;
  List<dynamic> resultList = [
    {
      'id': 1,
      'day': 'Mon',
      'date': '17',
      'array': [
        'Lorem ipsum dolor sit at',
        'Lorem ipsum dolor sit at',
        'Lorem ipsum dolor sit at',
      ],
    },
    {
      'id': 2,
      'day': 'Tues',
      'date': '18',
      'array': [
        'Lorem ipsum dolor sit at',
        'Lorem ipsum dolor sit at',
        'Lorem ipsum dolor sit at',
      ],
    },
    {
      'id': 3,
      'day': 'Wed',
      'date': '19',
      'array': [
        'Lorem ipsum dolor sit at',
        'Lorem ipsum dolor sit at',
        'Lorem ipsum dolor sit at',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        if (!mounted) return true;
        var list = sp.getStringList('stack');
        var i = list!.indexWhere((e) => e == '2');
        var position = list[i - 1];
        STM().switchCondition(ctx, position);
        list.removeAt(i);
        sp.setStringList('stack', list);
        return true;
      },
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: toolbarBottomNavigation(ctx, 2, ''),
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
        bottomNavigationBar: bottomNavigation(ctx, 2),
      ),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return resultList.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Happening in ',
                    style: Sty().extraLargeText,
                    children: [
                      TextSpan(
                        text: 'BAZAAR',
                        style: Sty().extraLargeText.copyWith(
                              color: Clr().accentColor,
                            ),
                      ),
                      TextSpan(
                        text: '\nLorem ipsum dolor sit at, consectetur ',
                        style: Sty().smallText,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resultList.length,
                  itemBuilder: (context, index) {
                    return itemMic(ctx, resultList[index]);
                  },
                ),
              ],
            ),
          )
        : STM().emptyData(ctx,'$sMessage');
  }
}

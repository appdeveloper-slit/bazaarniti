import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adapter/item_header_detail.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class HeaderDetail extends StatefulWidget {
  final int index;

  const HeaderDetail(this.index, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HeaderDetailPage();
  }
}

class HeaderDetailPage extends State<HeaderDetail>
    with TickerProviderStateMixin {
  late BuildContext ctx;

  List<dynamic> resultList = [
    {
      'price': '19,955.40',
      'change': '-123.36(0.70%)',
      'date': '16 sep 2022 03:03:31 PM',
      'gainers': [
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
          'change': '+4.99%',
          'description': 'Hindustan Foods',
        },
        {
          'id': 3,
          'name': 'HNDFDS',
          'price': '₹207.55',
          'change': '+4.99%',
          'description': 'Hindustan Foods',
        },
      ],
      'losers': [
        {
          'id': 1,
          'name': 'HNDFDS',
          'price': '₹207.55',
          'change': '-4.99%',
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
          'change': '-4.99%',
          'description': 'Hindustan Foods',
        },
      ],
    },
    {
      'price': '19,955.40',
      'change': '-123.36(0.70%)',
      'date': '16 sep 2022 03:03:31 PM',
      'gainers': [
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
          'change': '+4.99%',
          'description': 'Hindustan Foods',
        },
        {
          'id': 3,
          'name': 'HNDFDS',
          'price': '₹207.55',
          'change': '+4.99%',
          'description': 'Hindustan Foods',
        },
      ],
      'losers': [
        {
          'id': 1,
          'name': 'HNDFDS',
          'price': '₹207.55',
          'change': '-4.99%',
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
          'change': '-4.99%',
          'description': 'Hindustan Foods',
        },
      ],
    },
    {
      'price': '19,955.40',
      'change': '-123.36(0.70%)',
      'date': '16 sep 2022 03:03:31 PM',
      'gainers': [
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
          'change': '+4.99%',
          'description': 'Hindustan Foods',
        },
        {
          'id': 3,
          'name': 'HNDFDS',
          'price': '₹207.55',
          'change': '+4.99%',
          'description': 'Hindustan Foods',
        },
      ],
      'losers': [
        {
          'id': 1,
          'name': 'HNDFDS',
          'price': '₹207.55',
          'change': '-4.99%',
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
          'change': '-4.99%',
          'description': 'Hindustan Foods',
        },
      ],
    },
  ];

  List<String> tabList = [
    "Nifty",
    "Bank Nifty",
    "Portfolio",
  ];
  TabController? tabCtrl;

  List<String> tabList2 = [
    "Top gainers",
    "Top losers",
  ];
  TabController? tabCtrl2;

  List<dynamic> gainerList = [];
  List<dynamic> loserList = [];

  @override
  void initState() {
    tabCtrl = TabController(length: 3, vsync: this);
    tabCtrl2 = TabController(length: 2, vsync: this);
    tabCtrl!.index = widget.index;
    gainerList = resultList[tabCtrl!.index]['gainers'];
    loserList = resultList[tabCtrl!.index]['losers'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarHeader(),
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
      bottomNavigationBar: bottomNavigation(ctx, 3),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          STM().tabBar(
            tabCtrl,
            tabList
                .map(
                  (e) => Tab(
                    text: e,
                  ),
                )
                .toList(),
            (v) {
              setState(() {
                tabCtrl!.index = v;
                tabCtrl2!.index = 0;
                gainerList = resultList[tabCtrl!.index]['gainers'];
                loserList = resultList[tabCtrl!.index]['losers'];
              });
            },
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Text(
            tabList[tabCtrl!.index],
            style: Sty().extraLargeText.copyWith(
                  fontSize: 32,
                ),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Text(
            '${resultList[tabCtrl!.index]['price']}',
            style: Sty().largeText,
          ),
          Text(
            '${resultList[tabCtrl!.index]['change']}',
            style: Sty().smallText.copyWith(
                  color: resultList[tabCtrl!.index]['change'].contains('-')
                      ? Clr().red2
                      : Clr().green2,
                ),
          ),
          Text(
            '${resultList[tabCtrl!.index]['date']}',
            style: Sty().smallText.copyWith(
                  color: const Color(0xFF5F5F5F),
                ),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          TabBar(
            onTap: (v) {
              setState(() {
                tabCtrl2!.index = v;
              });
            },
            controller: tabCtrl2,
            labelColor: tabCtrl2!.index == 0 ? Clr().green2 : Clr().red2,
            labelStyle: Sty().largeText,
            unselectedLabelColor: Clr().white,
            unselectedLabelStyle: Sty().largeText,
            indicatorColor: tabCtrl2!.index == 0 ? Clr().green2 : Clr().red2,
            tabs: tabList2.map((e) {
              return Tab(
                text: e,
              );
            }).toList(),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                tabCtrl2!.index == 0 ? gainerList.length : loserList.length,
            itemBuilder: (context, index) {
              return itemHeaderDetail(ctx,
                  tabCtrl2!.index == 0 ? gainerList[index] : loserList[index]);
            },
          ),
        ],
      ),
    );
  }
}

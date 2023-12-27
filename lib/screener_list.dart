import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adapter/item_screener_list.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class ScreenerList extends StatefulWidget {
  final Map<String, dynamic> data;

  const ScreenerList(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ScreenerListPage();
  }
}

class ScreenerListPage extends State<ScreenerList>
    with TickerProviderStateMixin {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

  List<dynamic> resultList = [
    {
      'id': 1,
      'name': 'Nifty',
    },
    {
      'id': 2,
      'name': 'Bank Nifty',
    },
    {
      'id': 3,
      'name': 'Fin Nifty',
    },
  ];

  @override
  void initState() {
    v = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarWithTitleLayout(ctx, v['name']),
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
    return resultList.isNotEmpty
        ? ListView.separated(
            padding: EdgeInsets.symmetric(
              vertical: Dim().d8,
              horizontal: Dim().d16,
            ),
            itemCount: resultList.length,
            itemBuilder: (context, index) {
              return itemScreenerList(ctx, resultList[index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: Dim().d12,
              );
            },
          )
        : STM().emptyData(ctx,'No Data Found');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adapter/item_screener_list.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class ScreenerDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const ScreenerDetail(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ScreenerDetailPage();
  }
}

class ScreenerDetailPage extends State<ScreenerDetail>
    with TickerProviderStateMixin {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

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
      bottomNavigationBar: bottomNavigation(ctx, 3,setState),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return Column();
  }
}

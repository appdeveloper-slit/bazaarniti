import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'adapter/item_home_tweet.dart';
import 'adapter/item_post_detail.dart';
import 'add_tweet.dart';
import 'bn_home.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'values/strings.dart';

class tagdetails extends StatefulWidget {
  final details;

  const tagdetails({super.key, this.details});

  @override
  State<tagdetails> createState() => _tagdetailsState();
}

class _tagdetailsState extends State<tagdetails> {
  late BuildContext ctx;
  List<dynamic> tagList = [];

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      Duration.zero,
      () {
        getTagSearch();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        backgroundColor: Clr().screenBackground,
        bottomNavigationBar: bottomNavigation(ctx, -1,setState),
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
        appBar: AppBar(
           backgroundColor: Clr().screenBackground,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                STM().back2Previous(ctx);
              },
              child: Icon(Icons.arrow_back, color: Clr().white)),
          title: Text('#${widget.details}',
              style: Sty().mediumText.copyWith(color: Clr().white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dim().d20, vertical: Dim().d12),
            child: Column(
              children: [
                ListView.builder(
                  itemCount: tagList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return itempostdetail(ctx, tagList[index], sID, setState,index);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  /// get tag bsearch
  void getTagSearch() async {
    FormData body = FormData.fromMap({
      'tag': widget.details,
    });
    var result = await STM().post(ctx, Str().loading, 'get-tag', body);
    if (result['success']) {
      setState(() {
        tagList = result['post'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}

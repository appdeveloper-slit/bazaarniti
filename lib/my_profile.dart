import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_profile_podcast.dart';
import 'adapter/item_profile_tweet.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class MyProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  const MyProfile(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyProfilePage();
  }
}

class MyProfilePage extends State<MyProfile>
    with SingleTickerProviderStateMixin {
  late BuildContext ctx;

  bool isLoaded = false;
  String? sID;

  Map<String, dynamic> v = {};

  Map<String, dynamic> d = {};

  List<String> tabList = [
    "My Post",
    "My Portfolio",
    "My Podcast",
  ];
  TabController? tabCtrl;

  @override
  void initState() {
    v = widget.data;
    getSessionData();
    tabCtrl = TabController(length: 3, vsync: this);
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData();
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': v['id'],
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "get-profile", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      d = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarMyProfile(ctx, '${v['name']}'),
      body: !isLoaded
          ? Container()
          : SingleChildScrollView(
              padding: EdgeInsets.all(
                Dim().d16,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Clr().accentColor,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(
                      Dim().d4,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Dim().d100,
                      ),
                      child: STM().imageView(
                        '${v['image']}',
                        width: Dim().d120,
                        height: Dim().d120,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Text(
                    '${v['name']}',
                    style: Sty().extraLargeText,
                  ),
                  Text(
                    '@${v['username']}',
                    style: Sty().mediumBoldText,
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Wrap(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${d['posts']}\n',
                          style: Sty().extraLargeText,
                          children: [
                            TextSpan(
                              text: 'Posts',
                              style: Sty().smallText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Dim().d32,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${d['followers']}\n',
                          style: Sty().extraLargeText,
                          children: [
                            TextSpan(
                              text: 'Followers',
                              style: Sty().smallText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Dim().d32,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${d['following']}\n',
                          style: Sty().extraLargeText,
                          children: [
                            TextSpan(
                              text: 'Following',
                              style: Sty().smallText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (d['user']['bio'] != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: Dim().d16,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/location.svg',
                            color: Clr().white,
                          ),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          Text(
                            '${d['user']['bio']}',
                            style: Sty().mediumText,
                          ),
                        ],
                      ),
                    ),
                  if (d['user']['location'] != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: Dim().d16,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/location.svg',
                          ),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          Text(
                            '${d['user']['location']}',
                            style: Sty().mediumText,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      onTap: (v) {
                        setState(() {
                          tabCtrl!.index = v;
                        });
                      },
                      controller: tabCtrl,
                      isScrollable: true,
                      labelColor: Clr().accentColor,
                      labelStyle: Sty().largeText,
                      unselectedLabelColor: Clr().white,
                      indicatorColor: Clr().transparent,
                      tabs: tabList
                          .map(
                            (e) => Tab(
                              text: e,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  if (tabCtrl!.index == 0) postLayout(),
                  if (tabCtrl!.index == 1) portfolioLayout(),
                  if (tabCtrl!.index == 2) podcastLayout(),
                  Container(),
                ],
              ),
            ),
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

  //For Post
  Widget postLayout() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: d['post'].length,
      itemBuilder: (context, index) {
        return itemProfileTweet(ctx, d['post'][index]);
      },
      separatorBuilder: (context, index) {
        return Column(
          children: [
            const Divider(
              color: Color(0xFFFFFFFF),
            ),
            SizedBox(
              height: Dim().d12,
            ),
          ],
        );
      },
    );
  }

  //For Portfolio
  Widget portfolioLayout() {
    return Column();
  }

  //For Podcast
  Widget podcastLayout() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: d['podcast'].length,
      itemBuilder: (context, index) {
        return itemProfilePodcast(ctx, d['podcast'][index]);
      },
    );
  }
}

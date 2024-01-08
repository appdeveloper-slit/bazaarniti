import 'package:bazaarniti/profileedit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adapter/item_home_tweet.dart';
import 'adapter/item_profile_podcast.dart';
import 'adapter/item_profile_tweet.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'follow_list.dart';
import 'manager/static_method.dart';
import 'message.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class anotherProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  const anotherProfile(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return anotherProfilePage();
  }
}

class anotherProfilePage extends State<anotherProfile>
    with SingleTickerProviderStateMixin {
  late BuildContext ctx;

  bool isLoaded = false;

  String? sID;
  List holdingList = [];
  Map<String, dynamic> v = {};

  Map<String, dynamic> d = {};

  List<String> tabList = [
    "Post",
    "Portfolio",
    "Podcast",
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
          portfoloi();
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

  /// portfolio
  void portfoloi() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'user_id': v['id'],
    });
    var result =
        await STM().postWithoutDialog(ctx, 'angel-one-get-holdings', body);
    if (result['response_data']['status'] == true) {
      setState(() {
        holdingList = result['response_data']['data']['holdings'];
      });
    } else {
      // STM().errorDialog(ctx, result['message']);
      // Fluttertoast.showToast(
      //     msg: result['message'],
      //     fontSize: Dim().d24,
      //     textColor: Clr().red,
      //     backgroundColor: Clr().white,
      //     gravity: ToastGravity.CENTER,
      //     toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarAnotherProfile('${v['name']}'),
      body: !isLoaded
          ? Container()
          : SingleChildScrollView(
              padding: EdgeInsets.all(
                Dim().d16,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
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
                            width: Dim().d100,
                            height: Dim().d100,
                          ),
                        ),
                      ),
                      // Positioned(
                      //     bottom: 2.0,
                      //     right: 15.0,
                      //     child: InkWell(
                      //       onTap: () {
                      //         STM().redirect2page(
                      //             ctx, profileEdit(detail: d, data: v));
                      //       },
                      //       child: Icon(
                      //         Icons.add_circle,
                      //         color: Clr().white,
                      //       ),
                      //     )),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Text(
                    '${v['name']}',
                    style: Sty().mediumBoldText,
                  ),
                  Text(
                    '@${v['username']}',
                    style: Sty().smallText,
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Wrap(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${d['posts']}\n',
                          style: Sty().mediumBoldText,
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
                      InkWell(
                        onTap: () {
                          STM().redirect2page(
                              ctx,
                              FollowList(
                                followersList: d['followers_list'],
                                i: 0,
                                name: v['name'],
                                followingList: d['following_list'],
                              ));
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${d['followers']}\n',
                            style: Sty().mediumBoldText,
                            children: [
                              TextSpan(
                                text: 'Followers',
                                style: Sty().smallText,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d32,
                      ),
                      InkWell(
                        onTap: () {
                          STM().redirect2page(
                              ctx,
                              FollowList(
                                  followingList: d['following_list'],
                                  name: v['name'],
                                  i: 1,
                                  followersList: d['followers_list']));
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${d['following']}\n',
                            style: Sty().mediumBoldText,
                            children: [
                              TextSpan(
                                text: 'Following',
                                style: Sty().smallText,
                              ),
                            ],
                          ),
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
                          // SvgPicture.asset(
                          //   'assets/location.svg',
                          //   color: Clr().white,
                          // ),
                          // SizedBox(
                          //   width: Dim().d12,
                          // ),
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
                    height: Dim().d32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          follow(ctx, d, v, setState, sID);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: Dim().d8,
                            horizontal: Dim().d20,
                          ),
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 1.5,
                            color: Clr().accentColor,
                          ),
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/follow.svg',
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Text(
                              !d['can_follow'] ? 'Unfollow' : 'Follow',
                              style: Sty().mediumText,
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          STM().redirect2page(ctx, Message(v));
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 1.5,
                            color: Clr().accentColor,
                          ),
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/message.svg',
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Text(
                              'Message',
                              style: Sty().mediumText,
                            ),
                          ],
                        ),
                      ),
                      if (d['user']['twitter_url'] != null)
                        OutlinedButton(
                          onPressed: () {
                            STM().openWeb(d['user']['twitter_url']);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: Dim().d8,
                              horizontal: Dim().d20,
                            ),
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              width: 1.5,
                              color: Clr().accentColor,
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/twitter.svg',
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                 d['user']['is_private'] == 1 ? Text('This account is private',style: Sty().mediumText,) : Align(
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
                  if (tabCtrl!.index == 0)  d['user']['is_private'] == 1 ? Container() : postLayout(),
                  if (tabCtrl!.index == 1) portfolioLayout(),
                  if (tabCtrl!.index == 2) podcastLayout(),
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
      bottomNavigationBar: bottomNavigation(ctx, -1, setState),
    );
  }

  //For Post
  Widget postLayout() {
    return Column(
      children: [
        if (d['post'].isEmpty)
          Text('No Post', style: Sty().mediumText.copyWith(color: Clr().white)),
        if (d['post'].isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: d['post'].length,
            itemBuilder: (context, index) {
              return itemHomeTweet(ctx, d['post'][index], sID, setState, index);
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
          ),
      ],
    );
  }

  //For Portfolio
  Widget portfolioLayout() {
    return Column(
      children: [
        if (holdingList.isNotEmpty)
          ListView.builder(
            itemCount: holdingList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: Dim().d12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0) textLayout('Holding', Clr().white),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          textLayout('${holdingList[index]['tradingsymbol']}',
                              Clr().white),
                        ],
                      ),
                    ),
                    SizedBox(width: Dim().d8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0) textLayout('LTP', Clr().white),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          textLayout(
                              '₹ ${holdingList[index]['ltp']}',
                              holdingList[index]['pnlpercentage']
                                      .toString()
                                      .contains('-')
                                  ? Clr().red
                                  : Clr().green),
                        ],
                      ),
                    ),
                    SizedBox(width: Dim().d8),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0) textLayout('PnL', Clr().white),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          textLayout(
                              'P/L : ${holdingList[index]['profitandloss']}',
                              Clr().white),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        if (holdingList.isEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: Dim().d100),
            child: Text('No Portfolio Data',
                style: Sty().mediumText.copyWith(color: Clr().white)),
          ),
      ],
    );
  }

  /// text Layout
  Widget textLayout(data, color) {
    return Text(data,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Sty().smallText.copyWith(color: color));
  }

  //For Podcast
  Widget podcastLayout() {
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     SizedBox(
    //       height: Dim().d28,
    //     ),
    //     Text('You need to request admin to make you avail the podcast feature ',
    //         textAlign: TextAlign.center,
    //         style: Sty().mediumText.copyWith(
    //             color: Clr().white,
    //             fontSize: Dim().d16,
    //             fontWeight: FontWeight.w400)),
    //     SizedBox(
    //       height: Dim().d12,
    //     ),
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: Dim().d28),
    //       child: ElevatedButton(
    //           onPressed: () {},
    //           style: ElevatedButton.styleFrom(
    //               backgroundColor: Clr().yellow,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(Dim().d8)),
    //               )),
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(vertical: Dim().d12),
    //             child: Center(
    //               child: Text('Send Request',
    //                   style: Sty().mediumText.copyWith(
    //                       color: Clr().white,
    //                       fontWeight: FontWeight.w600,
    //                       fontSize: Dim().d16)),
    //             ),
    //           )),
    //     ),
    //   ],
    // )
    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: Dim().d28),
    //   child: ElevatedButton(
    //       onPressed: () {},
    //       style: ElevatedButton.styleFrom(
    //           backgroundColor: Clr().yellow,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(Dim().d8)),
    //           )),
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(vertical: Dim().d12),
    //         child: Center(
    //           child: Text('CreateSeason',
    //               style: Sty().mediumText.copyWith(
    //                   color: Clr().white,
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: Dim().d16)),
    //         ),
    //       )),
    // );
    return Column(
      children: [
        if (d['podcast'].isEmpty)
          Text('No Podcast Found',
              style: Sty().mediumText.copyWith(color: Clr().white)),
        if (d['podcast'].isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: d['podcast'].length,
            itemBuilder: (context, index) {
              return itemProfilePodcast(ctx, d['podcast'][index]);
            },
          ),
      ],
    );
  }

  void follow(ctx, d, v, setState, sID) async {
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': v['id'],
    });
    //Output
    var result = await STM().postWithoutDialog(ctx, "follow", body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        if (d['can_follow']) {
          d['can_follow'] = false;
        } else {
          d['can_follow'] = true;
        }
      });
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}

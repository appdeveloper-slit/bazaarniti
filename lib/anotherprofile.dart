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
      appBar: toolbarAnotherProfile('${v['name']}'),
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
                            width: Dim().d120,
                            height: Dim().d120,
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
                            style: Sty().extraLargeText,
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
                            style: Sty().extraLargeText,
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
      bottomNavigationBar: bottomNavigation(ctx, -1,setState),
    );
  }

  //For Post
  Widget postLayout() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: d['post'].length,
      itemBuilder: (context, index) {
        return itemHomeTweet(ctx, d['post'][index], sID, setState,index);
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
      return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: d['podcast'].length,
      itemBuilder: (context, index) {
        return itemProfilePodcast(ctx, d['podcast'][index]);
      },
    );
  }

  void follow(ctx, d, v, setState, sID) async {
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': v['id'],
    });
    //Output
    var result = await STM().postWithoutDialog(ctx,"follow", body);
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

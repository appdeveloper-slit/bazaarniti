import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bazaarniti/profileedit.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher_channels_flutter/pusher-js/core/transports/url_schemes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adapter/item_home_tweet.dart';
import 'adapter/item_profile_podcast.dart';
import 'adapter/item_profile_tweet.dart';
import 'add_tweet.dart';
import 'bn_home.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'demat_login.dart';
import 'episode_list.dart';
import 'follow_list.dart';
import 'manager/static_method.dart';
import 'message.dart';
import 'podcast/podcastdetails.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'package:http/http.dart' as http;

class PublicProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  const PublicProfile(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PublicProfilePage();
  }
}

class PublicProfilePage extends State<PublicProfile>
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
  TextEditingController seasonNameCtrl = TextEditingController();
  TextEditingController desNameCtrl = TextEditingController();
  List<dynamic> languageList = [];
  List apiLanguageList = [];
  List podcastList = [];
  List holdingList = [];
  var languageType;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? clientId;
  bool? checkLogout;

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
          getLanguage();
          getPodcast();
          portifolia();
          getProfileDemat();
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

  /// send request for podcast
  sendRequest() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    //Output
    var result =
        await STM().post(ctx, Str().requesting, "send-podcast-request", body);
    if (result['success'] == true) {
      setState(() {
        d['user']['podcast_verified'] = 1;
        STM().displayToast(result['message']);
        getData();
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// send request for podcast
  getLanguage() async {
    var result = await STM().getWithoutDialog(ctx, "languages");
    if (result['success'] == true) {
      setState(() {
        apiLanguageList = result['data'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// getPodcast
  getPodcast() async {
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    var result = await STM().postWithoutDialog(ctx, "podcast-get", body);
    if (result['success'] == true) {
      setState(() {
        podcastList = result['data'];
      });
    } else {
      result['message'] == 'You are not verified for Get podcast'
          ? null
          : STM().errorDialog(ctx, result['message']);
    }
  }

  bool? textCheck;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: toolbarProfile(ctx, '${v['name']}',
            logout: checkLogout, clentid: clientId),
        body: !isLoaded
            ? Container()
            : SingleChildScrollView(
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Dim().d16,
                      right: Dim().d16,
                      top: Dim().d16,
                      bottom: Dim().d20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
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
                        ),
                        SizedBox(
                          height: Dim().d16,
                        ),
                        Center(
                          child: Text(
                            '${v['name']}',
                            style: Sty().mediumBoldText,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '@${v['username']}',
                              style: Sty().smallText,
                            ),
                            SizedBox(width: Dim().d8),
                            InkWell(
                                onTap: () {
                                  STM().redirect2page(
                                      ctx, profileEdit(detail: d, data: v));
                                },
                                child: SvgPicture.asset('assets/editpencil.svg',
                                    height: Dim().d16))
                          ],
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                      followingList: d['following_list'],
                                      followersList: d['followers_list'],
                                      name: v['name'],
                                      i: 0,
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
                                        followersList: d['followers_list'],
                                        i: 1,
                                        name: v['name'],
                                        followingList: d['following_list']));
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
                        SizedBox(height: Dim().d20),
                        if (d['user']['bio'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${d['user']['bio']}',
                                maxLines: null,
                                overflow: TextOverflow.fade,
                                style: Sty().mediumText,
                              ),
                            ],
                          ),
                        // if (d['user']['bio'] == null)
                        //   InkWell(
                        //       onTap: () {
                        //         STM().redirect2page(
                        //             ctx, profileEdit(detail: d, data: v));
                        //       },
                        //       child: Text('Add Your Bio',
                        //           style: Sty()
                        //               .smallText
                        //               .copyWith(color: Clr().white))),
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
                        SizedBox(height: Dim().d20),
                        // if (d['user']['location'] != null)
                        //   InkWell(
                        //       onTap: () {
                        //         STM().redirect2page(
                        //             ctx, profileEdit(detail: d, data: v));
                        //       },
                        //       child: Text('Add Your Location',
                        //           style: Sty()
                        //               .smallText
                        //               .copyWith(color: Clr().white))),
                        // SizedBox(
                        //   height: Dim().d32,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     OutlinedButton(
                        //       onPressed: () {},
                        //       style: OutlinedButton.styleFrom(
                        //         padding: EdgeInsets.symmetric(
                        //           vertical: Dim().d8,
                        //           horizontal: Dim().d20,
                        //         ),
                        //         shape: const StadiumBorder(),
                        //         side: BorderSide(
                        //           width: 1.5,
                        //           color: Clr().accentColor,
                        //         ),
                        //       ),
                        //       child: Wrap(
                        //         crossAxisAlignment: WrapCrossAlignment.center,
                        //         children: [
                        //           SvgPicture.asset(
                        //             'assets/follow.svg',
                        //           ),
                        //           SizedBox(
                        //             width: Dim().d12,
                        //           ),
                        //           Text(
                        //             'Follow',
                        //             style: Sty().mediumText,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     OutlinedButton(
                        //       onPressed: () {
                        //         STM().redirect2page(ctx, Message(v));
                        //       },
                        //       style: OutlinedButton.styleFrom(
                        //         shape: const StadiumBorder(),
                        //         side: BorderSide(
                        //           width: 1.5,
                        //           color: Clr().accentColor,
                        //         ),
                        //       ),
                        //       child: Wrap(
                        //         crossAxisAlignment: WrapCrossAlignment.center,
                        //         children: [
                        //           SvgPicture.asset(
                        //             'assets/message.svg',
                        //           ),
                        //           SizedBox(
                        //             width: Dim().d12,
                        //           ),
                        //           Text(
                        //             'Message',
                        //             style: Sty().mediumText,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     if (d['user']['twitter_url'] != null)
                        //       OutlinedButton(
                        //         onPressed: () {
                        //           STM().openWeb(d['user']['twitter_url']);
                        //         },
                        //         style: OutlinedButton.styleFrom(
                        //           padding: EdgeInsets.symmetric(
                        //             vertical: Dim().d8,
                        //             horizontal: Dim().d20,
                        //           ),
                        //           shape: const StadiumBorder(),
                        //           side: BorderSide(
                        //             width: 1.5,
                        //             color: Clr().accentColor,
                        //           ),
                        //         ),
                        //         child: SvgPicture.asset(
                        //           'assets/twitter.svg',
                        //         ),
                        //       ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: Dim().d16,
                        // ),
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
      ),
    );
  }

  //For Post
  Widget postLayout() {
    return Column(
      children: [
        if (d['post'].isEmpty)
          Center(child: Text('No Post', textAlign: TextAlign.center,style: Sty().mediumText.copyWith(color: Clr().white))),
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
    return d['user']['has_demat'] == 0 && d['user']['security'].isEmpty
        ? Padding(
            padding: EdgeInsets.only(
                bottom: Dim().d100, left: Dim().d56, right: Dim().d56),
            child: ElevatedButton(
                onPressed: () {
                  STM().redirect2page(ctx, const DematLogin());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Clr().yellow),
                child: Center(
                  child: Text('Log-in any demat account',
                      style: Sty().smallText.copyWith(color: Clr().white)),
                )),
          )
        : d['user']['has_demat'] == 1 &&
                d['user']['security'].isNotEmpty &&
                d['user']['security'][0]['is_login'] == 0
            ? Padding(
                padding: EdgeInsets.only(
                    bottom: Dim().d100, left: Dim().d40, right: Dim().d40),
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, const DematLogin());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().yellow,
                        padding: EdgeInsets.all(Dim().d12)),
                    child: Center(
                      child: Text('Log-in again to your demat account',
                          textAlign: TextAlign.center,
                          style: Sty().smallText.copyWith(
                              color: Clr().white, fontSize: Dim().d16)),
                    )),
              )
            : Column(
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
                                    if (index == 0)
                                      textLayout('Holding', Clr().white),
                                    SizedBox(
                                      height: Dim().d20,
                                    ),
                                    textLayout(
                                        '${holdingList[index]['tradingsymbol']}',
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
                                    if (index == 0)
                                      textLayout('LTP', Clr().white),
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
                                    if (index == 0)
                                      textLayout('PnL', Clr().white),
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
                ],
              );
  }

  //For Podcast
  Widget podcastLayout() {
    return d['user']['podcast_verified'] != 2
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Dim().d28,
              ),
              Text(
                  d['user']['podcast_verified'] == 1
                      ? '${d['user']['podcast_message']}'
                      : 'You need to request admin to make you avail the podcast feature ',
                  textAlign: TextAlign.center,
                  style: Sty().mediumText.copyWith(
                      color: Clr().white,
                      fontSize: Dim().d16,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: Dim().d12,
              ),
              d['user']['podcast_verified'] == 1
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d28),
                      child: ElevatedButton(
                          onPressed: () {
                            sendRequest();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(Dim().d8)),
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Dim().d12),
                            child: Center(
                              child: Text('Send Request',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dim().d16)),
                            ),
                          )),
                    ),
              SizedBox(
                height: Dim().d100,
              ),
            ],
          )
        : Column(
            children: [
              if (podcastList.isNotEmpty)
                ListView.builder(
                    itemCount: podcastList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          STM().redirect2page(
                              ctx,
                              EpisodeList(podcastList[index],
                                  details: widget.data));
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Dim().d28,
                                  ),
                                  Text(
                                    '${podcastList[index]['name']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Sty().mediumText.copyWith(
                                          color: Clr().white,
                                        ),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      if (podcastList[index]['episodes']
                                              .length !=
                                          0)
                                        Text(
                                          '${podcastList[index]['episodes'].length} Episodes',
                                          style: Sty()
                                              .mediumText
                                              .copyWith(color: Clr().white),
                                        ),
                                      if (podcastList[index]['episodes']
                                              .length !=
                                          0)
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                      listOfLanguage(
                                          podcastList[index]['languages']),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Text('${podcastList[index]['description']}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sty()
                                          .microText
                                          .copyWith(color: Clr().white)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: Dim().d32, color: Clr().white)
                          ],
                        ),
                      );
                    }),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d28),
                child: ElevatedButton(
                    onPressed: () {
                      podCastDailog();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(Dim().d8)),
                        )),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dim().d12),
                      child: Center(
                        child: Text('Create Season',
                            style: Sty().mediumText.copyWith(
                                color: Clr().white,
                                fontWeight: FontWeight.w600,
                                fontSize: Dim().d16)),
                      ),
                    )),
              ),
              SizedBox(
                height: Dim().d100,
              ),
            ],
          );
  }

  podCastDailog() {
    List addImg = [];
    return AwesomeDialog(
        context: ctx,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        dialogBackgroundColor: const Color(0xff11161E),
        dialogBorderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d56),
                child: Align(
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: seasonNameCtrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'SeasonName is required';
                      }
                    },
                    style: Sty().mediumText.copyWith(
                        color: Color(0xffFFC107),
                        fontSize: Dim().d28,
                        fontWeight: FontWeight.w500),
                    decoration: Sty().textFieldUnderlineStyle.copyWith(
                        hintText: 'Enter Season Name',
                        hintStyle: Sty()
                            .smallText
                            .copyWith(color: const Color(0xff898989))),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: desNameCtrl,
                    maxLength: 200,
                    maxLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description is required';
                      }
                    },
                    style: Sty().mediumText.copyWith(color: Clr().white),
                    decoration: Sty().textFieldUnderlineStyle.copyWith(
                        counterText: '',
                        hintText: 'Description',
                        hintStyle: Sty()
                            .smallText
                            .copyWith(color: const Color(0xff898989))),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: DropdownSearch.multiSelection(
                  items: apiLanguageList.map((value) {
                    return value['name'].toString();
                  }).toList(),
                  filterFn: (item, filter) {
                    return item
                        .toString()
                        .toLowerCase()
                        .startsWith(filter.toString().toLowerCase());
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Languages is required';
                    }
                  },
                  popupProps: const PopupPropsMultiSelection.menu(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: Sty()
                          .textFieldUnderlineStyle
                          .copyWith(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset('assets/laguage.svg',
                                    height: Dim().d24,
                                    width: Dim().d24,
                                    fit: BoxFit.fitWidth),
                              ),
                              hintText: 'Select Languages',
                              hintStyle: Sty()
                                  .smallText
                                  .copyWith(color: const Color(0xff898989)))),
                  onChanged: (k) {
                    setState(() {
                      addImg = k;
                    });
                  },
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d56),
                child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        languageList.clear();
                        for (int a = 0; a < addImg.length; a++) {
                          setState(() {
                            int pos = apiLanguageList.indexWhere((element) =>
                                element['name'].toString() ==
                                addImg[a].toString());
                            languageList.add(apiLanguageList[pos]['id']);
                          });
                        }
                        print(languageList);
                        podcastAddSeason();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().yellow,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dim().d8)))),
                    child: Center(
                      child: Text('ADD',
                          style: Sty().mediumText.copyWith(color: Clr().white)),
                    )),
              ),
              SizedBox(
                height: Dim().d20,
              ),
            ],
          ),
        )).show();
  }

  /// podcast season add
  podcastAddSeason() async {
    //Input
    FormData body = FormData.fromMap({
      "user_id": sID,
      "name": seasonNameCtrl.text,
      "description": desNameCtrl.text, //optional
      "languages": languageList
    }, ListFormat.multiCompatible);
    //Output
    var result = await STM().post(ctx, Str().requesting, "podcast-add", body);
    if (result['success'] == true) {
      STM().successDialogWithReplace(ctx, result['message'], widget);
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void portifolia() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'angel-one-get-holdings', body);
    if (result['response_data']['status'] == true) {
      setState(() {
        holdingList = result['response_data']['data']['holdings'];
      });
    }
  }

  void getProfileDemat() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'angel-one-get-profile', body);
    if (result['response_data']['status'] == true) {
      setState(() {
        clientId = result['response_data']['data']['clientcode'];
        checkLogout = true;
      });
    } else {
      setState(() {
        checkLogout = false;
      });
    }
  }

  /// text Layout
  Widget textLayout(data, color) {
    return Text(data,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Sty().smallText.copyWith(color: color));
  }
//   var data = {
//     "user_id": sID,
//     "name": seasonNameCtrl.text,
//     "description": desNameCtrl.text, //optional
//     "languages": languageList.toString()
//   };
//   var response = await http.post(
//       Uri.parse('https://lawmakers.co.in/bazaarniti/api/podcast-add'),
//       body: data);
//   if (response.statusCode == 200) {
//     var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
//     var itemCount = jsonResponse;
//     print(itemCount);
//   } else {
//     print('Request failed with status: ${response.statusCode}.');
//   }
// }
}

listOfLanguage(list) {
  List finalList = [];
  for (int a = 0; a < list.length; a++) {
    finalList.add(list[a]['name']);
  }
  return Text(
    '${finalList.toString().replaceAll('[', '').replaceAll(']', '')}',
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
    style: Sty().mediumText.copyWith(
          color: Clr().white,
        ),
  );
}

import 'package:bazaarniti/bn_home.dart';
import 'package:bazaarniti/values/strings.dart';
import 'package:dio/dio.dart';
import 'adapter/item_explore_people.dart';
import 'adapter/item_explore_tags.dart';
import 'adapter/item_people_to_follow.dart';
import 'ban_list.dart';
import 'values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adapter/item_faq.dart';
import 'adapter/item_header_detail.dart';
import 'adapter/item_home_tweet.dart';
import 'adapter/item_screener_list.dart';
import 'add_tweet.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'screener_list.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class Explore extends StatefulWidget {
  final name, type;

  const Explore({super.key, this.name, this.type});

  @override
  State<StatefulWidget> createState() {
    return ExplorePage();
  }
}

class ExplorePage extends State<Explore> with TickerProviderStateMixin {
  late BuildContext ctx;
  String? sID;
  List<String> tabList = [
    "Market",
    "Screener",
    "Learn",
  ];
  TabController? tabCtrl;
  List<dynamic> resultList = [];
  List<dynamic> peopletofollow = [];
  List<dynamic> faqList = [];
  List<dynamic> screenerList = [
    {
      'id': 0,
      'name': 'Your Saved Screeners',
      'image': 'assets/scr0.png',
    },
    {
      'id': 1,
      'name': 'Stocks in Action',
      'image': 'assets/scr1.png',
    },
    {
      'id': 2,
      'name': 'Breakouts',
      'image': 'assets/scr2.png',
    },
    {
      'id': 3,
      'name': 'Breakdown',
      'image': 'assets/scr3.png',
    },
    {
      'id': 4,
      'name': '52 Weak High',
      'image': 'assets/scr4.png',
    },
    {
      'id': 5,
      'name': '52 Weak Low',
      'image': 'assets/scr5.png',
    },
    {
      'id': 6,
      'name': 'Straddle',
      'image': 'assets/scr6.png',
    },
    {
      'id': 7,
      'name': 'OI Analysis',
      'image': 'assets/scr7.png',
    },
    {
      'id': 8,
      'name': 'FNO BanList',
      'image': 'assets/scr8.png',
    },
    {
      'id': 9,
      'name': 'Index Movers',
      'image': 'assets/scr9.png',
    },
  ];
  List<dynamic> learnList = [
    {
      'id': 1,
      'name': 'Nifty',
      'color': const Color(0xFFF5C2E9),
    },
    {
      'id': 2,
      'name': 'Bank Nifty',
      'color': const Color(0xFFCDC2F5),
    },
    {
      'id': 3,
      'name': 'Fin Nifty',
      'color': const Color(0xFFC2DDF5),
    },
  ];
  TextEditingController searchCtrl = TextEditingController();
  bool isSearch = false;
  List<String> tab2List = [
    "Stock",
    "People",
    "Tags",
  ];
  TabController? tab2Ctrl;
  List<dynamic> stockList = [
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
  List<dynamic> peopleList = [];
  String? peopleResult, tagsResult;
  List<dynamic> tagsList = [];

  @override
  void initState() {
    getSessionData();
    tabCtrl = TabController(length: 3, vsync: this);
    tab2Ctrl = TabController(length: 3, vsync: this);
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
      widget.type == 'search'
          ? searchCtrl = TextEditingController(text: widget.name)
          : null;
      widget.type == 'search' ? getExploreSearch(widget.name) : null;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getExplorePage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        if (widget.type == 'search') {
          STM().finishAffinity(ctx, Home());
        } else {
          SharedPreferences sp = await SharedPreferences.getInstance();
          if (!mounted) return true;
          var list = sp.getStringList('stack');
          var i = list!.indexWhere((e) => e == '1');
          var position = list[i - 1];
          STM().switchCondition(ctx, position);
          list.removeAt(i);
          sp.setStringList('stack', list);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().screenBackground,
          leading: InkWell(onTap: (){
            STM().finishAffinity(ctx, Home());
          },child: Icon(Icons.arrow_back,color: Clr().white)),
          centerTitle: true,
          title: Text('Explore',style: Sty().mediumText),
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Dim().d12,
              ),
              child: IconButton(
                onPressed: () {
                  STM().redirect2page(ctx, BanList());
                },
                padding: EdgeInsets.zero,
                splashRadius: 24,
                icon: SvgPicture.asset(
                  'assets/star.svg',
                ),
              ),
            ),
          ],
        ),//toolbarBottomNavigation(ctx, 1, 'Explore', b: true),
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
        bottomNavigationBar: bottomNavigation(ctx, 1,setState),
      ),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          STM().searchField(searchCtrl, (v) {
            v != '' ? getExploreSearch(v) : null;
          }),
          SizedBox(
            height: Dim().d16,
          ),
          isSearch ? searchLayout() : bodyLayout2(),
        ],
      ),
    );
  }

  //Body2 Layout
  Widget bodyLayout2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: STM().tabBar(
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
              });
            },
            isScrollable: false,
          ),
        ),
        SizedBox(
          height: Dim().d32,
        ),
        if (tabCtrl!.index == 0) marketLayout(),
        if (tabCtrl!.index == 1) screenerLayout(),
        if (tabCtrl!.index == 2) learnLayout(),
      ],
    );
  }

  //For Market
  Widget marketLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'people to follow',
          style: Sty().largeText,
        ),
        SizedBox(
          height: Dim().d12,
        ),
        SizedBox(
          height: Dim().d350,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: peopletofollow.length,
            itemBuilder: (context, index) {
              return itemPeopleToFollow(ctx, peopletofollow[index]);
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
        ),
        SizedBox(
          height: Dim().d12,
        ),
        Text(
          'This Week’s Highlights',
          style: Sty().largeText,
        ),
        SizedBox(
          height: Dim().d12,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: resultList.length,
          itemBuilder: (context, index) {
            return itemHomeTweet(ctx, resultList[index], sID, setState, index);
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
        Text(
          'Frequently ask questions',
          style: Sty().largeText,
        ),
        SizedBox(
          height: Dim().d12,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            return itemFAQ(ctx, faqList[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: Dim().d12,
            );
          },
        ),
      ],
    );
  }

  //For Screener
  Widget screenerLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 175,
          ),
          itemCount: screenerList.length,
          itemBuilder: (context, index) {
            var v = screenerList[index];
            return InkWell(
              onTap: () {
                STM().redirect2page(ctx, ScreenerList(v));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF292929,
                  ),
                  borderRadius: BorderRadius.circular(
                    Dim().d12,
                  ),
                ),
                margin: EdgeInsets.all(
                  Dim().d4,
                ),
                padding: EdgeInsets.all(
                  Dim().d12,
                ),
                child: Column(
                  children: [
                    STM().imageView(
                      v['image'],
                      height: Dim().d80,
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      '${v['name']}',
                      style: Sty().largeText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(
              0xFF292929,
            ),
            borderRadius: BorderRadius.circular(
              Dim().d12,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dim().d60,
            horizontal: Dim().d12,
          ),
          child: Text(
            'MORE COMING SOON',
            style: Sty().extraLargeText.copyWith(
                  color: Clr().accentColor,
                  fontSize: 32,
                ),
          ),
        ),
        SizedBox(
          height: Dim().d100,
        ),
      ],
    );
  }

  //For Learn
  Widget learnLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(ctx).size.height / 1.7,
          alignment: Alignment.bottomCenter,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(),
            itemCount: learnList.length,
            itemBuilder: (context, index) {
              return itemScreenerList(ctx, learnList[index], b: true);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: Dim().d12,
              );
            },
          ),
        )
      ],
    );
  }

  //Search Layout
  Widget searchLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: STM().tabBar(
            tab2Ctrl,
            tab2List
                .map(
                  (e) => Tab(
                    text: e,
                  ),
                )
                .toList(),
            (v) {
              setState(() {
                tab2Ctrl!.index = v;
              });
            },
            isScrollable: false,
          ),
        ),
        SizedBox(
          height: Dim().d32,
        ),
        if (tab2Ctrl!.index == 0) stockLayout(),
        if (tab2Ctrl!.index == 1) peopleLayout(),
        if (tab2Ctrl!.index == 2) tagsLayout(),
      ],
    );
  }

  //For Stock
  Widget stockLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stockList.length,
          itemBuilder: (context, index) {
            return itemHeaderDetail(ctx, stockList[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: Dim().d12,
            );
          },
        ),
      ],
    );
  }

  //For People
  Widget peopleLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        peopleResult != null
            ? Center(
                child: Text(peopleResult!,
                    style: Sty().smallText.copyWith(color: Clr().white)),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: peopleList.length,
                itemBuilder: (context, index) {
                  return itemExplorePeople(ctx, peopleList[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: Dim().d12,
                  );
                },
              ),
      ],
    );
  }

  //For Tags
  Widget tagsLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tagsList.length,
          itemBuilder: (context, index) {
            return itemExploreTags(ctx, tagsList[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: Dim().d12,
            );
          },
        ),
      ],
    );
  }

  /// get explore-search api
  void getExploreSearch(v) async {
    FormData body = FormData.fromMap({
      'search_value': v,
    });
    var result = await STM().post(ctx, Str().searching, 'explore-search', body);
    if (result['success']) {
      setState(() {
        if (result['users'].runtimeType == peopleList.runtimeType) {
          peopleResult = null;
          peopleList = result['users'];
        } else {
          peopleResult = result['users']['message'];
        }
        if (result['hashtags'].runtimeType == tagsList.runtimeType) {
          tagsResult = null;
          tagsList = result['hashtags'];
        } else {
          tagsResult = result['users']['message'];
        }
        if (peopleList.isNotEmpty) {
          setState(() {
            tab2Ctrl!.index = 1;
          });
        } else if (tagsList.isNotEmpty) {
          setState(() {
            tab2Ctrl!.index = 2;
          });
        }else{
          setState(() {
            tab2Ctrl!.index = 0;
          });
        }
        isSearch = true;
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// get explore page
  void getExplorePage() async {
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    var result = await STM().post(ctx, Str().loading, 'explore-page', body);
    if (result['success'] == true) {
      setState(() {
        peopletofollow = result['people_to_follow'];
        resultList = result['hightlighted_posts'];
        faqList = result['frequently_asks'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}

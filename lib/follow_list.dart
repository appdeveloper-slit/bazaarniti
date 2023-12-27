import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adapter/item_follower.dart';
import 'adapter/item_following.dart';
import 'add_tweet.dart';
import 'anotherprofile.dart';
import 'bn_home.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manager/static_method.dart';
import 'public_profile.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class FollowList extends StatefulWidget {
  final followersList, followingList, i, name;

  const FollowList(
      {Key? key, this.followersList, this.followingList, this.i, this.name})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FollowListPage();
  }
}

class FollowListPage extends State<FollowList> with TickerProviderStateMixin {
  late BuildContext ctx;

  TextEditingController searchCtrl = TextEditingController();

  List<String> tabList = ["Followers", "Following"];
  TabController? tabCtrl;

  List<dynamic> followerList = [];
  List<dynamic> followersAnotherList = [];

  List<dynamic> followingList = [];
  List<dynamic> followingAnotherList = [];

  Map<String, dynamic> v = {};

  @override
  void initState() {
    tabCtrl = TabController(length: 2, vsync: this);
    tabCtrl!.index = widget.i;
    for (int a = 0; a < widget.followersList.length; a++) {
      followerList.add(
        {
          'id': widget.followersList[a]['follower']['id'],
          'username': '@${widget.followersList[a]['follower']['username']}',
          'name': widget.followersList[a]['follower']['name'],
          'image': widget.followersList[a]['follower']['image'],
        },
      );
    }
    for (int a = 0; a < widget.followingList.length; a++) {
      followingList.add(
        {
          'id': widget.followingList[a]['user']['id'],
          'username': '@${widget.followingList[a]['user']['username']}',
          'name': widget.followingList[a]['user']['name'],
          'image': widget.followingList[a]['user']['image'],
        },
      );
    }
    followersAnotherList = followerList;
    followingAnotherList = followingList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: toolbarWithTitleLayout(ctx, '${widget.name}'),
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
      bottomNavigationBar: bottomNavigation(ctx, 1),
    );
  }

  //Body Layout
  Widget bodyLayout() {
    return Padding(
      padding: EdgeInsets.all(
        Dim().pp2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            cursorColor: Clr().white,
            style: Sty().mediumText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: Sty().textFieldWhiteOutlineStyle.copyWith(
                hintStyle: Sty().mediumText.copyWith(color: Clr().hintColor),
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: Clr().white)),
            validator: (value) {
              if (value!.isEmpty) {
                return Str().invalidEmpty;
              } else {
                return null;
              }
            },
            onChanged: (v) {
              if (tabCtrl!.index == 0) {
                setState(() {
                  followerList = followersAnotherList.where((element) {
                    final resultTitle =
                        element['name'].toString().toLowerCase();
                    final input = v.toString().toLowerCase();
                    return resultTitle.toString().startsWith(input);
                  }).toList();
                });
              } else {
                setState(() {
                  followingList = followingAnotherList.where((element) {
                    final resultTitle =
                        element['name'].toString().toLowerCase();
                    final input = v.toString().toLowerCase();
                    return resultTitle.toString().startsWith(input);
                  }).toList();
                });
              }
            },
          ),
          SizedBox(
            height: Dim().d16,
          ),
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
          if (tabCtrl!.index == 0) followerLayout(),
          if (tabCtrl!.index == 1) followingLayout(),
        ],
      ),
    );
  }

  //For Market
  Widget followerLayout() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: followerList.length,
      itemBuilder: (context, index) {
        return itemFollower(ctx, followerList[index], sID);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: Dim().d12,
        );
      },
    );
  }

  //For Screener
  Widget followingLayout() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: followingList.length,
      itemBuilder: (context, index) {
        return itemFollowing(ctx, followingList[index], sID);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: Dim().d12,
        );
      },
    );
  }

  Widget itemFollowing(ctx, v, sID) {
    return ListTile(
      onTap: () {
        int.parse(sID) == int.parse(v['user_id'].toString())
            ? STM().redirect2page(
                ctx,
                PublicProfile(v['user']),
              )
            : STM().redirect2page(
                ctx,
                anotherProfile(v['user']),
              );
      },
      contentPadding: EdgeInsets.symmetric(
        vertical: Dim().d8,
        horizontal: Dim().pp,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Dim().d56)),
        child: STM().imageView(
          '${v['image']}',
          width: Dim().d60,
          height: Dim().d60,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${v['name']}',
            style: Sty().mediumText,
          ),
          Text(
            '${v['username']}',
            style: Sty().smallText.copyWith(
                  color: const Color(0xFF898989),
                ),
          ),
        ],
      ),
      trailing: STM().button('Following', () {},
          width: Dim().d80,
          height: Dim().d32,
          color: Clr().accentColor,
          b: false,
          style: 'small'),
    );
  }

  Widget itemFollower(ctx, v, sID) {
    return ListTile(
      onTap: () {
        int.parse(sID) == int.parse(v['user_id'].toString())
            ? STM().redirect2page(
                ctx,
                PublicProfile(v['user']),
              )
            : STM().redirect2page(
                ctx,
                anotherProfile(v['user']),
              );
      },
      contentPadding: EdgeInsets.symmetric(
        vertical: Dim().d8,
        horizontal: Dim().pp,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Dim().d56)),
        child: STM().imageView(
          '${v['image']}',
          width: Dim().d60,
          height: Dim().d60,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${v['name']}',
            style: Sty().mediumText,
          ),
          Text(
            '${v['username']}',
            style: Sty().smallText.copyWith(
                  color: const Color(0xFF898989),
                ),
          ),
        ],
      ),
      trailing: STM().button('Remove', () {},
          width: Dim().d80,
          height: Dim().d32,
          color: Clr().accentColor,
          b: false,
          style: 'small'),
    );
  }
}

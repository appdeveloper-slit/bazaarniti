import 'package:bazaarniti/login.dart';
import 'package:bazaarniti/profileedit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ban_list.dart';
import '../bn_home.dart';
import '../conversation.dart';
import '../manager/static_method.dart';
import '../public_profile.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

PreferredSizeWidget toolbarWithBackLayout() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
  );
}

PreferredSizeWidget toolbarWithTitleLayout(ctx, title, {b = false}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
    centerTitle: true,
    title: Text(
      '$title',
      style: Sty().largeText,
    ),
    actions: [
      if (b)
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
  );
}

PreferredSizeWidget toolbarBottomNavigation(ctx, index, title, {b = false}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        var list = sp.getStringList('stack');
        var i = list!.indexWhere((e) => e == '$index');
        var position = list[i - 1];
        STM().switchCondition(ctx, position);
        list.removeAt(i);
        sp.setStringList('stack', list);
      },
      iconSize: 32,
      splashRadius: Dim().d20,
      icon: SvgPicture.asset(
        'assets/back_arrow.svg',
      ),
    ),
    centerTitle: true,
    title: Text(
      '$title',
      style: Sty().largeText,
    ),
    actions: [
      if (b)
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
  );
}

PreferredSizeWidget toolbarHeader() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
    centerTitle: true,
    title: STM().imageView(
      'assets/txt_logo_white.png',
      height: Dim().d32,
    ),
    actions: [
      IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        splashRadius: 24,
        icon: SvgPicture.asset(
          'assets/star.svg',
        ),
      ),
    ],
  );
}

PreferredSizeWidget toolbarProfile(ctx,title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: InkWell(onTap: (){
      STM().finishAffinity(ctx, Home());
    },child: Icon(Icons.arrow_back,color: Clr().white,)),
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
    centerTitle: true,
    title: Text(
      '$title',
      style: Sty().largeText,
    ),
    actions: [
      // IconButton(
      //   onPressed: () {},
      //   padding: EdgeInsets.zero,
      //   splashRadius: 24,
      //   icon: SvgPicture.asset(
      //     'assets/notification.svg',
      //   ),
      // ),
      PopupMenuButton<String>(
        onSelected: (value) async{
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.clear();
          value == 'option_1' ? STM().finishAffinity(ctx, Login()) : null;
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'option_1',
              child: Text('Logout'),
            ),
            // PopupMenuItem<String>(
            //   value: 'option_2',
            //   child: Text('Option 2'),
            // ),
            // PopupMenuItem<String>(
            //   value: 'option_3',
            //   child: Text('Option 3'),
            // ),
          ];
        },
      ),
      // IconButton(
      //   onPressed: () {
      //
      //   },
      //   padding: EdgeInsets.zero,
      //   splashRadius: 24,
      //   icon: SvgPicture.asset(
      //     'assets/more.svg',
      //   ),
      // ),
    ],
  );
}

PreferredSizeWidget toolbarAnotherProfile(title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
    centerTitle: true,
    title: Text(
      '$title',
      style: Sty().largeText,
    ),
    actions: [
      IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        splashRadius: 24,
        icon: SvgPicture.asset(
          'assets/bell.svg',
        ),
      ),
      IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        splashRadius: 24,
        icon: SvgPicture.asset(
          'assets/more.svg',
        ),
      ),
    ],
  );
}

PreferredSizeWidget commonAppBar(title,ctx,data){
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: InkWell(onTap: (){
      STM().replacePage(ctx, PublicProfile(data));
    },child: Icon(Icons.arrow_back,color: Clr().white,)),
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
    centerTitle: true,
    title: Text(
      '$title',
      style: Sty().largeText,
    ),
  );
}

PreferredSizeWidget toolbarMyProfile(ctx, title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().white,
    ),
    centerTitle: true,
    title: Text(
      '$title',
      style: Sty().largeText,
    ),
    actions: [
      PopupMenuButton(
        padding: EdgeInsets.zero,
        splashRadius: 24,
        icon: SvgPicture.asset(
          'assets/more.svg',
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text(
              'Edit',
              style: Sty().mediumText.copyWith(
                    color: Clr().black,
                  ),
            ),
            value: "edit",
          ),
        ],
        onSelected: (value) async {
          if (value == "edit") {
            STM().redirect2page(ctx, profileEdit());
          }
        },
      ),
    ],
  );
}

PreferredSizeWidget toolbarHome(ctx, v) {
  return AppBar(
    toolbarHeight: Dim().d60,
    backgroundColor: Clr().black,
    leading: Transform.translate(
      offset: Offset(Dim().d12, Dim().d0),
      child: IconButton(
        onPressed: () async {
          STM().redirect2page(ctx, PublicProfile(v));
        },
        icon: STM().roundImage(
          '${v['image']}',
          width: Dim().d40,
          height: Dim().d40,
        ),
      ),
    ),
    centerTitle: true,
    title: STM().imageView(
      'assets/txt_logo_white.png',
      height: Dim().d40,
    ),
    actions: [
      Transform.translate(
        offset: Offset(-Dim().d8, Dim().d0),
        child: IconButton(
          onPressed: () {
            STM().redirect2page(ctx, const Conversation());
          },
          icon: SvgPicture.asset(
            'assets/chat.svg',
            height: Dim().d24,
          ),
        ),
      ),
    ],
  );
}

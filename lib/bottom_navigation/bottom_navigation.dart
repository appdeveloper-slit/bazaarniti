import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../adapter/audio_player_buttons.dart';
import '../adapter/playbutton.dart';
import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';

Widget bottomNavigation(ctx, index, setState) {
  var iconList = [
    'assets/bn_home.svg',
    'assets/bn_explore.svg',
    'assets/bn_mic.svg',
    'assets/bn_notification.svg',
  ];
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (index, active) {
          return Padding(
            padding: EdgeInsets.all(
              Dim().d16,
            ),
            child: SvgPicture.asset(
              iconList[index],
              color: active ? Clr().accentColor : Clr().white,
            ),
          );
        },
        backgroundColor: Clr().black,
        activeIndex: index,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        onTap: (i) async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          if (i != 0) {
            var list = sp.getStringList('stack') ?? ['0'];
            if (list.contains('$i')) {
              list.removeWhere((e) => e == '$i');
              list.add('$i');
            } else {
              list.add('$i');
            }
            sp.setStringList('stack', list);
          }
          STM().switchCondition(ctx, i.toString());
        },
        // shadow: const BoxShadow(
        //   offset: Offset(0, 2),
        //   blurRadius: 12,
        //   spreadRadius: 0.5,
        //   color: Colors.white,
        // ),
      ),
      // selectFromPlayButton == true
      //     ? Container(
      //       width: double.infinity,
      //       decoration: BoxDecoration(
      //           color: Clr().black,
      //           border: Border(
      //             top: BorderSide(
      //               color: Clr().white,
      //               width: 0.2,
      //             ),
      //             bottom: BorderSide(
      //               color: Clr().white,
      //               width: 0.2,
      //             ),
      //           )),
      //       child: Row(
      //         children: [
      //           SizedBox(width: Dim().d12),
      //           InkWell(
      //             onTap: (){
      //               STM().redirect2page(
      //                   ctx,
      //                   playButton(
      //                     details: details,
      //                     v: musicdetails,
      //                   ));
      //             },
      //             child: ClipRRect(
      //               borderRadius: BorderRadius.all(Radius.circular(Dim().d8)),
      //               child: Image.network(
      //                 'https://img.freepik.com/free-vector/detailed-podcast-logo-template_23-2148786067.jpg',
      //                 height: Dim().d52,
      //                 width: Dim().d52,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             width: Dim().d12,
      //           ),
      //           Expanded(
      //             child: InkWell(
      //               onTap: (){
      //                 STM().redirect2page(
      //                     ctx,
      //                     playButton(
      //                       details: details,
      //                       v: musicdetails,
      //                     ));
      //               },
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text('${title}',
      //                       style: Sty()
      //                           .mediumText
      //                           .copyWith(color: Clr().white)),
      //                   Text('${albumname}',
      //                       style: Sty()
      //                           .mediumText
      //                           .copyWith(color: Clr().white)),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //               width: Dim().d32,
      //               child: PlayerButtons(
      //                   audioPlayer: audioPlayer, check: true)),
      //           SizedBox(
      //             width: Dim().d16,
      //           ),
      //           IconButton(
      //               onPressed: () {
      //                 setState(() {
      //                   audioPlayer.pause();
      //                   selectFromPlayButton = false;
      //                 });
      //               },
      //               icon: Icon(Icons.stop,
      //                   color: Clr().white, size: Dim().d32)),
      //           SizedBox(
      //             width: Dim().d32,
      //           ),
      //         ],
      //       ),
      //     )
      //     : Container(),
    ],
  );
}

import 'package:bazaarniti/adapter/playbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import '../episode_list.dart';
import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

late AudioPlayer audioPlayer;
bool isPlaying = false;

Widget itemEpisode(ctx, v,details) {
  return InkWell(
    onTap: () {
      STM().redirect2page(ctx, playButton(v: v,details: details,));
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF292929,
        ),
        borderRadius: BorderRadius.circular(
          Dim().d8,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: Dim().d12,
      ),
      padding: EdgeInsets.all(
        Dim().d8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${v['name']}',
                  style: Sty().largeText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Text(
                  '${DateFormat('dd MMM yy').format(DateTime.parse(v['created_at'].toString()))} | ',
                  style: Sty().microText,
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dim().d12,
          ),
          SvgPicture.asset(
            'assets/play.svg',
          ),
        ],
      ),
    ),
  );
}

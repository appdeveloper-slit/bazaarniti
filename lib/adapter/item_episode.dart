import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bazaarniti/adapter/playbutton.dart';
import 'package:bazaarniti/values/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import '../bn_home.dart';
import '../episode_list.dart';
import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
bool isPlaying = false;
Widget itemEpisode(ctx, v, details) {
  return InkWell(
    onTap: () {
      STM().redirect2page(
          ctx,
          playButton(
            v: v,
            details: details,
          ));
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
                  '${DateFormat('dd MMM yy').format(DateTime.parse(v['created_at'].toString()))}',
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
          SizedBox(
            width: Dim().d12,
          ),
          int.parse(details['user_id'].toString()) == int.parse(sID.toString())
              ? InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: ctx,
                      borderSide: BorderSide.none,
                      dialogBorderRadius: BorderRadius.all(
                        Radius.circular(Dim().d16),
                      ),
                      dialogType: DialogType.noHeader,
                      padding: EdgeInsets.zero,
                      animType: AnimType.scale,
                      body: Column(
                        children: [
                          Text('Are you sure want to delete this?',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().black)),
                          SizedBox(
                            height: Dim().d36,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      deleteEp(v['id'], ctx);
                                      STM().back2Previous(ctx);
                                    },
                                    child: Text('Yes',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().black))),
                                SizedBox(
                                  width: Dim().d32,
                                ),
                                InkWell(
                                    onTap: () {
                                      STM().back2Previous(ctx);
                                    },
                                    child: Text('No',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().black))),
                                SizedBox(
                                  width: Dim().d20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).show();
                  },
                  child:
                      Icon(Icons.delete_outline_outlined, color: Clr().white))
              : Container(),
        ],
      ),
    ),
  );
}

void deleteEp(id, ctx) async {
  FormData body = FormData.fromMap({
    'episode_id': id,
  });
  var result = await STM().postWithoutDialog(ctx, 'delete-episode', body);
  var success = result['success'];
  var message = result['message'];
  if (success) {
    STM().successDialogWithAffinity(ctx, message, Home());
  } else {
    STM().errorDialog(ctx, message);
  }
}

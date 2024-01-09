import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../bn_home.dart';
import '../manager/static_method.dart';
import '../values/colors.dart';

Widget itemPeopleToFollow(ctx, v,setState) {
  return Padding(
    padding:  EdgeInsets.only(right: Dim().d12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: Dim().d120,
          width: Dim().d120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Clr().white,
          ),
          child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dim().d56)),child: Image.network('${v['image']}', fit: BoxFit.cover)),
        ),
        SizedBox(
          height: Dim().d4,
        ),
        Text('${v['name']}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Sty().mediumText.copyWith(color: Clr().white)),
        SizedBox(
          height: Dim().d4,
        ),
        InkWell(
          onTap: (){
            follow(ctx, v, setState);
          },
          child: Text(v['can_follow'] == true ? 'Followed' : 'Follow',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Sty().mediumText.copyWith(color: const Color(0xff3091EE))),
        ),
      ],
    ),
  );
}

//Api method
void follow(ctx, v, setState) async {
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
      if (v['can_follow'] == true) {
        v['can_follow'] = false;
      } else {
        v['can_follow'] = true;
      }
    });
    STM().displayToast(message);
  } else {
    STM().errorDialog(ctx, message);
  }
}
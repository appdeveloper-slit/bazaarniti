import 'demat_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adapter/item_demat_login.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class DematLogin extends StatefulWidget {
  const DematLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DematLoginPage();
  }
}

class DematLoginPage extends State<DematLogin> {
  late BuildContext ctx;

  List<dynamic> resultList = [
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Angel One',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': '5Paisa',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'HDFC Sec',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Kotak Sec',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Angel One',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': '5Paisa',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'HDFC Sec',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Kotak Sec',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Angel One',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': '5Paisa',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'HDFC Sec',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Kotak Sec',
    },
  ];

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          SizedBox(
            height: Dim().d28,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                STM().back2Previous(ctx);
              },
              icon: SvgPicture.asset(
                'assets/close.svg',
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Log in with your broker',
              style: Sty().mediumText.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: Dim().d120,
            ),
            itemCount: 1,
            itemBuilder: (context, index) {
              return itemDematLogin(ctx, resultList[4]);
            },
          ),
          TextButton(
            onPressed: () {
              STM().replacePage(ctx, const DematRegister());
            },
            child: Text(
              'Don’t have a Demat Account?',
              style: Sty().mediumText.copyWith(
                    color: Clr().accentColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

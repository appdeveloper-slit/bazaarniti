import 'demat_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adapter/item_demat_register.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class DematRegister extends StatefulWidget {
  const DematRegister({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DematRegisterPage();
  }
}

class DematRegisterPage extends State<DematRegister> {
  late BuildContext ctx;

  List<dynamic> resultList = [
    {
      'image': 'assets/dummy_broker.png',
      'name': 'IIFL',
      'points': '● Account opening fee ₹0\n● Active clients 91 Lakh+',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tellus, erat risus sit in ultrices cras. Enim ipsum lacus, mi eleifend mauris at',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Angel One',
      'points': '● Account opening fee ₹0\n● Active clients 91 Lakh+',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tellus, erat risus sit in ultrices cras. Enim ipsum lacus, mi eleifend mauris at',
    },
    {
      'image': 'assets/dummy_broker.png',
      'name': 'Kotak Securities',
      'points': '● Account opening fee ₹0\n● Active clients 91 Lakh+',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tellus, erat risus sit in ultrices cras. Enim ipsum lacus, mi eleifend mauris at',
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
              'pick your broker',
              style: Sty().mediumText.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,//resultList.length,
            itemBuilder: (context, index) {
              return itemDematRegister(ctx, resultList[1]);
            },
          ),
          TextButton(
            onPressed: () {
              STM().replacePage(ctx, const DematLogin());
            },
            child: Text(
              'I already have a Demat Account',
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

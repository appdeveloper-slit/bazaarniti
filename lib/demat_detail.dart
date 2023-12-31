import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class DematDetail extends StatefulWidget {
  final String sType;

  const DematDetail(this.sType, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DematDetailPage();
  }
}

class DematDetailPage extends State<DematDetail> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: toolbarWithBackLayout(),
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
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'open your free demat account with ',
              style: Sty().extraLargeText,
              children: [
                TextSpan(
                  text: '${widget.sType}',
                  style: Sty().extraLargeText.copyWith(
                        color: Clr().accentColor,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Container(
            width: MediaQuery.of(ctx).size.width,
            decoration: BoxDecoration(
              color: const Color(0x80323232),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(
                Dim().d8,
              ),
            ),
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep following documents ready',
                  style: Sty().largeText.copyWith(
                        color: Clr().accentColor,
                      ),
                ),
                Text(
                  '● PAN Card\n● Cancelled Cheque/ Bank Passbook/ Bank\n   Statement\n● Aadhar Card\n● Signature on a white paper',
                  style: Sty().smallText.copyWith(
                        height: 1.8,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dim().d32,
          ),
          STM().button(
            'continue',
            () async {
              STM().openWeb(
                  'https://www.angelone.in/sem/open-demat-account?gclsrc=aw.ds&&utm_campaign=B2C_Search_Brand_Search_Query_Exact_Desktop&utm_source=google&utm_medium=cpc&network=g&keyword=angel%20trading&matchtype=e&creative=538016055573&device=c&devicemodel=&gad_source=1&gclid=CjwKCAiAqNSsBhAvEiwAn_tmxYHopQ0kbUUEZk0OSpucJuskWGIULsXdZeuNtQn8m_9RhZU694IofBoCA5MQAvD_BwE');
              // SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}

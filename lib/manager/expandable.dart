import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'static_method.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText(this.text, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExpandableTextPage();
  }
}

class ExpandableTextPage extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.text.length < 80;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSize(
          // vsync: this,
          duration: const Duration(
            milliseconds: 200,
          ),
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                : BoxConstraints(
                    maxHeight: Dim().d36,
                  ),
            child: Html(
              data: widget.text,
              shrinkWrap: true,
              style: {
                'body': Style(
                  margin: Margins.zero,
                  padding: EdgeInsets.zero,
                  fontFamily: 'Regular',
                  letterSpacing: 0.5,
                  color: const Color(0xFF626262),
                  fontSize: FontSize(14.0),
                  textOverflow: TextOverflow.fade,
                ),
              },
              onLinkTap: (url, context, attrs, element) {
                STM().openWeb(url!);
              },
            ),
          ),
        ),
        if (!isExpanded)
          InkWell(
            child: Text(
              isExpanded ? 'Show Less' : 'Show More',
              style: Sty().mediumBoldText,
            ),
            onTap: () => setState(() {
              if (isExpanded) {
                isExpanded = false;
              } else {
                isExpanded = true;
              }
            }),
          ),
      ],
    );
  }
}

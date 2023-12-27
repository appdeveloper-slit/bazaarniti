import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class Walkthrough extends StatefulWidget {
  const Walkthrough({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WalkthroughPage();
  }
}

class WalkthroughPage extends State<Walkthrough> {
  late BuildContext ctx;

  CarouselController ctrl = CarouselController();
  List<dynamic> sliderList = [
    {
      'txt_image': 'assets/wpt1.svg',
      'image': 'assets/wp1.png',
    },
    {
      'txt_image': 'assets/wpt2.svg',
      'image': 'assets/wp2.png',
    },
    {
      'txt_image': 'assets/wpt3.svg',
      'image': 'assets/wp3.png',
    },
    {
      'txt_image': 'assets/wpt4.svg',
      'image': 'assets/wp3.png',
    },
    {
      'txt_image': 'assets/wpt5.svg',
      'image': 'assets/wp5.png',
    },
  ];
  int position = 0;

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
    return Column(
      children: [
        SizedBox(
          height: Dim().d60,
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: Dim().d4,
                child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: Dim().pp),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sliderList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(ctx).size.width / 6,
                        decoration: BoxDecoration(
                          color: position + 1 > index
                              ? Clr().accentColor
                              : Clr().white,
                          shape: BoxShape.rectangle,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: Dim().d8,
                      );
                    }),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              CarouselSlider(
                carouselController: ctrl,
                options: CarouselOptions(
                  height: MediaQuery.of(ctx).size.height - 184,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      position = index;
                    });
                  },
                ),
                items: sliderList.map((e) => itemSlider(e)).toList(),
              ),
            ],
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () async {
                setWalkthrough();
                STM().finishAffinity(ctx, const Login());
              },
              child: Text(
                "Skip",
                style: Sty().mediumText,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: Dim().d20,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sliderList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return position == index
                        ? Container(
                            height: Dim().d20,
                            width: Dim().d2,
                            decoration: BoxDecoration(
                              color: Clr().white,
                            ),
                          )
                        : Container(
                            height: Dim().d6,
                            width: Dim().d6,
                            decoration: BoxDecoration(
                              color: Clr().white,
                              shape: BoxShape.circle,
                            ),
                          );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: Dim().d8,
                    );
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (position == (sliderList.length - 1)) {
                  setWalkthrough();
                  STM().finishAffinity(ctx, const Login());
                } else {
                  ctrl.nextPage();
                }
              },
              child: SvgPicture.asset(
                'assets/wp_next.svg',
              ),
            ),
          ],
        )
      ],
    );
  }

  //Slider Item
  Widget itemSlider(e) {
    return Padding(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                e['txt_image'],
              ),
            ],
          ),
          Expanded(
            child: Image.asset(
              e['image'],
              height: 300,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  //Set value
  setWalkthrough() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("is_walkthrough", false);
  }
}

import 'package:bazaarniti/values/dimens.dart';
import 'package:flutter/material.dart';

class imagesLayout extends StatefulWidget {
  final vImage;
  const imagesLayout({super.key,this.vImage});

  @override
  State<imagesLayout> createState() => _imagesLayoutState();
}

class _imagesLayoutState extends State<imagesLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Dim().d350,
              child: Image.network(widget.vImage,fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}

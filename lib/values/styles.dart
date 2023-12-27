import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

class Sty {
  TextStyle microText = TextStyle(
    fontFamily: 'Regular',
    letterSpacing: 0.5,
    color: Clr().white,
    fontSize: 12.0,
  );

  TextStyle smallText = TextStyle(
    fontFamily: 'Regular',
    letterSpacing: 0.5,
    color: Clr().white,
    fontSize: 14.0,
  );

  TextStyle mediumText = TextStyle(
    fontFamily: 'Regular',
    letterSpacing: 0.5,
    color: Clr().white,
    fontSize: 16.0,
  );

  TextStyle mediumBoldText = TextStyle(
    fontFamily: 'Bold',
    letterSpacing: 0.5,
    color: Clr().white,
    fontSize: 16.0,
  );

  TextStyle largeText = TextStyle(
    fontFamily: 'Medium',
    letterSpacing: 0.5,
    color: Clr().white,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );

  TextStyle extraLargeText = TextStyle(
    fontFamily: 'Regular',
    letterSpacing: 0.5,
    color: Clr().white,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  );

  InputDecoration textFieldUnderlineStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0x50FFFFFF),
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0x50FFFFFF),
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().red,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().red,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().red,
      fontSize: 14.0,
    ),
  );

  InputDecoration textFieldWithoutStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dim().d12,
        ),
      ),
      borderSide: BorderSide.none,
    ),
  );

  InputDecoration passwordFieldUnderlineStyle = InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().black,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().white,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration textFieldOutlineDarkStyle = InputDecoration(
    filled: true,
    fillColor: Clr().white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().black,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().black,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration textFieldWhiteStyle = InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  RoundedRectangleBorder listTileBorder = RoundedRectangleBorder(
    side: BorderSide(
      color: Clr().lightGrey,
      width: 1,
    ),
  );

  InputDecoration textFieldGreyDarkStyle = InputDecoration(
    filled: true,
    fillColor: Clr().lightGrey,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration textFieldOutlineStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: const BorderSide(
        color: Color(0xFFF4C430),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: const BorderSide(
        color: Color(0xFFF4C430),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration textFieldWhiteOutlineStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: BorderSide(
        color: Clr().white,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: const BorderSide(
        color: Color(0xFFF4C430),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  BoxDecoration dropDownUnderlineStyle = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Clr().black,
        width: 1,
      ),
    ),
  );

  BoxDecoration outlineBoxStyle = BoxDecoration(
    border: Border.all(
      color: Clr().black,
    ),
    borderRadius: BorderRadius.circular(Dim().d4),
  );

  BoxDecoration outlineWhiteBoxStyle = BoxDecoration(
    color: Clr().white,
    border: Border.all(
      color: Clr().lightGrey,
    ),
    borderRadius: BorderRadius.circular(Dim().d4),
  );

  BoxDecoration fillBoxStyle = BoxDecoration(
    color: Clr().white,
    borderRadius: BorderRadius.circular(Dim().d4),
  );

  BoxDecoration registerDropDownStyle = BoxDecoration(
    color: Clr().white,
    border: Border.all(
      color: Clr().white,
    ),
  );

  BoxDecoration profileDropDownStyle = BoxDecoration(
    color: Clr().lightGrey,
    border: Border.all(
      color: Clr().lightGrey,
    ),
    borderRadius: BorderRadius.circular(
      Dim().d12,
    ),
  );

  ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Clr().buttonColor,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d12,
    ),
  );

  ButtonStyle whiteButton = ElevatedButton.styleFrom(
    primary: Clr().white,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d4,
      horizontal: Dim().d20,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
  );

  ButtonStyle outlineButton = ElevatedButton.styleFrom(
    primary: Clr().white,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d4,
      horizontal: Dim().d20,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
      side: BorderSide(
        color: Clr().primaryColor,
      ),
    ),
  );
}

import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:flutter/material.dart';

class comTextFiled extends StatefulWidget {
  final hintext,
      icon,
      controller,
      maxlines,
      keyboardType,
      textinputaction,
      maxlength,
      suffix,
      readonly;

  const comTextFiled(
      {super.key,
      this.hintext,
      this.readonly,
      this.icon,
      this.controller,
      this.maxlines,
      this.suffix,
      this.textinputaction,
      this.maxlength,
      this.keyboardType});

  @override
  State<comTextFiled> createState() => _comTextFiledState();
}

class _comTextFiledState extends State<comTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxlines,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxlength,
      textInputAction: widget.textinputaction,
      readOnly: widget.readonly,
      style: Sty().mediumText.copyWith(color: Clr().white),
      decoration: Sty().textFieldUnderlineStyle.copyWith(
            hintText: widget.hintext,
            suffixIcon: widget.suffix,
            hintStyle:
                Sty().mediumText.copyWith(color: Clr().white.withOpacity(0.60),fontWeight: FontWeight.w400,fontSize: Dim().d14),
            prefixIcon: widget.icon,
          ),
    );
  }
}

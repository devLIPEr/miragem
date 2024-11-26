import 'package:flutter/material.dart';
import 'package:miragem/common/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key key,
      this.controller,
      this.hintText,
      this.obscureText,
      this.keyboardType,
      this.height,
      this.width,
      this.onChanged})
      : super(key: key);
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final double height;
  final double width;
  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: CustomColors.light,
      ),
      child: TextField(
        cursorColor: CustomColors.dark,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusColor: CustomColors.dark,
          hintText: hintText,
        ),
        style: const TextStyle(
          color: CustomColors.dark,
          fontSize: 20.0,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:miragem/common/custom_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key key, this.onTap, this.height, this.width, this.text})
      : super(key: key);
  final Function() onTap;
  final double height;
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: CustomColors.light,
          ),
          child: Text(
            text,
            style: const TextStyle(color: CustomColors.dark, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

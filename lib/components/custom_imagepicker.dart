import 'package:flutter/material.dart';
import 'package:miragem/common/custom_colors.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({Key key, this.onTap, this.height, this.width})
      : super(key: key);
  final Function() onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: CustomColors.light),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Imagem",
              style: TextStyle(color: CustomColors.dark, fontSize: 20.0),
            ),
            Icon(
              Icons.attach_file,
              color: CustomColors.dark,
            ),
          ],
        ),
      ),
    );
  }
}

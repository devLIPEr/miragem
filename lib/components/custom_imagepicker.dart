import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miragem/common/custom_colors.dart';

class CustomImagePicker extends StatefulWidget {
  CustomImagePicker({Key key, this.onTap, this.height, this.width, this.image})
      : super(key: key);
  final Function() onTap;
  final double height;
  final double width;
  String image = "";

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String image = await widget.onTap();
        setState(() {
          widget.image = image;
        });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: CustomColors.light),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Imagem",
              style: TextStyle(color: CustomColors.dark, fontSize: 20.0),
            ),
            // Icon(
            //   Icons.attach_file,
            //   color: CustomColors.dark,
            // ),
            (widget.image == "")
                ? const Icon(Icons.attach_file)
                : Image.file(File(widget.image)),
          ],
        ),
      ),
    );
  }
}

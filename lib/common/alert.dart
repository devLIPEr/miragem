import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miragem/common/custom_colors.dart';

Future<void> customAlert(BuildContext context, String title, double titleSize,
    String content, double contentSize, List<Widget> actions) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CustomColors.highlight,
        title: Text(
          title,
          style: TextStyle(
              color: CustomColors.light,
              fontSize: titleSize,
              fontWeight: FontWeight.w500),
        ),
        content: Text(
          content,
          style: TextStyle(color: CustomColors.light, fontSize: contentSize),
        ),
        actions: actions,
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:miragem/common/custom_colors.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key key, this.onPressed}) : super(key: key);
  final Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // https://stackoverflow.com/questions/52786652/how-to-change-the-size-of-floatingactionbutton
      width: 64.0,
      height: 64.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: CustomColors.light,
          onPressed: () {
            onPressed(context);
          },
          child: const Icon(Icons.add, color: CustomColors.dark, size: 32.0),
        ),
      ),
    );
  }
}

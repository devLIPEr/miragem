import 'package:flutter/material.dart';

/*
Quando for retornar com o Navigator.pop(context),
retorne a quantidade de cartas adicionadas(+)/removidas(-)
Navigator.pop(context, cardsAdded);
*/

class CardPage extends StatefulWidget {
  const CardPage({Key key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
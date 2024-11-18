import 'package:flutter/material.dart';
import 'package:miragem/views/collections_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Roboto'),
    debugShowCheckedModeBanner: false,
    home: const CollectionPage(),
  ));
}

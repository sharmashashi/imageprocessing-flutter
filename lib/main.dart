import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imageprocessing/screens/home/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.deepPurple[900],
      statusBarColor: Colors.green[600]));
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dengue Stop',
    theme: ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.light,
        primaryColor: Colors.cyan[800],
        accentColor: Colors.cyanAccent[700]
    ),
    initialRoute: '/',
    routes: {
    },
  ));
}
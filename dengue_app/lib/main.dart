import 'package:flutter/material.dart';
import 'package:dengue_app/views/login.dart';
import 'package:dengue_app/views/home.dart';
import 'package:dengue_app/views/report_incident.dart';
import 'package:dengue_app/views/reports.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dengue Stop',
    theme: ThemeData(
      // adding custom theme data globally to the app
        fontFamily: 'Raleway',
        brightness: Brightness.light,
        primaryColor: Colors.cyan[800],
        accentColor: Colors.cyanAccent[700]
    ),
    initialRoute: 'reports', // ONLY FOR TESTING PURPOSES! change back to '/'
    routes: {
      // defines the routing for the different components
      // todo add other routing components
      '/': (context) => Login(),
      'login': (context) => Login(),
      'home': (context) => Home(),
      'report_incident': (context) => ReportIncident(),
      'reports': (context) => Reports(),
    },
  ));
}
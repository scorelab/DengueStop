import 'package:flutter/material.dart';
import 'views/home.dart';
import 'views/signup.dart';
import 'views/login.dart';
import 'views/report_incident.dart';
import 'views/reports.dart';
import 'views/profile.dart';
import 'views/event.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dengue Stop',
    theme: ThemeData(
        // adding custom theme data globally to the app
        fontFamily: 'Raleway',
        brightness: Brightness.light,
        primaryColor: Colors.cyan[800],
        accentColor: Colors.cyanAccent[700]),
    initialRoute: '/',
    routes: {
      // defines the routing for the different components
      // todo add other routing components
      '/': (context) =>
          Login(), // ONLY FOR TESTING PURPOSES! change back to login()
      'login': (context) => Login(),
      'signup': (context) => Signup(),
      'home': (context) => Home(),
      'report_incident': (context) => ReportIncident(),
      'reports': (context) => Reports(),
      'profile': (context) => Profile(),
      'event': (context) => EventScreen(),
    },
  ));
}

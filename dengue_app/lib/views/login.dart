import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {

  void testFlaskConnection() async {
    var url = 'http://0.0.0.0:5000/';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
//      var itemCount = jsonResponse['totalItems'];
      print('Name: ${jsonResponse['name']}');
      print('Email: ${jsonResponse['email']}');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo complete login screen
    return Container(
      child: RaisedButton(onPressed: (){
        testFlaskConnection();
      },
      child: Text("TEST FLASK"),),
    );
  }
}

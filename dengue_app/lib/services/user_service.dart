import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final apiProvider = ApiProvider();
  final storage = FlutterSecureStorage();

  User user = User();

  Future<bool> createUser(User user) async {
    var url = 'create_user';
    String jsonUser = jsonEncode(user.toJson());
    var response = await apiProvider.post(url, jsonUser);
    if(response['code'] == 200) {
      return true;
    } else {
      print(response);
      return false;
    }
  }


  loginUser({String username, String password}) async {
    var loginObj = {"username" : username, "password": password};
    var jsonLogin = jsonEncode(loginObj);
    print(jsonLogin);
    var url = 'login_user';
    var response = await apiProvider.post(url, jsonLogin);
    if(response['code'] == 200) {
      return true;
    } else {
      print(response);
      return false;
    }
  }
}
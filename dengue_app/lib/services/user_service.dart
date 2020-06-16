import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'dart:convert';

class UserService {
  final apiProvider = ApiProvider();

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
}
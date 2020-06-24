import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_hash/password_hash.dart';

class UserService {
  final apiProvider = ApiProvider();
  final storage = FlutterSecureStorage();
  final generator = PBKDF2();

  Future<bool> createUser(User user) async {
    var url = 'create_user';
    // generating a salt to hash the password using PBKDF2
    user.salt = Salt.generateAsBase64String(32);
    var hash = generator.generateBase64Key(user.password, user.salt, 1000, 32);
    // storing the hash instead of plain test of password
    user.password = hash;
    String jsonUser = jsonEncode(user.toJson());
    var response = await apiProvider.post(url, jsonUser);
    if (response['code'] == 200) {
      return true;
    } else {
      print(response);
      return false;
    }
  }
}

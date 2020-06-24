import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_hash/password_hash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final apiProvider = ApiProvider();
  final storage = FlutterSecureStorage();
  final generator = PBKDF2();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  Future<bool> updateUser(User updatedUser) async {
    var url = 'update_user';
    // getting current userId
    User currentUser = await getUserData();
    updatedUser.id = currentUser.id;
    updatedUser.telephone = currentUser.telephone;
    String jsonUpdatedUser = jsonEncode(updatedUser.toJson());
    var response = await apiProvider.post(url, jsonUpdatedUser);
    if (response['code'] == 200) {
      // update details in the local storage
      saveUserData(updatedUser);
      return true;
    } else {
      print(response);
      return false;
    }
  }

  Future<String> getUserSalt(String username) async {
    var usernameObj = {"username": username};
    var jsonUsername = jsonEncode(usernameObj);
    var url = 'get_user_salt';
    var response = await apiProvider.post(url, jsonUsername);
    if (response['code'] == 200 && response['data']['salt'] != '') {
      return response['data']['salt'];
    } else {
      return '';
    }
  }

  saveUserData(User user) async {
    final SharedPreferences prefs = await _prefs;
    final userId = user.id;
    final userFirstName = user.firstName;
    final userLastName = user.lastName;
    final userEmail = user.email;
    final userTelephone = user.telephone;
    final userNicNumber = user.nicNumber;
    // clearing shared preferences
    await prefs.clear();
    // storing user data in shared preferences
    await prefs.setInt('userId', userId);
    await prefs.setString('userFirstName', userFirstName);
    await prefs.setString('userLastName', userLastName);
    await prefs.setString('userEmail', userEmail);
    await prefs.setString('userTelephone', userTelephone);
    await prefs.setString('userNicNumber', userNicNumber);
  }

  Future<User> getUserData() async {
    final SharedPreferences prefs = await _prefs;
    User currentUser = User();
    currentUser.id = prefs.getInt('userId');
    currentUser.firstName = prefs.getString('userFirstName');
    currentUser.lastName = prefs.getString('userLastName');
    currentUser.email = prefs.getString('userEmail');
    currentUser.telephone = prefs.getString('userTelephone');
    currentUser.nicNumber = prefs.getString('userNicNumber');
    return currentUser;
  }

  Future<bool> loginUser({String username, String password}) async {
    String userSalt = await getUserSalt(username);
    User currentUser = User();
    String hash;
    if (userSalt != '') {
      // generating the hash using the provided password
      hash = generator.generateBase64Key(password, userSalt, 1000, 32);
      // sending the username and provided password hash for
      var loginObj = {"username": username, "password": hash};
      var jsonLogin = jsonEncode(loginObj);
      var url = 'login_user';
      var response = await apiProvider.post(url, jsonLogin);
      if (response['code'] == 200) {
        // we will receive the jwt in the response
        var jwt = response['data']['token'];
        // stores the jwt in flutter secure storage
        await storage.deleteAll();
        await storage.write(key: 'userToken', value: jwt);
        // received user data
        var userData = response['data']['userData'];
        currentUser = User.fromJson(userData);
        // saving session data of the user
        saveUserData(currentUser);
        return true;
      }
    }
    return false;
  }
}

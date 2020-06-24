import 'package:dengue_app/models/incident.dart';
import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'package:dengue_app/services/user_service.dart';
import 'dart:convert';

class IncidentService {
  final apiProvider = ApiProvider();
  final userService = UserService();

  List<Incident> incidentList = List<Incident>();

  Future<List<Incident>> getIncidentsByUser() async {
    // getting the user id
    User currentUser = await userService.getUserData();
    String currentUserId = currentUser.id.toString();
    var url = 'get_incidents_by_user/' + currentUserId;
    List<dynamic> responseData = new List<dynamic>();
    var responseJson = await apiProvider.get(url);
    if (responseJson['code'] == 200) {
      responseData = responseJson['data'];
      if (responseData.length > 0) {
        for (int i = 0; i < responseData.length; i++) {
          Map<String, dynamic> map = responseData[i];
          incidentList.add(Incident.fromJson(map));
        }
      }
    }
    return incidentList;
  }

  dynamic dateTimeEncode(dynamic item) {
    // this converts DateTime objects to JSON
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  Future<bool> createReport(Incident incident) async {
    var url = 'report_incident';
    String jsonReport =
        jsonEncode(incident.toJson(), toEncodable: dateTimeEncode);
    print(jsonReport);
    var response = await apiProvider.post(url, jsonReport);
    print('res');
    print(response);
    if (response['code'] == 200) {
      return true;
    } else {
      print(response);
      return false;
    }
  }
}

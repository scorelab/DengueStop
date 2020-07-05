import 'package:dengue_app/models/incident.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'package:dengue_app/services/user_service.dart';
import 'dart:convert';

class IncidentService {
  final apiProvider = ApiProvider();
  final userService = UserService();

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

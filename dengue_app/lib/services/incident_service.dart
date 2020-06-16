import 'package:dengue_app/models/incident.dart';
import 'package:dengue_app/networking/ApiProvider.dart';
import 'dart:convert';

class IncidentService {
  final apiProvider = ApiProvider();

  List<Incident> incidentList = List<Incident>();

  Future<List<Incident>> getIncidentsByUser(int userId) async {
    var url = 'get_incidents_by_user/' + userId.toString();
    List<dynamic> responseJson = new List<dynamic>();
    responseJson = await apiProvider.get(url);

    if(responseJson.length > 0) {
      for(int i=0; i<responseJson.length; i++) {
        Map<String, dynamic> map=responseJson[i];
        incidentList.add(Incident.fromJson(map));
        print('Id-------${map['id']}');

      }
      return incidentList;
    }
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
    String jsonReport = jsonEncode(incident.toJson(),  toEncodable: dateTimeEncode);
    print(jsonReport);
    var response = await apiProvider.post(url, jsonReport);
    print('res');
    print(response);
    if(response['code'] == 200) {
      return true;
    } else {
      print(response);
      return false;
    }
  }
}
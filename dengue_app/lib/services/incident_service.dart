import 'package:dengue_app/models/incident.dart';
import 'package:dengue_app/networking/ApiProvider.dart';

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
}
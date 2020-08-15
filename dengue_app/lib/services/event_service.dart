import 'package:dengue_app/models/event.dart';
import 'package:dengue_app/networking/ApiProvider.dart';

class EventService {
  final apiProvider = ApiProvider();

  List<Event> eventList = List<Event>();

  Future<List<Event>> getAllEvents() async {
    var url = 'get_all_events';
    List<dynamic> responseData = new List<dynamic>();
    var responseJson = await apiProvider.get(url);
    if (responseJson['code'] == 200) {
      responseData = responseJson['data'];
      if (responseData.length > 0) {
        for (int i = 0; i < responseData.length; i++) {
          Map<String, dynamic> map = responseData[i];
          eventList.add(Event.fromJson(map));
        }
      }
    }
    return eventList;
  }
}

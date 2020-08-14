import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;



    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Event(arg:arguments),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonDrawer(),
                )
              ],
            ),
          ),
        ));
  }
}

class Event extends StatelessWidget {
  final arg;
  Event({this.arg});

  final eventNameStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700
  );

  @override
  Widget build(BuildContext context) {
    DateTime eventDate = arg['eventDate'];
    double duration = arg['duration'];
    String formattedStartTime =
    DateFormat('dd/MM/yyyy @ h:mm a').format(eventDate);
    String formattedEndTime = duration.toString() + " hours";

    String eventStatusBuilder(statusId) {
      switch(statusId){
        case 1:
          return 'Pending Event';
        case 2:
          return 'Upcoming Event';
        case 3:
          return 'Now Happening';
        case 4:
          return 'Finished Event';
        case 5:
          return 'Cancelled Event';
        default:
          return 'Status';
      }
    }


    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(arg['eventName'], style: eventNameStyle),
            ),
          ),
          SizedBox(height: 20.0),
          EventField(textFieldLabel: "Event Status", textData: eventStatusBuilder(arg['status']),),
          SizedBox(height: 10.0),
          EventField(textFieldLabel: "Venue", textData: arg['venue'],),
          SizedBox(height: 10.0),
          EventField(textFieldLabel: "Starts at", textData: formattedStartTime),
          SizedBox(height: 10.0),
          EventField(textFieldLabel: "Duration", textData: formattedEndTime),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              EventField(textFieldLabel: "Coordinator", textData: arg['eventCoordinator']),
              EventField(textFieldLabel: "Contact", textData: arg['eventContact'])
            ],
          ),
          SizedBox(height: 20.0),
          EventLocation(lat:arg['locationLat'], lng: arg['locationLong'])
        ],
      ),
    );
  }
}


class EventField extends StatelessWidget {
  final textFieldLabel;
  final textData;
  TextStyle formLabelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  TextStyle formDataStyle =
  TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500);

  EventField({this.textFieldLabel, this.textData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Text(textFieldLabel, style: formLabelStyle,),
          Text(textData, style: formDataStyle,)
        ],
      ),
    );
  }
}

class EventLocation extends StatelessWidget {
  final double lat;
  final double lng;
  EventLocation({this.lat, this.lng});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(lat, lng),
          zoom: 16.0,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                point: new LatLng(lat, lng),
                builder: (ctx) =>
                new Container(
                  child: new Icon(Icons.location_on, size: 50, color: Colors.red,),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class ButtonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // button drawer which holds button at the bottom
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 25.0,
            offset: new Offset(0.0, -5.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DrawerButton(buttonText: "Go Back", buttonType: 'go_back'),
        ],
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  // create buttons with same appearance with different text and different routes
  final String buttonText;
  final String buttonType;
  DrawerButton({this.buttonText, this.buttonType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: RaisedButton(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[900],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
            side: BorderSide(color: Colors.grey[300])),
        elevation: 10.0,
        color: Colors.white,
        onPressed: () {
          if (buttonType == 'go_back') {
            // go back
            Navigator.pop(context);
          } else {}
        },
      ),
    );
  }
}


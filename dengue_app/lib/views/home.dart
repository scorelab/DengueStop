import 'package:dengue_app/models/event.dart';
import 'package:dengue_app/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:dengue_app/services/user_service.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // fab for adding a new report
        floatingActionButton: Padding(
          // shifting the fab up by 200px
          padding: const EdgeInsets.only(bottom: 200.0),
          // resizing fab to 60x60px
          child: Container(
            width: 60.0,
            height: 60.0,
            child: FloatingActionButton(
              onPressed: () {
                // routing to report incident screen
                Navigator.pushNamed(context, 'report_incident');
              },
              child: Icon(Icons.add, size: 40.0),
              backgroundColor: Colors.lightBlue[500],
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2EBEC6), Color(0xFF314687)],
                  stops: [0.0, 0.7],
                  tileMode: TileMode.clamp)),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Events(),
                ),
                Expanded(
                  flex: 3,
                  child: ButtonDrawer(),
                )
              ],
            ),
          ),
        ));
  }
}

class Events extends StatefulWidget {
//  generates the list of scrollable events in the top half of the screen
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final EventService eventService = EventService();
  Future<List<Event>> futureEventList;
  @override
  void initState() {
    super.initState();
    futureEventList = eventService.getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          TopToolBar(),
          SizedBox(height: 10.0),
          Expanded(
            child: FutureBuilder(
                future: Future.wait([futureEventList]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return EventList(eventList: snapshot.data[0]);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return Text("Something else");
                  }
                }),
          )
        ],
      ),
    );
  }
}

class EventList extends StatelessWidget {
  final List<Event> eventList;
  EventList({this.eventList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    return EventCard(
                      eventName: eventList[index].name,
                      eventCoordinator: eventList[index].coordinatorName,
                      eventDate: eventList[index].startTime,
                      duration: eventList[index].duration,
                      locationLat: eventList[index].locationLat,
                      locationLong: eventList[index].locationLong,
                      status: eventList[index].statusId,
                      venue: eventList[index].venue,
                      eventContact: eventList[index].coordinatorContact,
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class TopToolBar extends StatelessWidget {
  final userService = UserService();

  logoutUser(context) async {
    bool result = await userService.logoutUser();
    if (result == true) {
      Navigator.pop(context);
    }
  }

  showLogoutConfirmation(BuildContext context) {
    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: Colors.red)),
      onPressed: () {
        // logout the user
        logoutUser(context);
        // dismiss the popup
        Navigator.of(context).pop();
      },
    );

    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        // dismiss the popup
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logging Out..."),
      content: Text("Do you want to logout from Dengue Stop?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
         
          Text('Events',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0,
                  color: Colors.white)),
          Material(
            color: Colors.transparent,
            child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  size: 30,
                ),
                onPressed: () {
                  // logout confirmation
                  showLogoutConfirmation(context);
                }),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventCoordinator;
  final String eventContact;
  final DateTime eventDate;
  final int status;
  final double duration;
  final double locationLat;
  final double locationLong;
  final String venue;

  EventCard(
      {this.eventName,
      this.eventCoordinator,
      this.eventContact,
      this.eventDate,
      this.duration,
      this.locationLat,
      this.locationLong,
      this.venue,
      this.status});

  Color changeEventTextColor(statusId) {
    switch (statusId) {
      case 2:
        return Colors.white;
      case 3:
        return Colors.white.withOpacity(0.2);
      case 4:
        return Colors.white;
      case 5:
        return Colors.white.withOpacity(0.5);
      default:
        return Colors.white;
    }
  }

  Color changeEventBoxColor(statusId) {
    switch (statusId) {
      case 2:
        return Colors.teal[900].withOpacity(0.5);
      case 3:
        return Colors.black.withOpacity(0.3);
      case 4:
        return Colors.black.withOpacity(0.5);
      case 5:
        return Colors.red[900].withOpacity(0.5);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTimestamp =
        DateFormat('dd/MM/yyyy @ h:mm a').format(this.eventDate);
    // styles for event name label
    final TextStyle eventNameStyle = TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: changeEventTextColor(this.status));
    // styles for event details
    final TextStyle eventDetailsStyle = TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: changeEventTextColor(this.status));

    return Container(
      // separation between event cards
      margin: EdgeInsets.only(bottom: 15.0),
      height: 150,
      decoration: BoxDecoration(
          color: changeEventBoxColor(this
              .status), //todo dynamically change opacity based on event status
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.grey[700])),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'event', arguments: {
              "eventName": eventName,
              "eventCoordinator": eventCoordinator,
              "eventContact": eventContact,
              "eventDate": eventDate,
              "duration": duration,
              "locationLat": locationLat,
              "locationLong": locationLong,
              "venue": venue,
              "status": status
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("$eventName", style: eventNameStyle),
                Text("$venue", style: eventDetailsStyle),
                Text("$eventCoordinator | $eventContact",
                    style: eventDetailsStyle),
                Text("$formattedTimestamp | $duration hours",
                    style: eventDetailsStyle)
              ],
            ),
          ),
        ),
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
            color: Color(0xFF1E1648),
            blurRadius: 25.0,
            offset: new Offset(0.0, -5.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DrawerButton(buttonText: "My Reports", buttonType: 'report'),
          DrawerButton(buttonText: "My Profile", buttonType: 'profile'),
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
          // on press will trigger different name routes based on the type of button
          if (buttonType == 'report') {
            // routing to reports screen
            Navigator.pushNamed(context, 'reports');
          } else if (buttonType == 'profile') {
            // routing to profile screen
            Navigator.pushNamed(context, 'profile');
          } else {}
        },
      ),
    );
  }
}

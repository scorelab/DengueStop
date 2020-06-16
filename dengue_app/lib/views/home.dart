import 'package:flutter/material.dart';

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
                  child: EventList(),
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

class EventList extends StatefulWidget {
//  generates the list of scrollable events in the top half of the screen
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
            child: Text('Events',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25.0,
                    color: Colors.white)),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    // todo pass data to event card from backend
                    // todo calculate and parse time formats according to the required format
                    return EventCard(
                      eventName: "Dengue Awareness Programme",
                      eventCoordinator: "PHI Silva",
                      eventDate: "26th May 2020",
                      startTime: "10.30 am",
                      endTime: "12.00 pm",
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  // todo might have to change to Stateful widget as we are changing the color/opacity based on the expiration of the event.
  // styles for event name label
  TextStyle eventNameStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      color: Colors.white
  );
  // styles for event details
  TextStyle eventDetailsStyle = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white
  );

  final String eventName;
  final String eventCoordinator;
  final String eventDate;
  final String startTime;
  final String endTime;

  EventCard({this.eventName, this.eventCoordinator, this.eventDate, this.startTime, this.endTime});



  @override
  Widget build(BuildContext context) {
    return Container(
      // separation between event cards
      margin: EdgeInsets.only(bottom: 15.0),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5), //todo dynamically change opacity based on event status
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.grey[700])
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("$eventName", style: eventNameStyle),
            Text("$eventCoordinator", style: eventDetailsStyle),
            Text("$eventDate | $startTime to $endTime", style: eventDetailsStyle)
          ],
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
          } else if (buttonType == 'profile'){
            // routing to profile screen
            print('profile');
          } else {
            // todo handle the error
          }
        },
      ),
    );
  }
}

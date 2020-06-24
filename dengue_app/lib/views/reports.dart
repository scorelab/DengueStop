import 'package:dengue_app/models/status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dengue_app/models/incident.dart';
import 'package:dengue_app/services/incident_service.dart';
import 'package:dengue_app/services/data_service.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final IncidentService incidentService = IncidentService();
  final DataService dataService = DataService();
  Future<List<Incident>> futureIncidentList;
  Future<List<Status>> futurePatientStatusList;
  @override
  void initState() {
    super.initState();
    futureIncidentList = incidentService.getIncidentsByUser();
    futurePatientStatusList = dataService.getPatientStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
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
                SizedBox(height: 10.0),
                Center(
                  child: Text('My Reports',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25.0,
                          color: Colors.white)),
                ),
                Expanded(
                  flex: 13,
                  child: FutureBuilder(
                    future: Future.wait([futureIncidentList, futurePatientStatusList]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ReportList(incidentList: snapshot.data[0], patientStatusList: snapshot.data[1]);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          return Text("Something else");
                        }

                      }),
                ),
                Expanded(
                  flex: 2,
                  child: ButtonDrawer(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportList extends StatelessWidget {
  final List<Incident> incidentList;
  final List<Status> patientStatusList;
  ReportList({this.incidentList, this.patientStatusList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Expanded(
            child: Container(
//              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  itemCount: incidentList.length,
                  itemBuilder: (context, index) {
                    return ReportCard(incident: incidentList[index], statusList: patientStatusList);
                  }),
            ),
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
            color: Color(0xFF1E1648),
            blurRadius: 15.0,
            spreadRadius: 2,
            offset: new Offset(0.0, -2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DrawerButton(buttonText: "Cancel", buttonType: 'cancel'),
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
          if (buttonType == 'cancel') {
            // routing back to home screen
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  // styles for report name label
  final TextStyle reportBoldStyle = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black);
  // styles for report details
  final TextStyle reportThinStyle = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black);

  final Incident incident;
  final List<Status> statusList;
  ReportCard({this.incident, this.statusList});


  Text getVerificationStatusText(isVerified) {
    // returns the text with styling based on the verification status id
    if (isVerified == 0) {
      // pending verification
      return Text('Not Verified',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.orange[500]));
    } else if (isVerified == 1) {
      // verified
      return Text('Verified',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.green[500]));
    } else {
      // declined or error
      return Text('Declined',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.red[500]));
    }
  }

  Text getPatientStatusText(int status) {
    // returns the text with styling based on the patient status id
    String statusName = '';
    Color statusColor = Colors.black;
    // this will change the status text color based on the status
    List<Color> colorList = [
      Colors.black,
      Colors.deepOrange[500],
      Colors.orange[500],
      Colors.green[700],
      Colors.teal[700],
      Colors.blue[500],
      Colors.red[500],
      Colors.orange[500]
    ];
    statusList.forEach((element) {
      if (element.id == status) {
        statusName = element.status;
      }
    });
    return Text(statusName,
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            color: colorList[status]));
  }

  Text getPatientGenderText(gender) {
    // returns the text with styling based on the patient gender id
    if (gender == 'm') {
      // pending verification
      return Text('Male',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700));
    } else if (gender == 'f') {
      // verified
      return Text('Female',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700));
    } else {
      // declined or error
      return Text('',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.red[500]));
    }
  }

  @override
  Widget build(BuildContext context) {
    // formatting timestamp and patient date of birth to look nicer on the card
    String formattedTimestamp = DateFormat('dd/MM/yyyy @ h:mm a').format(incident.reportedTime);
    String formattedDob = DateFormat('dd/MM/yyyy').format(incident.patientDob);
    return Container(
      // separation between report cards
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$formattedTimestamp', style: reportBoldStyle),
                getVerificationStatusText(incident.isVerified)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${incident.patientName}", style: reportBoldStyle),
                getPatientStatusText(incident.patientStatusId)
              ],
            ),
            getPatientGenderText(incident.patientGender),
            Text("$formattedDob", style: reportThinStyle),
            Text("${incident.province} | ${incident.district}",
                style: reportThinStyle),
            Text("${incident.description}", overflow: TextOverflow.ellipsis, style: reportThinStyle)
          ],
        ),
      ),
    );
  }
}

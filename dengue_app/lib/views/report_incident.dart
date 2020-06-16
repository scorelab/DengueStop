import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dengue_app/models/incident.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:dengue_app/services/incident_service.dart';

// global styling for form labels
TextStyle formLabelStyle =
    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.black);

// global focus nodes for fields
// focus node for city field
FocusNode cityFocusNode = new FocusNode();
// focus node for patient name
FocusNode patientNameFocusNode = new FocusNode();
// focus node for description
FocusNode descriptionFocusNode = new FocusNode();

// white background encapsulating the form
class ReportIncident extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.0),
              Center(
                child: Text('Report Incident',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                        color: Colors.white)),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: IncidentForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// report incident form
class IncidentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.lightBlue[700],
              blurRadius: 15.0,
              offset: new Offset(0.0, -2.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // contains the form field
              IncidentFormField(),
            ],
          ),
        ));
  }
}

class IncidentFormField extends StatefulWidget {
  @override
  _IncidentFormFieldState createState() => _IncidentFormFieldState();
}

class _IncidentFormFieldState extends State<IncidentFormField> {
  Incident incident = Incident();
  final _incidentFormKey = GlobalKey<FormState>();
  final incidentCityController = TextEditingController();
  final patientNameController = TextEditingController();
  final incidentDescriptionController = TextEditingController();
  final incidentService = IncidentService();

  showSaveConfirmation(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("No"),
      textColor: Colors.red,
      onPressed: () {
        // dismiss the popup
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        // sends the report to the server and dismiss the popup
        Navigator.of(context).pop();
        sendReport();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Send Report"),
      content: Text("Do you want to send the report to the authorities?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setCoordinates(double lat, double long) {
    incident.locationLat = lat;
    incident.locationLong = long;
  }

  setIncidentProvince(String province) {
    incident.province = province;
  }

  setIncidentDistrict(String district) {
    incident.district = district;
  }

  setIncidentCity(String city) {
    incident.city = incidentCityController.text;
  }

  setPatientName(String name) {
    incident.patientName = patientNameController.text;
  }

  setPatientGender(String gender) {
    // id 2 for Female
    // id 1 for Male
    if (gender == 'Male') {
      incident.patientGender = 1;
    } else if (gender == 'Female') {
      incident.patientGender = 2;
    }
  }

  setPatientDob(DateTime dob) {
    incident.patientDob = dob;
    print(dob);
  }

  setIncidentDescription(String description) {
    incident.description = incidentDescriptionController.text;
  }

  submitIncidentReport() {
    if (_incidentFormKey.currentState.validate()) {
      _incidentFormKey.currentState.save();
      showSaveConfirmation(context);
    }
  }

  sendReport() async {
    // setting other required attributes of the object
    // todo authentication and get user id and plug here
    incident.reportedUserId = 1;
    // status 1 means patient is pending verification
    incident.patientStatusId = 1;
    // initially report is not verified, therefore status zero. For all statuses check incident.dart file
    incident.isVerified = 0;
    // verified by will be null, which means no admin have verified it
    // todo get orgId based on province and district and plug here
    incident.orgId = 1;
    if(await incidentService.createReport(incident)) {
      showReportCreatedAlert(context);
    } else {
      showErrorAlert(context);
    }
  }

  showReportCreatedAlert(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        // sends the user back to login
        Navigator.popUntil(context, ModalRoute.withName('home'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: Text("Report Sent to Authorities!"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showErrorAlert(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        // dismiss the popup
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oops!"),
      content: Text("Something went wrong! Please try again"),
      actions: [
        okButton,
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
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _incidentFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ProvinceDropdown(
                    setProvinceFunction: setIncidentProvince,
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                    child: DistrictDropdown(
                        setDistrictFunction: setIncidentDistrict))
              ],
            ),
            // province dropdown
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: CityAutoCompleteField(
                      controller: incidentCityController,
                      onSavedFunction: setIncidentCity),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 3,
                  child: GetLocationButton(textController: incidentCityController, setCoordinateFunction: setCoordinates),
                )
              ],
            ),
            SizedBox(height: 10.0),
            PatientNameField(
                controller: patientNameController,
                onSavedFunction: setPatientName),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: GenderDropdown(setGenderFunction: setPatientGender),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: BirthDatePicker(setBirthDateFunction: setPatientDob),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            IncidentDescriptionField(
                controller: incidentDescriptionController,
                onSavedFunction: setIncidentDescription),
            // contains the form action buttons
            IncidentFormButtons(submitFunction: submitIncidentReport),
          ],
        ),
      ),
    );
  }
}

class IncidentFormButtons extends StatelessWidget {
  final submitFunction;

  IncidentFormButtons({this.submitFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormButton(
              buttonText: 'Send Report',
              buttonType: 'send',
              buttonFunction: submitFunction),
          FormButton(buttonText: 'Cancel', buttonType: 'cancel')
        ],
      ),
    );
  }
}

// custom dropdown created for province, district and gender
class CustomDropdown extends StatefulWidget {
  final List<String> dropdownData;
  final selectFunction;
  final String label;
  // todo find a way to make selectedData final
  String selectedData;
  CustomDropdown(
      {Key key,
      this.dropdownData,
      this.selectedData,
      this.selectFunction,
      this.label})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedData = '';
  @override
  Widget build(BuildContext context) {
    // todo better approach to handle selected data other than widget.selectedData
    return DropdownButtonFormField<String>(
      value: selectedData,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 30,
      elevation: 16,
      decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black)),
//        decoration: InputDecoration.collapsed(
//          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)))
//        ),
      validator: (value) => value.isEmpty ? 'Required' : null,
      style: TextStyle(color: Colors.black, fontFamily: 'Raleway'),
      onChanged: (String newValue) {
        setState(() {
          selectedData = newValue;
          widget.selectFunction(newValue);
        });
      },
      // todo add province data to dropdown
      items: widget.dropdownData.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class ProvinceDropdown extends StatefulWidget {
  final setProvinceFunction;
  ProvinceDropdown({Key key, this.setProvinceFunction}) : super(key: key);

  @override
  _ProvinceDropdownState createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  String selectedProvince = "Western";
  List<String> provinceDropdown = ['', 'Western', 'Central', 'North Eastern', 'Southern'];
  // todo retrieve provinces
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
        dropdownData: provinceDropdown,
        selectedData: selectedProvince,
        selectFunction: widget.setProvinceFunction,
        label: 'Province');
  }
}

class DistrictDropdown extends StatefulWidget {
  final setDistrictFunction;
  DistrictDropdown({Key key, this.setDistrictFunction}) : super(key: key);

  @override
  _DistrictDropdownState createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  String selectedDistrict = "Colombo";
  List<String> districtDropdown = ['', 'Colombo', 'Kelaniya', 'Galle', 'Kandy'];
  // todo retrieve districts
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      dropdownData: districtDropdown,
      selectedData: selectedDistrict,
      selectFunction: widget.setDistrictFunction,
      label: 'District',
    );
  }
}

class CityAutoCompleteField extends StatefulWidget {
  final controller;
  final onSavedFunction;
  CityAutoCompleteField({Key key, this.controller, this.onSavedFunction})
      : super(key: key);
  @override
  _CityAutoCompleteFieldState createState() => _CityAutoCompleteFieldState();
}

class _CityAutoCompleteFieldState extends State<CityAutoCompleteField> {
  String validateCityName(String value) {
    if (value.isEmpty) {
      return 'Please enter a city';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        focusNode: cityFocusNode,
        textInputAction: TextInputAction.done,
        decoration:
            InputDecoration(labelText: 'City', labelStyle: formLabelStyle),
        // change focus to patient name on press of enter
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(patientNameFocusNode),
        controller: widget.controller,
        validator: validateCityName,
        onSaved: widget.onSavedFunction,
        // limiting characters to 45 corresponding to the database
        inputFormatters: [
          LengthLimitingTextInputFormatter(45),
        ],
      ),
    );
  }
}

class GetLocationButton extends StatefulWidget {
  final TextEditingController textController;
  final setCoordinateFunction;
  @override
  _GetLocationButtonState createState() => _GetLocationButtonState();
  GetLocationButton({Key key, this.textController, this.setCoordinateFunction})
      : super(key: key);
}

class _GetLocationButtonState extends State<GetLocationButton> {
  Future<bool> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position?.latitude != null && position?.longitude != null) {
      // setting coordinates received in the incident object
      widget.setCoordinateFunction(position.latitude, position.longitude);
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = p[0];
      String locationName = "";
      if(placemark?.thoroughfare != "" && placemark?.name != "") {
        locationName = locationName + placemark.thoroughfare + ", " + placemark.name;
      }
      else if(placemark?.thoroughfare == "" && placemark?.name != "") {
        locationName = locationName + placemark.name;
      }
      else if(placemark?.thoroughfare != "" && placemark?.name == "") {
        locationName = locationName + placemark.thoroughfare;
      } else {
        locationName = "";
      }
      widget.textController.text = locationName;
      return true;
    } else {
      // todo notification sticker to say an error has occured
      print("Error has occured");
      return false;
    }
  }

  Color btnColor = Colors.lightBlue[700];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
          elevation: 5,
          color: btnColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: btnColor)),
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          onPressed: () async {
            bool result = await getLocation();
            print(result);
            setState(() {
              // changes color based on whether the location is retrieved successfully or not
              btnColor = result == true? Colors.green: Colors.red;
            });
          },
          // showing the selected date on the button
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.my_location,
                color: Colors.white70,
              )
            ],
          )),
    );
  }
}

class PatientNameField extends StatelessWidget {
  final controller;
  final onSavedFunction;
  PatientNameField({this.controller, this.onSavedFunction});

  String validatePatientName(String value) {
    if (value.isEmpty) {
      return 'Please enter the patient name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Patient Name', labelStyle: formLabelStyle),
        focusNode: patientNameFocusNode,
        textInputAction: TextInputAction.done,
        // determines the type of keyboard to show
        keyboardType: TextInputType.text,
        // changing focus to description text field upon pressing enter
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(descriptionFocusNode),
        controller: controller,
        validator: validatePatientName,
        // limiting characters to 45 corresponding to the database
        inputFormatters: [
          LengthLimitingTextInputFormatter(45),
        ],
        onSaved: onSavedFunction,
      ),
    );
  }
}

class GenderDropdown extends StatefulWidget {
  final setGenderFunction;
  GenderDropdown({Key key, this.setGenderFunction}) : super(key: key);
  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String selectedGender = 'Male';
  List<String> genderDropdown = ['', 'Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      dropdownData: genderDropdown,
      selectedData: selectedGender,
      selectFunction: widget.setGenderFunction,
      label: 'Gender',
    );
  }
}

class BirthDatePicker extends StatefulWidget {
  final setBirthDateFunction;
  BirthDatePicker({Key key, this.setBirthDateFunction}) : super(key: key);
  @override
  _BirthDatePickerState createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime selectedDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Color underlineColor = Colors.red;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // can select dates until 1900-01-01
        firstDate: DateTime(1900),
        // cannot select dates beyond today
        lastDate: endDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        widget.setBirthDateFunction(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: underlineColor))),
      child: OutlineButton(
          onPressed: () {
            _selectDate(context);
            setState(() {
              underlineColor = Colors.grey;
            });
          },
          //
          borderSide: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.transparent),
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          // showing the selected date on the button
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Date of Birth', style: formLabelStyle),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${selectedDate.toLocal()}'.split(' ')[0]),
                  Icon(Icons.date_range)
                ],
              )
            ],
          )),
    );
  }
}

class IncidentDescriptionField extends StatelessWidget {
  final controller;
  final onSavedFunction;
  IncidentDescriptionField({this.controller, this.onSavedFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        focusNode: descriptionFocusNode,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            labelText: 'Description', labelStyle: formLabelStyle),
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: controller,
        // limiting characters to 200 corresponding to the database
        inputFormatters: [
          LengthLimitingTextInputFormatter(200),
        ],
        onSaved: onSavedFunction,
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  // create buttons for the form with same appearance with different text and different functions
  final String buttonText;
  final String buttonType;
  final buttonFunction;
  FormButton({this.buttonText, this.buttonType, this.buttonFunction});

  showCancelConfirmation(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        // dismiss the popup
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      textColor: Colors.red,
      onPressed: () {
        // routing back to home screen
        // this will pop the alert as well as the report incident screen and go to home screen
        Navigator.popUntil(context, ModalRoute.withName('home'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancel Report"),
      content: Text("Do you want to cancel the report?"),
      actions: [
        cancelButton,
        continueButton,
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
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: RaisedButton(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              // change font color of the button based on the button type
              color:
                  (buttonType == 'send') ? Colors.indigo[900] : Colors.red[900],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
            side: BorderSide(color: Colors.grey[300])),
        elevation: 10.0,
        color: Colors.white,
        onPressed: () {
          // on press will trigger different functions based on the type of button
          if (buttonType == 'send') {
            // send report
            buttonFunction();
            // todo logic to send the report
          } else if (buttonType == 'cancel') {
            // show confirmation dialog
            print('cancel');
            showCancelConfirmation(context);
          } else {
            // todo handle the error
          }
        },
      ),
    );
  }
}

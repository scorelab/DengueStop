import 'package:dengue_app/models/org_unit.dart';
import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dengue_app/models/incident.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dengue_app/services/incident_service.dart';
import 'package:dengue_app/models/district.dart';
import 'package:dengue_app/models/province.dart';
import 'package:dengue_app/services/data_service.dart';

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
  Province globalSelectedProvince = Province(id: 0, name: '');
  final _incidentFormKey = GlobalKey<FormState>();
  final incidentCityController = TextEditingController();
  final patientNameController = TextEditingController();
  final incidentDescriptionController = TextEditingController();
  final incidentService = IncidentService();
  final userService = UserService();
  final dataService = DataService();
  District selectedDistrict;
  Future<List<District>> districtData;
  List<District> districtList;
  Province selectedProvince;
  Future<List<Province>> provinceData;
  List<Province> provinceList;

  @override
  void initState() {
    super.initState();
    provinceData = dataService.getProvinces();
    districtData = dataService.getDistricts();
  }

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

  setIncidentProvince(Province province) {
    incident.province = province.name;
    setState(() {
      // this will trigger a rebuild of the parent which causes the district dropdown to update
      globalSelectedProvince = province;
    });
  }

  setIncidentDistrict(District district) {
    incident.district = district.name;
  }

  setIncidentCity(String city) {
    incident.city = incidentCityController.text;
  }

  setPatientName(String name) {
    incident.patientName = patientNameController.text;
  }

  setPatientGender(String gender) {
    // f for Female
    // m for Male
    if (gender == 'Male') {
      incident.patientGender = 'm';
    } else if (gender == 'Female') {
      incident.patientGender = 'f';
    }
  }

  setPatientDob(DateTime dob) {
    incident.patientDob = dob;
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
    // getting the current user Id to set as the reported user's id
    User currentUser = await userService.getUserData();
    incident.reportedUserId = currentUser.id;
    // status 1 means patient is pending verification
    incident.patientStatusId = 1;
    // initially report is not verified, therefore status zero. For all statuses check incident.dart file
    incident.isVerified = 0;
    // verified by will be null, which means no admin have verified it
    // getting the org unit based on province and district
    incident.orgId = 0;
    OrgUnit incidentOrg = await dataService.getIncidentOrgUnit(
        incident.province, incident.district);
    incident.orgId = incidentOrg.id;
    if (await incidentService.createReport(incident)) {
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
                  child: FutureBuilder<List<Province>>(
                      future: provinceData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          provinceList = snapshot.data;
                          return ProvinceDropdown(
                            setProvinceFunction: setIncidentProvince,
                            provinceList: provinceList,
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          return Text("Something else");
                        }
                      }),
                ),
                SizedBox(width: 20.0),
                Expanded(
                    child: FutureBuilder<List<District>>(
                        future: districtData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            districtList = snapshot.data;
                            return DistrictDropdown(
                                selectedProvince: globalSelectedProvince,
                                districtList: districtList,
                                setDistrictFunction: setIncidentDistrict);
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return Text("Something else");
                          }
                        }))
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
                  child: GetLocationButton(
                      textController: incidentCityController,
                      setCoordinateFunction: setCoordinates),
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

class ProvinceDropdown extends StatefulWidget {
  final setProvinceFunction;
  final List<Province> provinceList;
  ProvinceDropdown({Key key, this.setProvinceFunction, this.provinceList})
      : super(key: key);

  @override
  _ProvinceDropdownState createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  Province selectedProvince;

  String provinceValidator() {
    if (selectedProvince == null) {
      return 'Required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Province>(
      value: selectedProvince,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 30,
      elevation: 16,
      decoration:
          InputDecoration(labelText: 'Province', labelStyle: formLabelStyle),
      validator: (value) => provinceValidator(),
      onChanged: (Province newValue) {
        setState(() {
          selectedProvince = newValue;
          widget.setProvinceFunction(newValue);
        });
      },
      items:
          widget.provinceList.map<DropdownMenuItem<Province>>((Province value) {
        return DropdownMenuItem<Province>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}

class DistrictDropdown extends StatefulWidget {
  final List<District> districtList;
  final setDistrictFunction;
  final Province selectedProvince;
  DistrictDropdown(
      {Key key,
      this.setDistrictFunction,
      this.districtList,
      this.selectedProvince})
      : super(key: key);

  @override
  _DistrictDropdownState createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  District selectedDistrict;
  String districtValidator() {
    if (selectedDistrict == null) {
      return 'Required';
    }
    return null;
  }


  @override
  void didUpdateWidget(DistrictDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProvince != oldWidget.selectedProvince) {
      setState(() {
        selectedDistrict = widget.districtList
            .where((element) => element.provinceId == widget.selectedProvince.id)
            .toList()
            .first;
        widget.setDistrictFunction(selectedDistrict);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<District>(
      value: selectedDistrict,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 30,
      elevation: 16,
      decoration:
          InputDecoration(labelText: 'District', labelStyle: formLabelStyle),
      validator: (value) => districtValidator(),
      onChanged: (District newValue) {
        setState(() {
          selectedDistrict = newValue;
          widget.setDistrictFunction(newValue);
        });
      },
      // returning districts only belonging to the selected province
      items: widget.districtList
          .where((element) => element.provinceId == widget.selectedProvince.id)
          .map<DropdownMenuItem<District>>((District value) {
        return DropdownMenuItem<District>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
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
      List<Placemark> p = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = p[0];
      String locationName = "";
      if (placemark?.thoroughfare != "" && placemark?.name != "") {
        locationName =
            locationName + placemark.thoroughfare + ", " + placemark.name;
      } else if (placemark?.thoroughfare == "" && placemark?.name != "") {
        locationName = locationName + placemark.name;
      } else if (placemark?.thoroughfare != "" && placemark?.name == "") {
        locationName = locationName + placemark.thoroughfare;
      } else {
        locationName = "";
      }
      widget.textController.text = locationName;
      return true;
    } else {
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
            setState(() {
              // changes color based on whether the location is retrieved successfully or not
              btnColor = result == true ? Colors.green : Colors.red;
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
  String selectedGender = '';
  List<String> genderDropdown = ['', 'Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 30,
      elevation: 16,
      decoration:
          InputDecoration(labelText: 'Gender', labelStyle: formLabelStyle),
//        decoration: InputDecoration.collapsed(
//          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)))
//        ),
      validator: (value) => value.isEmpty ? 'Required' : null,
      style: TextStyle(color: Colors.black, fontFamily: 'Raleway'),
      onChanged: (String newValue) {
        setState(() {
          selectedGender = newValue;
          widget.setGenderFunction(newValue);
        });
      },
      items: genderDropdown.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: underlineColor))),
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
              SizedBox(height: 1),
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
          } else if (buttonType == 'cancel') {
            // show confirmation dialog
            showCancelConfirmation(context);
          }
        },
      ),
    );
  }
}

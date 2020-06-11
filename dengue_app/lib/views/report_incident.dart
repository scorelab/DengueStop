import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dengue_app/models/incident.dart';

// global styling for form labels
TextStyle formLabelStyle =
TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);
// global styling for form fields
InputDecoration formFieldStyle = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.grey),
  ),
);

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
              // contains the form action buttons
              IncidentFormButtons(),
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
  final _incidentFormKey = GlobalKey<FormState>();
  Incident incident = Incident();

  setIncidentProvince(String province) {
    print('province');
    print(province);
  }

  setIncidentDistrict(String district){
    print('district');
    print(district);
  }

  setPatientGender(String gender){
    print('gender');
    print(gender);
  }

  setPatientDob(DateTime dob){
    print('dob');
    print(dob);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _incidentFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('Province', style: formLabelStyle),
                      ProvinceDropdown(setProvinceFunction: setIncidentProvince),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('District', style: formLabelStyle),
                      DistrictDropdown(setDistrictFunction: setIncidentDistrict),
                    ],
                  ),
                )
              ],
            ),
            // province dropdown
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Column(
                    children: <Widget>[
                      Text('City', style: formLabelStyle),
                      CityAutoCompleteField(),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Text('Locate Me', style: formLabelStyle),
                      GetLocationButton()
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Text('Patient Name', style: formLabelStyle),
            PatientNameField(),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('Patient Gender', style: formLabelStyle),
                      GenderDropdown(setGenderFunction: setPatientGender)
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('Date of Birth', style: formLabelStyle),
                      BirthDatePicker(setBirthDateFunction: setPatientDob)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text('Description of the Incident', style: formLabelStyle),
            IncidentDescriptionField(),
          ],
        ),
      ),
    );
  }
}

class IncidentFormButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormButton(buttonText: 'Send Report', buttonType: 'send'),
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
  final String selectedData;
  CustomDropdown({Key key, this.dropdownData, this.selectedData, this.selectFunction})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    // todo better approach to handle selected data other than widget.selectedData
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.0, style: BorderStyle.solid, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: widget.selectedData,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 30,
          elevation: 16,
          style: TextStyle(color: Colors.black, fontFamily: 'Raleway'),
          underline: Container(
            // making the default dropdown underline disappear
            color: Colors.transparent,
          ),
          onChanged: (String newValue) {
            setState(() {
              widget.selectFunction(newValue);
            });
          },
          // todo add province data to dropdown
          items:
          widget.dropdownData.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProvinceDropdown extends StatefulWidget {
  final setProvinceFunction;
  ProvinceDropdown({Key key, this.setProvinceFunction})
      : super(key: key);

  @override
  _ProvinceDropdownState createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  String selectedProvince = "Western";
  List<String> provinceDropdown = ['Western', 'Two', 'Free', 'Four'];
  // todo retrieve provinces
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
        dropdownData: provinceDropdown, selectedData: selectedProvince, selectFunction: widget.setProvinceFunction);
  }
}

class DistrictDropdown extends StatefulWidget {
  final setDistrictFunction;
  DistrictDropdown({Key key, this.setDistrictFunction})
      : super(key: key);

  @override
  _DistrictDropdownState createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  String selectedDistrict = "Colombo";
  List<String> districtDropdown = ['Colombo', 'Two', 'Free', 'Four'];
  // todo retrieve districts
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
        dropdownData: districtDropdown, selectedData: selectedDistrict, selectFunction: widget.setDistrictFunction,);
  }
}

class CityAutoCompleteField extends StatefulWidget {
  @override
  _CityAutoCompleteFieldState createState() => _CityAutoCompleteFieldState();
}

class _CityAutoCompleteFieldState extends State<CityAutoCompleteField> {
  // todo integrating with google maps API to autocomplete the location
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        focusNode: cityFocusNode,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).requestFocus(patientNameFocusNode),
        decoration: formFieldStyle,
      ),
    );
  }
}

class GetLocationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: RaisedButton(
          elevation: 5,
          onPressed: () => {
            // todo handle location retrieving logic
          },
//          borderSide: BorderSide(
//              width: 1.0, style: BorderStyle.solid, color: Colors.grey
//          ),
          color: Colors.lightBlue[700],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: Colors.blue)),
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          // showing the selected date on the button
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[Icon(Icons.my_location, color: Colors.white70,)],
          )),
    );
  }
}

class PatientNameField extends StatelessWidget{
  // todo getting the patient name

  String validatePatientName(String value){
    if (value.isEmpty) {
      return 'Please enter the patient name';
    }

    Pattern pattern =
        r"^[\\p{L} .'-]+$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please Enter a Valid Name Format';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        focusNode: patientNameFocusNode,
        textInputAction: TextInputAction.done,
        // determines the type of keyboard to show
        keyboardType: TextInputType.text,
        onEditingComplete: () => FocusScope.of(context).requestFocus(descriptionFocusNode),
        decoration: formFieldStyle,
        validator: validatePatientName,
      ),
    );
  }
}

class GenderDropdown extends StatefulWidget {
  final setGenderFunction;
  GenderDropdown({Key key, this.setGenderFunction})
      : super(key: key);
  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String selectedGender = 'Male';
  List<String> genderDropdown = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
        dropdownData: genderDropdown, selectedData: selectedGender, selectFunction: widget.setGenderFunction);
  }
}

class BirthDatePicker extends StatefulWidget {
  final setBirthDateFunction;
  BirthDatePicker({Key key, this.setBirthDateFunction})
      : super(key: key);
  @override
  _BirthDatePickerState createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime selectedDate = DateTime.now();
  DateTime endDate = DateTime.now();

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: OutlineButton(
          onPressed: () => _selectDate(context),
          borderSide: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.grey),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: Colors.grey)),
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          // showing the selected date on the button
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${selectedDate.toLocal()}'.split(' ')[0]),
              Icon(Icons.date_range)
            ],
          )),
    );
  }
}

class IncidentDescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        focusNode: descriptionFocusNode,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        decoration: formFieldStyle,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  // create buttons for the form with same appearance with different text and different functions
  final String buttonText;
  final String buttonType;
  FormButton({this.buttonText, this.buttonType});
  
  submitIncidentReport() {
    print('submit called');
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
            submitIncidentReport();
            // todo logic to send the report
          } else if (buttonType == 'cancel') {
            // routing back to home screen
            Navigator.pop(context);
          } else {
            // todo handle the error
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

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

// global styling for disabled form fields
InputDecoration disabledFormFieldStyle = InputDecoration(
  filled: true,
  fillColor: Colors.grey[300],
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


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                child: ProfileForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// profile details form
class ProfileForm extends StatelessWidget {
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
//              // contains the form field
              ProfileFormField(),
//              // contains the form action buttons
              ProfileFormButtons(),
            ],
          ),
        ));
  }
}

class ProfileFormField extends StatefulWidget {
  @override
  _ProfileFormFieldState createState() => _ProfileFormFieldState();
}

class _ProfileFormFieldState extends State<ProfileFormField> {
  final _profileFormKey = GlobalKey<FormState>();
  // todo data handling
  // todo data validation
  // adding text controllers to get data from the text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController telephoneNumberController = TextEditingController()..text = '0778755176';
  TextEditingController nicNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  // focus node for first name field
  FocusNode firstNameFocusNode = new FocusNode();
  // focus node for last name field
  FocusNode lastNameFocusNode = new FocusNode();
  // focus node for nic field
  FocusNode nicNumberFocusNode = new FocusNode();
  // focus node for email field
  FocusNode emailFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _profileFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 20.0),
            CustomProfileTextField(textData: firstNameController, focusNodeName: firstNameFocusNode, textFieldLabel: 'First Name'),
            SizedBox(height: 10.0),
            CustomProfileTextField(textData: lastNameController, focusNodeName: lastNameFocusNode, textFieldLabel: 'Last Name'),
            SizedBox(height: 10.0),
            TelephoneField(textFieldLabel: 'Telephone Number', textData: telephoneNumberController),
            SizedBox(height: 10.0),
            CustomProfileTextField(textData: nicNumberController, focusNodeName: nicNumberFocusNode, textFieldLabel: 'NIC Number'),
            SizedBox(height: 10.0),
            CustomProfileTextField(textData: emailController, focusNodeName: emailFocusNode, textFieldLabel: 'Email'),
          ],
        ),
      ),
    );
  }
}

class CustomProfileTextField extends StatefulWidget {
  // holds the data of the text Field
  final TextEditingController textData;
  final FocusNode focusNodeName;
  final String textFieldLabel;
  CustomProfileTextField({Key key, @required this.textData, @required this.focusNodeName, @required this.textFieldLabel}) : super(key: key);

  @override
  _CustomProfileTextFieldState createState() => _CustomProfileTextFieldState();
}

class _CustomProfileTextFieldState extends State<CustomProfileTextField> {
  bool readOnly = true;
  // todo fix warnings coming from the text fields
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Column(
              children: <Widget>[
                Text(widget.textFieldLabel, style: formLabelStyle),
                SizedBox(height: 5.0),
                TextFormField(
                  controller: widget.textData,
                  readOnly: readOnly,
                  focusNode: widget.focusNodeName,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    // removing focus from the text field upon pressing enter
                    FocusScope.of(context).unfocus();
                    setState(() {
                      // lock the field by disabling it
                      readOnly = true;
                    });
                  },
                  decoration: readOnly? disabledFormFieldStyle: formFieldStyle,
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                    icon: readOnly? Icon(Icons.edit): Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        // toggles edit on the field
                        readOnly = !readOnly;
                        FocusScope.of(context).requestFocus(widget.focusNodeName);
                      });
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class TelephoneField extends StatelessWidget {
  final textFieldLabel;
  final TextEditingController textData;
  TelephoneField({this.textFieldLabel, this.textData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Column(
              children: <Widget>[
                Text(textFieldLabel, style: formLabelStyle),
                SizedBox(height: 5.0),
                TextFormField(
                  controller: textData,
                  readOnly: true,
                  textInputAction: TextInputAction.done,
                  decoration: disabledFormFieldStyle,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFormButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormButton(buttonText: 'Change Details', buttonType: 'change'),
          FormButton(buttonText: 'Cancel', buttonType: 'cancel')
        ],
      ),
    );
  }
}

class FormButton extends StatelessWidget {
  // create buttons for the form with same appearance with different text and different functions
  final String buttonText;
  final String buttonType;
  FormButton({this.buttonText, this.buttonType});

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
              (buttonType == 'change') ? Colors.indigo[900] : Colors.red[900],
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
          if (buttonType == 'change') {
            // todo logic to change the profile
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


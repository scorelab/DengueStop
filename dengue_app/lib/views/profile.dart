import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:dengue_app/services/user_service.dart';
import 'package:dengue_app/models/user.dart';
import 'package:flutter/services.dart';

// global styling for form labels
TextStyle formLabelStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);

class Profile extends StatelessWidget {
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
                child: Text('My Profile',
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
class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
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
          ProfileFormField(),
        ],
      )),
    );
  }
}

class ProfileFormField extends StatefulWidget {
  @override
  _ProfileFormFieldState createState() => _ProfileFormFieldState();
}

class _ProfileFormFieldState extends State<ProfileFormField> {
  // adding text controllers to get data from the text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController telephoneNumberController = TextEditingController();
  TextEditingController nicNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _profileFormKey = GlobalKey<FormState>();
  final UserService userService = UserService();
  // focus node for first name field
  FocusNode firstNameFocusNode = new FocusNode();
  // focus node for last name field
  FocusNode lastNameFocusNode = new FocusNode();
  // focus node for nic field
  FocusNode nicNumberFocusNode = new FocusNode();
  // focus node for email field
  FocusNode emailFocusNode = new FocusNode();

  void initState() {
    super.initState();
    // setting current user data from the shared preferences
    userService.getUserData().then((value) {
      setUserDataFields(value);
    });
  }

  setUserDataFields(User user) {
    telephoneNumberController.text = user.telephone;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    nicNumberController.text = user.nicNumber;
    emailController.text = user.email;
  }

  String validateFirstName(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String validateLastName(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String validateNicNumber(String value) {
    return null;
  }

  String validateEmail(String value) {
    if (!EmailValidator.validate(value) && value.isNotEmpty) {
      return 'Enter proper email format';
    }
    return null;
  }

  submitUserDetails() {
    if (_profileFormKey.currentState.validate()) {
      // submitting updated details
      showEditConfirmation(context);
    }
  }

  saveUserDetails() async {
    // getting the updated user info from text controllers
    User updatedUser = User();
    updatedUser.firstName = firstNameController.text;
    updatedUser.lastName = lastNameController.text;
    updatedUser.nicNumber = nicNumberController.text;
    updatedUser.email = emailController.text;
    bool result = await userService.updateUser(updatedUser);
    if (result) {
      // show success message
      showUpdateStatus(
          context: context,
          titleText: 'Success',
          messageText: 'Your profile have successfully updated!');
    } else {
      // show error message
      showUpdateStatus(
          context: context,
          titleText: 'Oops',
          messageText: 'Something has gone wrong. Please try again.');
    }
  }

  showEditConfirmation(BuildContext context) {
    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: Colors.red)),
      onPressed: () {
        // save new details on confirmation
        saveUserDetails();
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
      title: Text("Confirm Changes!"),
      content: Text("Do you want to change the profile information?"),
      actions: [noButton, yesButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showUpdateStatus(
      {BuildContext context, String messageText, String titleText}) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        // save new details on confirmation
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titleText),
      content: Text(messageText),
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
    return Form(
      key: _profileFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 20.0),
            TelephoneField(
                textFieldLabel: 'Telephone Number',
                textData: telephoneNumberController),
            SizedBox(height: 10.0),
            CustomProfileTextField(
                textData: firstNameController,
                focusNodeName: firstNameFocusNode,
                textFieldLabel: 'First Name',
                validatorFunction: validateFirstName),
            SizedBox(height: 10.0),
            CustomProfileTextField(
                textData: lastNameController,
                focusNodeName: lastNameFocusNode,
                textFieldLabel: 'Last Name',
                validatorFunction: validateLastName),
            SizedBox(height: 10.0),
            CustomProfileTextField(
                textData: nicNumberController,
                focusNodeName: nicNumberFocusNode,
                textFieldLabel: 'NIC Number',
                validatorFunction: validateNicNumber),
            SizedBox(height: 10.0),
            CustomProfileTextField(
                textData: emailController,
                focusNodeName: emailFocusNode,
                textFieldLabel: 'Email',
                validatorFunction: validateEmail),
            // contains the form action buttons
            ProfileFormButtons(submitFunction: submitUserDetails),
          ],
        ),
      ),
    );
  }
}

class CustomProfileTextField extends StatefulWidget {
  // holds the data of the text Field
  TextEditingController textData;
  final FocusNode focusNodeName;
  final String textFieldLabel;
  final validatorFunction;
  CustomProfileTextField(
      {Key key,
      @required this.textData,
      @required this.focusNodeName,
      @required this.textFieldLabel,
      @required this.validatorFunction})
      : super(key: key);

  @override
  _CustomProfileTextFieldState createState() => _CustomProfileTextFieldState();
}

class _CustomProfileTextFieldState extends State<CustomProfileTextField> {
  bool isDisabled = true;
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
                TextFormField(
                  decoration: InputDecoration(
                      labelText: widget.textFieldLabel,
                      labelStyle: formLabelStyle),
                  controller: widget.textData,
                  focusNode: widget.focusNodeName,
                  validator: widget.validatorFunction,
                  readOnly: isDisabled,
                  inputFormatters: [
                    // restricting whitespaces
                    BlacklistingTextInputFormatter(RegExp('[ *]')),
                    // restricting length of input based on the field, 20 chars for NIC and 40 chars for others
                    LengthLimitingTextInputFormatter(
                        widget.textFieldLabel == 'NIC Number' ? 20 : 40)
                  ],
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    // removing focus from the text field upon pressing enter
                    FocusScope.of(context).unfocus();
                    setState(() {
                      // lock the field by disabling it
                      isDisabled = true;
                    });
                  },
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
              padding: EdgeInsets.only(top: 25),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                    icon: isDisabled ? Icon(Icons.edit) : Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        // toggles edit on the field
                        isDisabled = !isDisabled;
                        if (!isDisabled) {
                          // changing the focus to the enabled text field
                          FocusScope.of(context)
                              .requestFocus(widget.focusNodeName);
                        } else {
                          // removing the focus of disabled text field
                          FocusScope.of(context).unfocus();
                        }
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
                TextFormField(
                  decoration: InputDecoration(
                      labelText: textFieldLabel, labelStyle: formLabelStyle),
                  controller: textData,
                  readOnly: true,
                  textInputAction: TextInputAction.done,
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
  final submitFunction;
  ProfileFormButtons({this.submitFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormButton(
              buttonText: 'Change Details',
              buttonType: 'change',
              buttonFunction: submitFunction),
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
  final buttonFunction;
  FormButton({this.buttonText, this.buttonType, this.buttonFunction});

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
              color: (buttonType == 'change')
                  ? Colors.indigo[900]
                  : Colors.red[900],
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
            buttonFunction();
          } else if (buttonType == 'cancel') {
            // routing back to home screen
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

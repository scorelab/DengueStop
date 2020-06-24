import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dengue_app/models/user.dart';
import 'package:dengue_app/services/user_service.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
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
            child: SafeArea(child: SignupCard()),
          ),
        ));
  }
}

class SignupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 20.0,
        child: Column(
          children: <Widget>[
            Expanded(flex: 1, child: SignupCardImage()),
            Expanded(
              flex: 7,
              child: SignupForm(),
            )
          ],
        ),
      ),
    );
  }
}

class SignupCardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/login_pane_image.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                alignment: Alignment(0.0, -1.0)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        child: Center(
          child: Text(
            'Register to Dengue-Stop',
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  User user = User();
  final _signupFormKey = GlobalKey<FormState>();
  final userService = UserService();
  // focus nodes to change focus in the form
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode telephoneFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confirmPasswordFocusNode = new FocusNode();
  // text controllers to get data from the typed text forms
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  // styling for form labels
  TextStyle formLabelStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Raleway',
      color: Colors.black);
  // styling for form fields
  InputDecoration formFieldStyle = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(color: Colors.grey),
    ),
  );
  // asterisk for required fields
  TextSpan asterisk = TextSpan(
      text: '*',
      style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'Raleway',
          color: Colors.red));

  submitNewUser() {
    if (_signupFormKey.currentState.validate()) {
      saveUser();
    }
  }

  showUserCreatedAlert(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        // sends the user back to login
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: Text(
          "You have successfully registered in Dengue Stop! Please sign in to continue."),
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

  saveUser() async {
    user.firstName = firstNameController.text;
    user.lastName = lastNameController.text;
    user.telephone = telephoneController.text;
    user.password = passwordController.text;
    if (await userService.createUser(user)) {
      showUserCreatedAlert(context);
    } else {
      showErrorAlert(context);
    }
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String validateTelephone(String value) {
    if (value.isEmpty) {
      return 'Telephone Required';
    } else {
      if (value.length < 10) {
        return 'Telephone should contain 10 digits';
      }
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password Required';
    } else {
      if (value.length < 8) {
        return 'Password should be at least 8 characters';
      } else {
        if (passwordController.text != confirmPasswordController.text)
          return 'Passwords does not match';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _signupFormKey,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      child: TextFormField(
                          // changing focus to the lastname text field on pressing enter
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(lastNameFocusNode),
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: formLabelStyle),
                          validator: validateName,
                          controller: firstNameController,
                          // limiting characters to 40
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      child: TextFormField(
                          // changing focus to the telephone text field on pressing enter
                          textInputAction: TextInputAction.next,
                          focusNode: lastNameFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(telephoneFocusNode),
                          decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: formLabelStyle),
                          validator: validateName,
                          controller: lastNameController,
                          // limiting characters to 40
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),
                          ]),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextFormField(
                  // changing focus to the password text field on pressing enter
                  textInputAction: TextInputAction.done,
                  focusNode: telephoneFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
                  decoration: InputDecoration(
                      labelText: 'Telephone Number',
                      labelStyle: formLabelStyle),
                  validator: validateTelephone,
                  controller: telephoneController,
                  // switching to number keyboard
                  keyboardType: TextInputType.number,
                  // allowing only numbers to be typed
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextFormField(
                    // changing focus to the confirm password text field on pressing enter
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    focusNode: passwordFocusNode,
                    onEditingComplete: () => FocusScope.of(context)
                        .requestFocus(confirmPasswordFocusNode),
                    decoration: InputDecoration(
                        labelText: 'Password', labelStyle: formLabelStyle),
                    validator: validatePassword,
                    controller: passwordController, // limiting characters to 40
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(40),
                      // resticting whitespaces
                      BlacklistingTextInputFormatter(RegExp('[ *]'))
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextFormField(
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    focusNode: confirmPasswordFocusNode,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: formLabelStyle),
                    validator: validatePassword,
                    controller: confirmPasswordController,
                    // limiting characters to 40
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(40),
                      // resticting whitespaces
                      BlacklistingTextInputFormatter(RegExp('[ *]'))
                    ]),
              ),
              SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      submitNewUser();
                    },
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      // go back to login page by popping the navigation stack
                      Navigator.pop(context);
                    },
                    child: Text('Sign in here',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

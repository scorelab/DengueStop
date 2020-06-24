import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dengue_app/services/user_service.dart';

// main view of the login screen
class Login extends StatelessWidget {
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
            child: SafeArea(child: LoginCard()),
          ),
        ));
  }
}

// floating card on the login screen
class LoginCard extends StatelessWidget {
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
            Expanded(flex: 2, child: LoginCardImage()),
            Expanded(
              flex: 8,
              child: LoginForm(),
            )
          ],
        ),
      ),
    );
  }
}

// login card upper splash image
class LoginCardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('assets/images/login_pane_image.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
              alignment: Alignment(0.0, -1.0)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
    );
  }
}

// login form for the user
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final userService = UserService();
  final _loginFormKey = GlobalKey<FormState>();
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();
  // uses focus node to change focus from telephone field to password field on the press of enter in the keyboard
  FocusNode passwordFocusNode = new FocusNode();
  // styling for form labels
  TextStyle formLabelStyle =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);
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

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password Required';
    }
    if (value.length < 8) {
      return 'Password should at least contain 8 digits';
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

  submitLogin() async {
//    Navigator.pushNamed(context, 'home');
    if (_loginFormKey.currentState.validate()) {
      var username = telephoneController.text;
      var password = passwordController.text;
//      handling authentication and auth will return true when the user is authenticated
      var result =
          await userService.loginUser(username: username, password: password);
      if (result == true) {
//      resetting text fields
        telephoneController.text = '';
        passwordController.text = '';
        Navigator.pushNamed(context, 'home');
      } else {
        // todo handle error messages for each instance
        showAuthErrorAlert(context);
      }
    }
  }

  showAuthErrorAlert(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        // dismiss the popup
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Auth Failed"),
      content: Text("Something went wrong please try again."),
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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: <Widget>[
              Text(
                'Welcome to Dengue-Stop',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 30.0),
              Text('Telephone Number', style: formLabelStyle),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextFormField(
                  // changing focus to the password text field on pressing enter
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: validateTelephone,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: telephoneController,
                ),
              ),
              SizedBox(height: 30.0),
              Text('Password', style: formLabelStyle),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextFormField(
                  // unfocussing the password text field on pressing enter allowing the user to login
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  focusNode: passwordFocusNode,
                  validator: validatePassword,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                    // resticting whitespaces
                    BlacklistingTextInputFormatter(RegExp('[ *]'))
                  ],
                  controller: passwordController,
                ),
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
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      submitLogin();
                    },
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      // go to sign up page
                      Navigator.pushNamed(context, 'signup');
                    },
                    child: Text('Sign up here',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

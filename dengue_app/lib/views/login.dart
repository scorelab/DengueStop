import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

// main view of the login screen
class _LoginState extends State<Login> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(passwordFocusNode),
                decoration: formFieldStyle,
              ),
            ),
            SizedBox(height: 20.0),
            Text('Password', style: formLabelStyle),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: TextFormField(
                // unfocussing the password text field on pressing enter allowing the user to login
                textInputAction: TextInputAction.done,
                focusNode: passwordFocusNode,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: formFieldStyle,
              ),
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
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
                    // todo handle authentication before sending to homescreen
                    Navigator.pushNamed(context, 'home');
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
                    print('signup');
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
    );
  }
}

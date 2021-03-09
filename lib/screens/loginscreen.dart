import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoover/screens/brand_colors.dart';
import 'package:hoover/screens/mainpage.dart';
import 'package:hoover/screens/registrationpage.dart';
import 'package:hoover/widgets/ProgressDialog.dart';
import 'package:hoover/widgets/TaxiButton.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(status: 'Logging You In'),
    );
    final User user = (await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((ex) {
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;

    if (user != null) {
      //verify login
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('/users/${user.uid}');
      userRef.once().then((DataSnapshot snapshot) => {
            if (snapshot != null)
              {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  MainPage.id,
                  (route) => false,
                )
              }
          });
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Image.asset(
                  'images/logo.png',
                  height: 100.0,
                  width: 100.0,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Sign In as a Rider',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No Internet Connection');
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar('Please Enter a Valid Email');
                            return;
                          }

                          if (passwordController.text.length < 8) {
                            showSnackBar('Please a Valid Password');
                            return;
                          }
                          login();
                          Navigator.pushNamed(context, MainPage.id);
                        },
                        color: BrandColors.colorGreen,
                        title: 'LOGIN',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationPage.id);
                        },
                        child: Text('Sign Up?'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

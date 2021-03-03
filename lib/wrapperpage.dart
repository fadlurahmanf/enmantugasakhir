import 'package:enmantugasakhir/loginpage.dart';
import 'package:enmantugasakhir/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WrapperPage extends StatefulWidget {
  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  bool isLoggedIn;
  @override
  void initState() {
    // TODO: implement initState
    isLoggedIn = false;
    User user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      setState(() {
        isLoggedIn = true;
      });
    } else {

    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? HomePage() : LoginPage();
  }
}

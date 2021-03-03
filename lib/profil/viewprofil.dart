import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/firebasestorage.dart';
import 'package:enmantugasakhir/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String email = "";
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future currentUser()async{
      await AuthenticationService.currentUser().then((value){
        setState(() {
          user = value;
        });
      });
    }
    currentUser();
  }
  @override
  Widget build(BuildContext context) {
    if(user==null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      return SafeArea(child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 5*MediaQuery.of(context).size.height/15,
                color: Colors.green[600],
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                          }),
                          Text(user.email, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                          IconButton(icon: Icon(Icons.edit, color: Colors.white,), onPressed: (){}),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height/15,
                    ),
                    Expanded(child: FutureBuilder(
                      future: DatabaseServices.getUserData(email: user.email),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          DocumentSnapshot data = snapshot.data;
                          return FutureBuilder(
                            future: FirebaseStorageDatabase.getImage(profilepicturename: data.data()['profile picture']),
                            builder: (context, snapshot){
                              String profilepicture = snapshot.data;
                              if(snapshot.hasData){
                                return Center(
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(profilepicture),
                                  ),
                                );
                              }else{
                                return Center(
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.white,
                                    child: Text("NO PHOTO"),
                                  ),
                                );
                              }
                            },
                          );
                        }else{
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
                  ],
                ),
              ),
              // RaisedButton(onPressed: ()async{
              //   var result = await DatabaseServices.getUserData(email: user.email);
              //   DocumentSnapshot doc = result;
              //   print(doc.data()['profile picture']);
              // }),
              Expanded(
                child: FutureBuilder(
                  future: DatabaseServices.getUserData(email: user.email),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      DocumentSnapshot doc = snapshot.data;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.person_outline),
                                Text(doc.data()['full name']),
                              ],
                            ),
                          ],
                        ),
                      );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }
}

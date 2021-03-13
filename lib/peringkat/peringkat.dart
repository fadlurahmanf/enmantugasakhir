import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/firebasestorage.dart';
import 'package:enmantugasakhir/database/realtimedatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PeringkatPage extends StatefulWidget {
  @override
  _PeringkatPageState createState() => _PeringkatPageState();
}


class _PeringkatPageState extends State<PeringkatPage> {
  List<Peringkat> list = [];
  String email = '';
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future currentuser()async{
      await AuthenticationService.currentUser().then((value){
        setState(() {
          user = value;
        });
      });
    }
    currentuser();
  }
  @override
  Widget build(BuildContext context) {
    double _widthscreen = MediaQuery.of(context).size.width;
    if(user==null){
      return CircularProgressIndicator();
    }
    else{
      return SafeArea(child: Scaffold(
        appBar: AppBar(
          title: Text('PERINGKAT', style: TextStyle(color: Colors.white, letterSpacing: 2.0, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assetsphoto/icon_peringkat/picture1.jpg"),
                    fit: BoxFit.fitHeight
                  )
                ),
              ),
              // RaisedButton(onPressed: ()async{
              //   var result = await RealTimeDatabaseServices.getRewardWeekly();
              //   DataSnapshot data = result;
              //   Map<dynamic, dynamic> map = data.value;
              //   List<Peringkat> listdata = [Peringkat(email: "tffajari",score: 50),Peringkat(email: "ashrioktaviani",score: 50),Peringkat(email: "tffajari",score: 50),Peringkat(email: "ashrioktaviani",score: 50)];
              //   List<Peringkat> listbaru = [];
              // }),
              Expanded(child: FutureBuilder(
                future: RealTimeDatabaseServices.getRewardWeekly(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    DataSnapshot data = snapshot.data;
                    Map<dynamic, dynamic> map = data.value;
                    list.clear();
                    map.forEach((key, value) {
                      list.add(Peringkat(email: key, score: int.parse(value['weeklypoint'])));
                    });
                    list.sort((a,b)=>b.score.compareTo(a.score));
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index){
                        String email = "${list[index].email}@gmail.com";
                        return Container(
                            width: 8*_widthscreen/10,
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                          child: Row(
                            children: <Widget>[
                              FutureBuilder(
                                  future: DatabaseServices.getUserData(
                                      email: email),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      DocumentSnapshot result = snapshot.data;
                                      return result.data()['profile picture'] !=
                                              null
                                          ? FutureBuilder(
                                              future: FirebaseStorageDatabase
                                                  .getImage(
                                                      profilepicturename: result
                                                              .data()[
                                                          'profile picture']),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  String profilepicture =
                                                      snapshot.data;
                                                  return CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            profilepicture),
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              },
                                            )
                                          : CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.grey,
                                            );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  }),
                              SizedBox(width: 15,),
                              Expanded(child: Text(list[index].email, style: list[index].email==user.email.split("@")[0]? TextStyle(letterSpacing: 1.0, fontSize: 17,fontWeight: FontWeight.bold, color: Colors.white) : null,)),
                              Container(
                                child: (index + 1).toString() == "1"
                                    ? Image.asset(
                                        "assetsphoto/medal1.png",
                                        height: 30,
                                      )
                                    : (index + 1).toString() == "2"
                                        ? Image.asset(
                                            "assetsphoto/medal2.png",
                                            height: 30,
                                          )
                                        : null,
                                width: _widthscreen / 10,
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(margin: EdgeInsets.symmetric(horizontal: 10),child: Text(list[index].score.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: user.email == email
                                  ? Colors.green[600]
                                  : Colors.white,
                              border: Border.all(
                                  color: user.email == email
                                      ? Colors.green[600]
                                      : Colors.teal[900]),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal[900],
                                  offset: Offset(-3, 5),
                                )
                              ]),
                        );
                      },
                    );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
              )),
            ],
          ),
        ),
      ));
    }
  }
}

class Peringkat{
  String email;
  int score;
  File profilepicture;
  Peringkat({this.email, this.score, this.profilepicture});
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:enmantugasakhir/KonsumsiEnergiPage/detailenergipage.dart';
import 'package:enmantugasakhir/KonsumsiEnergiPage/energyconsumptiongraphicpage.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/realtimedatabase.dart';
import 'package:enmantugasakhir/drawer.dart';
import 'package:enmantugasakhir/loginpage.dart';
import 'package:enmantugasakhir/peringkat/peringkat.dart';
import 'package:enmantugasakhir/profil/viewprofil.dart';
import 'package:enmantugasakhir/reward/reward.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  String fullname = "";
  String uid = "";
  String email = "";
  String kwh = "";
  String date = DateFormat('dd MMM yyyy').format(DateTime.now());

  @override
  void initState() {
    // User user = FirebaseAuth.instance.currentUser;
    // if (user!=null){
    //   setState(() {
    //     email = user.email;
    //   });
    // }
    super.initState();
    Future getCurrentUser()async{
      await AuthenticationService.currentUser().then((value){
        setState(() {
          user = value;
          email=user.email;
        });
      });
      var result = await DatabaseServices.getUserData(email: email);
      DocumentSnapshot data = result;
      setState(() {
        fullname = data.data()['full name'];
      });
    }
    getCurrentUser();
    getDataEnergyUser();
  }

  @override
  Widget build(BuildContext context) {
    if(user==null){
      return CircularProgressIndicator();
    }else{
      return SafeArea(
        child: Scaffold(
          drawer: MainDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage('assetsphoto/home.png'),height: 25,),
                  SizedBox(width: 10,),
                  Text('HOME', style: TextStyle(letterSpacing: 3.0,color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),),
                ],
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.exit_to_app, color: Colors.black,), onPressed: ()async{
                await AuthenticationService.logOutUser();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                //showConfirmLogOutBox();
              })
            ],
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            Container(
                                alignment: Alignment.center,
                                child: Text('PROFIL', style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold, letterSpacing: 3.0,),)),
                            SizedBox(height: 15.0,),
                            Text('Nama : ' + fullname, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0),),
                            SizedBox(height: 15.0,),
                            Text('Email : ' + email, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0),),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0,3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Container(alignment: Alignment.centerLeft,margin: EdgeInsets.symmetric(horizontal: 30.0),child: Text('Konsumsi energi', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, letterSpacing: 1.0,),)),
                    Container(alignment: Alignment.centerLeft,margin: EdgeInsets.symmetric(horizontal: 30.0),child: Text(date, style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),)),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GraphicEnergyConsumption()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 190,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              height: 200,
                              width: 180,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Image(image: AssetImage('assetsphoto/homepage/statistics.png')),
                                      // height: 60,
                                      margin: EdgeInsets.symmetric(vertical: 15.0),
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text('GRAFIK', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text('PENGGUNAAN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text('ENERGI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(-2,3),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailKonsumsiEnergiPage()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                height: 200,
                                width: 180,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(child: Image.asset("assetsphoto/homepage/thunderbolt.png")),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 65,
                                      child: FutureBuilder(
                                        future: getDataEnergyUser(),
                                        builder: (context, snapshot){
                                          if(snapshot.hasData){
                                            DataSnapshot data = snapshot.data;
                                            if(data.value!=null) {
                                              return Text(data.value['kwh'] == null ? "NULL" : data.value['kwh'] + " kwh", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -1),);
                                            }
                                            else {
                                              return Text("NULL", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0),);
                                            }
                                            }else{
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 1.0),
                                      child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 1.0),
                                      child: Text('ENERGI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(-2,3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      height: 190,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PeringkatPage()));
                            },
                            child: Container(
                              height: 200,
                              width: 180,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assetsphoto/homepage/podium.png", scale: 7,),
                                  SizedBox(height: 20,),
                                  Text("PERINGKAT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 16))
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(-2,3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>RewardPage()));
                            },
                            child: Container(
                              height: 200,
                              width: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assetsphoto/homepage/reward.png", scale: 8,),
                                  SizedBox(height: 20,),
                                  Text("REDEEM", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                  SizedBox(height: 5,),
                                  Text("POINT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(-2,3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future getUserData() async{
    DocumentSnapshot userdata = await DatabaseServices.getUserData(email: email);
    if(userdata!=null){
      setState(() {
        fullname = userdata.data()['full name'];
      });
      setState(() {
        uid = userdata.data()['uid'];
      });
    }
    //dibawah harus mengembalikan !=null biar perintah di Futurebuilder tidak masuk ke else yaitu circulasprogressindicatot atau loafing
    return userdata.toString();
  }

  Future getDataEnergyUser()async{
    DataSnapshot data = await RealTimeDatabaseServices.getDataEnergyUser();
    setState(() {
      kwh = data.value['kwh'];
    });
    return data;
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/realtimedatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetailKonsumsiEnergiPage extends StatefulWidget {
  @override
  _DetailKonsumsiEnergiPageState createState() => _DetailKonsumsiEnergiPageState();
}

class _DetailKonsumsiEnergiPageState extends State<DetailKonsumsiEnergiPage> {

  String tegangan = "";
  String arus = "";
  String kwh = "";
  String lamapemakaian = "";
  String jamlamapemakaian = "";
  String menitlamapemakaian = "";
  String rewardpoint = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Container(
            child: Text('DETAIL ENERGI', style: TextStyle(letterSpacing: 2.0),),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey[100],
            child: FutureBuilder(
              future: getDataAsFuture(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data != null) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: 350,
                            height: 130,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: <Widget>[
                                Container(alignment: Alignment.center,
                                  child: Text('TEGANGAN', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),),),
                                SizedBox(height: 40,),
                                Container(alignment: Alignment.center,
                                  child: Text(tegangan + " volt",
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3.0),),)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green[600]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[600],
                                    offset: Offset(-5, 5),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: 350,
                            height: 130,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: <Widget>[
                                Container(alignment: Alignment.center,
                                  child: Text('ARUS', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),),),
                                SizedBox(height: 40,),
                                Container(alignment: Alignment.center,
                                  child: Text(arus + " ampere",
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3.0),),)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green[600]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[600],
                                    offset: Offset(-5, 5),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: 350,
                            height: 130,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: <Widget>[
                                Container(alignment: Alignment.center,
                                  child: Text('KWH', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),),),
                                SizedBox(height: 40,),
                                Container(alignment: Alignment.center,
                                  child: Text(kwh + " kwh", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3.0),),)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green[600]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[600],
                                    offset: Offset(-5, 5),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: 350,
                            height: 130,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: <Widget>[
                                Container(alignment: Alignment.center,
                                  child: Text('LAMA PEMAKAIAN', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),),),
                                SizedBox(height: 40,),
                                Container(alignment: Alignment.center,
                                  child: Text(
                                    jamlamapemakaian + " JAM " + menitlamapemakaian + " MENIT ",
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3.0),),)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green[600]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[600],
                                    offset: Offset(-5, 5),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: 350,
                            height: 130,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: <Widget>[
                                Container(alignment: Alignment.center,
                                  child: Text('SAKLAR', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),),),
                                SizedBox(height: 40,),
                                Container(alignment: Alignment.center,
                                  child: Text(
                                    double.parse(arus) <= 0.04 ? 'OFF' : 'ON',
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3.0),),)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green[600]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[600],
                                    offset: Offset(-5, 5),
                                  )
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: 350,
                            height: 130,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              children: <Widget>[
                                Container(alignment: Alignment.center,
                                  child: Text('POINT', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),),),
                                SizedBox(height: 40,),
                                Container(alignment: Alignment.center,
                                  child: Text(
                                    rewardpoint,
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3.0),),)
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green[600]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green[600],
                                    offset: Offset(-5, 5),
                                  )
                                ]
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                } else {
                  return Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 20.0,),
                          Text(snapshot.data.toString()),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  getDataAsFuture()async{
    //dapetin username
    User user = FirebaseAuth.instance.currentUser;
    var email = user.email;
    var username = email.split("@");

    DateTime now = DateTime.now();
    var tanggalhari_ini = now.day.toString()+"-"+now.month.toString()+"-"+now.year.toString();

    FirebaseDatabase firebasedatabase = FirebaseDatabase.instance;
    await firebasedatabase.reference().once().then((value){
      var data = value.value["${username[0]}"]["${tanggalhari_ini}"];
      if(data['volt']==null){
        tegangan = "NULL";
      }
      if(data['current']==null){
        arus = "NULL";
      }
      if(data['kwh']==null){
        kwh = "NULL";
      }
      if(data['lamapemakaian']==null){
        lamapemakaian = "NULL";
      }
      if(data['point']==null){
        rewardpoint= "NULL";
      }
      if(data['volt']!=null && data['current']!=null && data['kwh']!=null && data['lamapemakaian']!=null&&data['point']!=null) {
        tegangan = data["volt"];
        arus = data["current"];
        kwh = data["kwh"];
        lamapemakaian = data['lamapemakaian'];
        rewardpoint = data['point'];
      }
      jamlamapemakaian = (lamapemakaian.split("."))[0];
      double menit = (double.parse(lamapemakaian)-double.parse(jamlamapemakaian))*60;
      menitlamapemakaian = (menit.toString().split("."))[0];
      setState(() {

      });
    });
    return 'dataelectricty';
  }
}

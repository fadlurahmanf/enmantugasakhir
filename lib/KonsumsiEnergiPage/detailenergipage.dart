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
  String jampemakaian = "";
  String menitpemakaian = "";
  String rewardpointharian = "";

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
            margin: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            color: Colors.white,
            // height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: RealTimeDatabaseServices.getDataEnergyUser_Stream(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  Event data = snapshot.data;
                  kwh = data.snapshot.value['kwh'];
                  arus = data.snapshot.value['current'];
                  tegangan = data.snapshot.value['volt'];
                  lamapemakaian = data.snapshot.value['lamapemakaian']; //dalam satuan jam
                  rewardpointharian = data.snapshot.value['pointharian'];

                  double waktupemakaian = double.parse(lamapemakaian)*60; //dalam satuan menit

                  jampemakaian = (waktupemakaian/60).toString().split(".")[0];

                  menitpemakaian = "0.${(waktupemakaian/60).toString().split(".")[1]}";

                  double hitungmenitpemakaian = (double.parse(menitpemakaian)*60).roundToDouble();

                  menitpemakaian = hitungmenitpemakaian.toInt().toString();

                  print("${jampemakaian} jam & ${menitpemakaian} menit");

                  return Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // height: 250,
                              width: 3*MediaQuery.of(context).size.width/5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage("assetsphoto/icon_detail_energi/picture1.jpg"),
                                  fit: BoxFit.fitWidth
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text("KWH", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                    Text("${kwh}", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-5, 2),
                              blurRadius: 5,
                              color: Colors.black26
                            )
                          ]
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // height: 250,
                              width: 3*MediaQuery.of(context).size.width/5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("assetsphoto/icon_detail_energi/picture4.jpg"),
                                    fit: BoxFit.fitWidth
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text("ARUS", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                    Text("${arus}", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-5, 2),
                                  blurRadius: 5,
                                  color: Colors.black26
                              )
                            ]
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // height: 250,
                              width: 3*MediaQuery.of(context).size.width/5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("assetsphoto/icon_detail_energi/picture3.jpg"),
                                    fit: BoxFit.fitWidth
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text("VOLT", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                    Text("${tegangan}", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-5, 2),
                                  blurRadius: 5,
                                  color: Colors.black26
                              )
                            ]
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // height: 250,
                              width: 3*MediaQuery.of(context).size.width/5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage("assetsphoto/icon_detail_energi/picture2.jpg"),
                                    fit: BoxFit.fitWidth
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text("WAKTU", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                    Text("${jampemakaian} JAM", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                    Text("${menitpemakaian} MENIT", style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(-5, 2),
                                  blurRadius: 5,
                                  color: Colors.black26
                              )
                            ]
                        ),
                      ),
                    ],
                  );
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/firebasestorage.dart';
import 'package:enmantugasakhir/database/realtimedatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  String email;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future getCurrentUser()async{
      await AuthenticationService.currentUser().then((value) {
        setState(() {
          user = value;
        });
      });
    }
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    if(user==null){
      return Center(child: CircularProgressIndicator());
    }else{
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("REDEEM REWARD", style: TextStyle(letterSpacing: 1.0),),
            centerTitle: true,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Your EnMan Currency : ", style: TextStyle(fontWeight: FontWeight.bold),),
                      FutureBuilder(
                        future: RealTimeDatabaseServices.getRewardWeekly(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            DataSnapshot data = snapshot.data;
                            Map<dynamic, dynamic> map = data.value;
                            email = user.email.split("@")[0];
                            Map rewardweekly = map['${email}'];
                            return Text(rewardweekly['virtualcurrency'], style: TextStyle(fontWeight: FontWeight.bold),);
                          }else{
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(width: 10,),
                      Image.asset("assetsphoto/dollar.png", scale: 18,)
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal[600]),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                FutureBuilder(
                  future: DatabaseServices.getAllReward(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      QuerySnapshot data = snapshot.data;
                      List<QueryDocumentSnapshot> listdata = data.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: listdata.length,
                        itemBuilder: (context, index){
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal[900]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listdata[index].data()['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.0),),
                                Row(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: FirebaseStorageDatabase.getImageReward(picture: listdata[index].data()['picture']),
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          return Container(
                                            height: 120,
                                            width: 120,
                                            child: Image.network("${snapshot.data}"),
                                          );
                                        }else{
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(listdata[index].data()['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                              SizedBox(width: 10,),
                                              Image.asset("assetsphoto/dollar.png", scale: 18,),
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.center,
                                          ),
                                          SizedBox(
                                            child: RaisedButton(onPressed: ()async{
                                              var result = await RealTimeDatabaseServices.getVirtualCurrency(email: user.email.split("@")[0]);
                                              DataSnapshot data = result;
                                              Map<dynamic, dynamic> mapreward = data.value;
                                              int virtualcurrencyuser = int.parse(mapreward['virtualcurrency']);
                                              int rewardprice = int.parse(listdata[index].data()['price']);
                                              int newvirtualcurrencyuser = virtualcurrencyuser-rewardprice;
                                              if(virtualcurrencyuser>=rewardprice){
                                                var result = await RealTimeDatabaseServices.updateVirtualCurrency(email: user.email.split("@")[0],newvirtualcurrency: newvirtualcurrencyuser.toString());
                                                if(result=='succeed'){
                                                  successDialog(context, "PEMBELIAN SUKSES");
                                                  setState(() {

                                                  });
                                                }
                                              }else{
                                                errorDialog(context, "UANG TIDAK MENCUKUPI");
                                              }
                                            },child: Text("BELI", style: TextStyle(color: Colors.white),),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: Colors.teal[900])
                                            ),
                                              color: Colors.teal[900],
                                            ),
                                            width: 150,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }else{
                      return Expanded(child: Center(child: CircularProgressIndicator()));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

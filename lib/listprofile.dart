import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/firebasestorage.dart';
import 'package:enmantugasakhir/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListProfile extends StatefulWidget {
  @override
  _ListProfileState createState() => _ListProfileState();
}

class _ListProfileState extends State<ListProfile> {
  String emailreceiver;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future getCurrentUser()async{
      await AuthenticationService.currentUser().then((value){
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
      return SafeArea(child: Scaffold(
        appBar: AppBar(
          title: Text("DAFTAR PENGGUNA", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
            future: DatabaseServices.getAllUser(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                QuerySnapshot data = snapshot.data;
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index){
                    if(data.docs[index].data()['email']==user.email){
                      return Container(child: null,);
                    }else{
                      return GestureDetector(
                        onTap: ()async{
                          emailreceiver = data.docs[index].data()['email'];
                          var result = await DatabaseServices.getChatRoomID(emailsender: user.email, emailreceiver: emailreceiver);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Message(chatroomid: result,emailreceiver: data.docs[index].data()['email'],)));
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Row(
                            children: [
                              FutureBuilder(
                                future: DatabaseServices.getUserData(email: data.docs[index].data()['email']),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    DocumentSnapshot data2 = snapshot.data;
                                    return FutureBuilder(
                                      future: FirebaseStorageDatabase.getImage(profilepicturename: data2.data()['profile picture']),
                                      builder: (context, snapshot){
                                        String profilepicture = snapshot.data;
                                        if(snapshot.hasData){
                                          return CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(profilepicture),
                                          );
                                        }else{
                                          return CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.green[600],
                                            child: Text("${data.docs[index].data()['email'][0].toString().toUpperCase()}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          );
                                        }
                                      },
                                    );
                                  }else{
                                    return CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 30,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              SizedBox(width: 10,),
                              Text(data.docs[index].data()['email'], style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 16),),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              }else{
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
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
          title: Text("DAFTAR PENGGUNA"),
          centerTitle: true,
        ),
        body: Container(
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
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(data.docs[index].data()['email']),
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

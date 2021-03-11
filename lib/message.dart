import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  String chatroomid;
  String emailreceiver;
  Message({this.emailreceiver,this.chatroomid});
  @override
  _MessageState createState() => _MessageState(emailreceiver: emailreceiver,chatroomid: chatroomid);
}

class _MessageState extends State<Message> {
  String chatroomid;
  String emailreceiver;
  _MessageState({this.emailreceiver,this.chatroomid});

  User user;
  TextEditingController messagetext = TextEditingController();
  Stream getConversationMessageStream;

  @override
  void initState() {
    // TODO: implement initState
    DatabaseServices.getConversationMessage(chatroomid: chatroomid).then((value){
      setState(() {
        getConversationMessageStream = value;
      });
    });
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

  Widget MessageConversationList(){
    return StreamBuilder(
      stream: getConversationMessageStream,
      builder: (context, snapshot){
        QuerySnapshot data = snapshot.data;
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index){
              bool isSendByMe = data.docs[index].data()['sendBy'] == user.email;
              var message = data.docs[index].data()['message'];
              return MessageTile(message: message,isSendByMe: isSendByMe,);
            },
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(user==null){
      return Center(child: CircularProgressIndicator(),);
    }else{
      return SafeArea(child: Scaffold(
        appBar: AppBar(
          title: Text("${emailreceiver}"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: Container(color: Colors.white,child: MessageConversationList()),),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: messagetext,
                        decoration: InputDecoration(
                          hintText: "tulis pesan"
                        ),
                      ),
                    ),
                    RaisedButton(onPressed: ()async{
                      Map<String, dynamic> messagemap = {"message" : "${messagetext.text}", "sendBy" : "${user.email}", "time":DateTime.now().millisecondsSinceEpoch};
                      if(messagetext.text.trim().isNotEmpty){
                        await DatabaseServices.addConversationMessage(chatroomid: chatroomid, messagemap: messagemap);
                        messagetext.text = "";
                      }
                    },child: Text("pesen"),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({this.message, this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: isSendByMe? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                  topLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                  topLeft: Radius.circular(23),
                ),
          color: isSendByMe ? Colors.green[600] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: isSendByMe? Offset(1.0, 2.0) : Offset(-1.0, 2.0),
            )
          ]
        ),
        child: Text("${message}"),
      ),
    );
  }
}

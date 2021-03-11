import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  static CollectionReference rewardReference = FirebaseFirestore.instance.collection('rewards');
  static CollectionReference databaseUser= FirebaseFirestore.instance.collection('users');
  static CollectionReference chatReference = FirebaseFirestore.instance.collection('chats');

  //INSERT DATA USER TO DATABASE CLOUD FIRESTORE
  static Future<void> insertUserToDatabase({String uid, String email, String fullname, String phonenumber, String pass, String profilepicture}) async {
    await databaseUser.doc(email).set({
      'uid': uid,
      'email':email,
      'full name':fullname,
      'phone number': phonenumber,
      'password':pass,
      'profile picture' : profilepicture,
    });
  }

  static Future<DocumentSnapshot> getUserData({String email}) async{
    return await databaseUser.doc(email).get();
  }

  static Future getAllUser()async{
    try{
      var result = await databaseUser.get();
      return result;
    }catch(e){
      return e.toString();
    }
  }

  //GET DATA REWARD
  static Future getAllReward()async{
    try{
      var result = await rewardReference.get();
      return result;
    }catch(e){
      return e.toString();
    }
  }

  static Future getChatRoomID({String emailsender, String emailreceiver})async{
    try{
      List listchatroomid = [];
      List users = [];
      String chatroomid = "";
      var result = await chatReference.get();
      QuerySnapshot data = result;
      data.docs.forEach((element) {
        listchatroomid.add(element.id);
      });
      if(listchatroomid.contains("${emailsender}_${emailreceiver}")){
        chatroomid = "${emailsender}_${emailreceiver}";
      }else if(listchatroomid.contains("${emailreceiver}_${emailsender}")){
        chatroomid = "${emailreceiver}_${emailsender}";
      }else{
        chatroomid = "${emailsender}_${emailreceiver}";
        users = ["${emailsender}", "${emailreceiver}"];
        await chatReference.doc("${chatroomid}").set({
          "users" : users
        });
      }
      return chatroomid;
    }catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  //get conversation message
  static getConversationMessage({String chatroomid})async{
    return chatReference.doc(chatroomid).collection("message").orderBy("time", descending: false).snapshots();
  }

  static Future addConversationMessage({String chatroomid, Map messagemap})async{
    try{
      var result = await chatReference.doc(chatroomid).collection("message").add(messagemap);
      return result;
    }catch(e){
      return e.toString();
    }
  }

}
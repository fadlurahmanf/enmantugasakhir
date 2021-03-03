import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  static CollectionReference rewardReference = FirebaseFirestore.instance.collection('rewards');
  static CollectionReference databaseUser= FirebaseFirestore.instance.collection('users');

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

  static Stream getDocumentIDfromCollection(){
    return databaseUser.snapshots();
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

}
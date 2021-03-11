import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDatabaseServices{
  //get tanggal hari ini
  static DateTime now = DateTime.now();
  static var tanggalhariIni = now.day.toString()+"-"+now.month.toString()+"-"+now.year.toString();

  static FirebaseDatabase firebasedatabase = FirebaseDatabase.instance;

  //get email
  static User user = FirebaseAuth.instance.currentUser;
  static String email = user.email;
  static var username = email.split('@');

  static Future getData()async{
    var result = await firebasedatabase.reference().child("${username[0]}").child("$tanggalhariIni").once();
    return result;
  }

  static Future getFromUsername()async{
    var result = await firebasedatabase.reference().child("${username[0]}").once();
    return result;
  }

  static Stream getDataStream(){
    var result = firebasedatabase.reference().child("${username[0]}").child("$tanggalhariIni").once();
    return result.asStream();
  }

  // static Future getAllData()async{
  //   var result = firebasedatabase.reference().child("energi").once();
  //   return result;
  // }

  static Future getRewardWeekly()async{
    var result = firebasedatabase.reference().child("reward").once();
    return result;
  }

  //GET VIRTUAL CURRENCY USER
  static Future getVirtualCurrency({String email})async{
    try{
      var result =  await firebasedatabase.reference().child("reward").child("${email}").once();
      return result;
    }catch(e){
      return e.toString();
    }
  }

  //SET NEW VIRTUAL CURRENCY USER AFTER HE BUY SOMETHING
  static Future updateVirtualCurrency({String email,String newvirtualcurrency})async{
    try{
      await firebasedatabase.reference().child("reward").child("${email}").update({
        "virtualcurrency" : "${newvirtualcurrency}",
      });
      return 'succeed';
    }catch(e){
      return e.toString();
    }
  }
}
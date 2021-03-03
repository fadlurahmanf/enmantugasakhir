import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDatabase{
  static Future uploadImage({String profilepicturename, File profilepicture})async{
    try{
      StorageReference reference = FirebaseStorage.instance.ref().child("profilepictures/${profilepicturename}");
      StorageUploadTask uploadtask = reference.putFile(profilepicture);
      await uploadtask.onComplete;
      print("berhasil");
    }catch(e){
      print(e.toString());
    }
  }

  static Future getImage({String profilepicturename})async{
    try{
      StorageReference reference = FirebaseStorage.instance.ref().child("profilepictures/${profilepicturename}");
      var result = await reference.getDownloadURL();
      return result;
    }catch(e){
      return e.toString();
    }
  }
  static Future getImageReward({String picture})async{
    try{
      StorageReference reference = FirebaseStorage.instance.ref().child("rewards/bsKDBBKSBbba.jpg");
      var result = await reference.getDownloadURL();
      return result;
    }catch(e){
      return e.toString();
    }
  }
}
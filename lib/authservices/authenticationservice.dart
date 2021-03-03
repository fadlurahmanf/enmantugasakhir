import 'package:firebase_auth/firebase_auth.dart';
class AuthenticationService{
  static FirebaseAuth _auth = FirebaseAuth.instance;

  //REGISTER USER
  static Future registerUser(String email, String pass) async{
    String _message="";
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User user = result.user;
      await user.sendEmailVerification();
      return user.uid;
    } on FirebaseAuthException catch (e){
      if(e.code=='email-already-in-use'){
        _message=e.code;
        return _message;
      } else {
        return null;
      }
    }
  }

  //SIGN IN USER
  static Future signInUser(String email, String pass) async{
    String _message="";
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User user = result.user;
      /*if(user.emailVerified){
        await user.sendEmailVerification();
        return user.email;
      } else{
        return null;
      }*/
      return user.email;
    } on FirebaseAuthException catch (e){
      _message=e.code;
    }
    return _message;
  }

  static Future currentUser() async {
    User user = _auth.currentUser;
    return user;
  }

  static Future logOutUser() async{
    await _auth.signOut();
  }
}

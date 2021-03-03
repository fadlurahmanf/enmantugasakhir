import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/realtimedatabase.dart';
import 'package:enmantugasakhir/homepage.dart';
import 'package:enmantugasakhir/wrapperpage.dart';
import 'file:///C:/Users/ASUS/AndroidStudioProjects/enmantugasakhir/lib/register/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool passwordVisibility = true;
  bool emailValidate = false;
  bool passwordValidate = false;

  final _formkey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('HELLO FRIENDS!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 70.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFormField(
                      autovalidate: emailValidate,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(letterSpacing: 2.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person,color: Colors.grey[600],),
                        hintStyle: (TextStyle(letterSpacing: 2.0)),
                        hintText: 'Email',
                      ),
                      onChanged: (val){
                        if(val.length>0){
                          setState(() {
                            emailValidate = true;
                          });
                        }
                      },
                      validator: EmailValidator(errorText: 'Email Adress is not valid'),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFormField(
                      autovalidate: passwordValidate,
                      controller: _passController,
                      obscureText: passwordVisibility,
                      style: TextStyle(letterSpacing: 2.0),
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock,color: Colors.grey[600],),
                        hintText: 'Password',
                        suffixIcon:IconButton(
                          icon: Icon(passwordVisibility ?Icons.visibility_off:Icons.visibility,color: Colors.grey[600],),
                          onPressed: (){
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                            });
                          },
                        ),
                      ),
                      onChanged: (val){
                        if(val.length>0){
                          setState(() {
                            passwordValidate = true;
                          }
                          );
                        }
                      },
                      validator: (val){
                        if((val.length>0)&&(val.length<7)){
                          return "Password must have minimal 7 character";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 70.0,),
                  RaisedButton(onPressed: () async {
                    if((_formkey.currentState.validate())&&(_emailController.text.length!=0)&&(_passController.text.length!=0)){
                      dynamic result = await AuthenticationService.signInUser(_emailController.text, _passController.text);
                      print(result);
                      if(result==_emailController.text){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      }
                      else{
                        result='EMAIL DAN PASSWORD SALAH';
                        showErrorBox(result);
                      }
                    }
                  },
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                    child: Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, letterSpacing: 3.0),),
                    color: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(5.0)
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Belum punya akun ?", style: TextStyle(letterSpacing: 2.0,fontSize: 14.0,color: Colors.grey[700])),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                        },
                        child: Text(' DAFTAR', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.grey[700])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //SHOW MESSAGE BOX WHEN CLICK LOGIN
  Future showErrorBox(result)async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 80,
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    alignment: Alignment.center,
                    child: Text('ERROR', style: TextStyle(fontSize: 30.0,letterSpacing: 1.0, color: Colors.grey[800], fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    alignment: Alignment.center,
                    child: Text(result),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(onTap: (){
                Navigator.of(context).pop();
              },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 10),
                  child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  padding: EdgeInsets.fromLTRB(20, 10, 15, 15)
                ),),
            ],
          );
        }
    );
  }
}

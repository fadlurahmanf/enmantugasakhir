import 'dart:io';
import 'dart:math';

import 'package:commons/commons.dart';
import 'package:enmantugasakhir/authservices/authenticationservice.dart';
import 'package:enmantugasakhir/database/databaseservices.dart';
import 'package:enmantugasakhir/database/firebasestorage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool emailValidate = false;
  bool fullnameValidate = false;
  bool phoneNumberValidate = false;
  bool passwordValidate = false;
  bool confpassValidate = false;

  final _formkey = GlobalKey<FormState>();

  File _image;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confpassController = TextEditingController();

  clearTextInput(){
    _emailController.clear();
    _fullnameController.clear();
    _phoneNumberController.clear();
    _passController.clear();
    _confpassController.clear();
  }

  Future pickImage()async{
    print("hello");
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    SizedBox(height: 50.0,),
                    Container(
                      child: Text('REGISTER HERE !',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0,),
                    GestureDetector(
                      onTap: ()async{
                        await pickImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 100,
                        backgroundImage: _image!=null ? FileImage(_image)
                        : null,
                        child: _image!=null? null : Icon(Icons.camera_alt, size: 30, color: Colors.white,),
                      ),
                    ),
                    Container(
                      child: _image==null? null : IconButton(icon: Icon(Icons.cancel), onPressed: (){
                        setState(() {
                          _image=null;
                        });
                      }),
                    ),
                    SizedBox(height: 35.0,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextFormField(
                        autovalidate: emailValidate,
                        style: TextStyle(letterSpacing: 2.0),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email, color: Colors.grey[600],),
                          hintText: 'Email'
                        ),
                        onChanged: (val){
                          if(val.length>0){
                            setState(() {
                              emailValidate = true;
                            });
                          }
                        },
                        validator: EmailValidator(errorText: "Email Address is not valid"),
                      ),
                    ),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFormField(
                      autovalidate: fullnameValidate,
                      style: TextStyle(letterSpacing: 2.0),
                      controller: _fullnameController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.grey[600],),
                          hintText: 'Full Name'
                      ),
                      onChanged: (val){
                        if(val.length>0){
                          setState(() {
                            fullnameValidate = true;
                          });
                        }
                      },
                      validator: (String val){
                        if (val.length>=30){
                          return 'Maximal Length of name is 30 character';
                        } return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFormField(
                      autovalidate: phoneNumberValidate,
                      style: TextStyle(letterSpacing: 2.0),
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone, color: Colors.grey[600],),
                          hintText: 'Phone Number'
                      ),
                      onChanged: (val){
                        if(val.length>0){
                          setState(() {
                            phoneNumberValidate = true;
                          });
                        }
                      },
                      validator: (String val){
                        if ((val.length<=8)||(val.length>=14)){
                          return 'Invalid Phone Number';
                        } return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextFormField(
                      autovalidate: passwordValidate,
                        style: TextStyle(letterSpacing: 2.0),
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock,color: Colors.grey[600],),
                          hintText: 'Password',
                        ),
                        onChanged: (val){
                          if(val.length>0){
                            setState(() {
                              passwordValidate = true;
                            });
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
                    SizedBox(height: 20.0,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextFormField(
                        autovalidate: confpassValidate,
                        style: TextStyle(letterSpacing: 2.0),
                        controller: _confpassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock,color: Colors.grey[600],),
                          hintText: 'Confirm Password',
                        ),
                        onChanged: (val){
                          if(val.length>7){
                            setState(() {
                              confpassValidate=true;
                            });
                          }
                        },
                        validator: (val){
                          if((val.length>0)&&(val!=_passController.text)){
                            return "Confirm Password doesn't match";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 70.0,),
                    RaisedButton(onPressed: () async {
                      if((_formkey.currentState.validate())&&(_confpassController.text.length!=0)){
                        dynamic result = await AuthenticationService.registerUser(_emailController.text, _passController.text);
                        if(result!=null){
                          if(result=='email-already-in-use'){
                            result=' EMAIL SUDAH TERDAFTAR! ';
                            showErrorBox(result);
                          } else{
                            String randomString = getRandomString(15); //Get random String to named profile picture name in firebase storage
                            await DatabaseServices.insertUserToDatabase(uid:result, email:_emailController.text, fullname:_fullnameController.text, phonenumber:_phoneNumberController.text, pass:_passController.text, profilepicture: randomString);
                            if(_image!=null){
                              await FirebaseStorageDatabase.uploadImage(profilepicture: _image, profilepicturename: randomString);
                            }
                            successDialog(context, "REGISTRASI SUKSES",
                              neutralText: "OK",
                              neutralAction: (){},);
                            _image=null;
                            clearTextInput();
                            setState(() {

                            });
                          }
                        } else {
                          showErrorBox(result);
                        }
                      }
                    },
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 90.0),
                      child: Text('DAFTAR', style: TextStyle(letterSpacing: 3.0,fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),),
                      color: Colors.green[600],
                      shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(5.0)
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Sudah punya akun ?", style: TextStyle(letterSpacing: 2.0,fontSize: 14.0,color: Colors.grey[700])),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Text(' MASUK', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.grey[700])),
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

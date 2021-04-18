import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:news_app_reporter/PageController.dart';
import 'PasswordResetScreen.dart';
import 'SignUpScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  late String nameController;
  late String passwordController;
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(left: 30,top: 20,bottom: 20,right: 10),
                        ),
                        onChanged: (val1) {
                          setState(() {
                            nameController = val1;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: obsecureText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(left: 30,top: 20,bottom: 20,right: 10),
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                obsecureText = !obsecureText;
                              });
                            },
                            child: Container(child: Icon(obsecureText ? Icons.visibility : Icons.visibility_off,color: Theme.of(context).accentColor,size: 20,)),
                          ),
                        ),
                        onChanged: (val2) {
                          setState(() {
                            passwordController = val2;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PasswordReset()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text('Forgot Password',style: TextStyle(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.w500),)),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                    GestureDetector(
                      onTap: () async {
                        //Calling Function to login with email and password
                        await Firebase.initializeApp();
                        String txt = await FirebaseDb().signinwithemail(
                            nameController, passwordController);
                        if (txt == 'Login Successful') {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => PageControllerScreen()),
                                  (Route<dynamic> route) => false);
                        } else {
                          Fluttertoast.showToast(
                              msg: txt,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Center(child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 18),)),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          child: Row(
                        children: <Widget>[
                          Text('Does not have account?'),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              'Sign up',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()),
                              );
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )),
                    )
                  ],
                ),
            ),
          ),
      ),
    );
  }

  Future<bool> _onBackPressed() async{
    SystemNavigator.pop();
    return true;
  }


}


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AddProfileScreen.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class SignUpPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUpPage> {
  late String nameController;
  late String passwordController;
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign up',
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
                    obscureText: _obsecureText,
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
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Container(child: Icon(_obsecureText ? Icons.visibility : Icons.visibility_off,color: Theme.of(context).accentColor,size: 20,)),
                      ),
                    ),
                    onChanged: (val2) {
                      setState(() {
                        passwordController = val2;
                      });
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                GestureDetector(
                  onTap: () async {
                    await Firebase.initializeApp();
                    String txt = await FirebaseDb().registerwithemail(
                        nameController, passwordController);
                    if (txt == 'Account Created') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpProfile()),
                      );
                    } else {
                      await Fluttertoast.showToast(
                          msg: txt,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pop(context);
                    }
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Center(child: Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 18),)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Already have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}

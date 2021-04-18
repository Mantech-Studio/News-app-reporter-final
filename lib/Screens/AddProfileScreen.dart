import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'SelectImageScreen.dart';

class SignUpProfile extends StatefulWidget {
  @override
  _SignUpProfileState createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  late String name;
  late String mobnumber;
  late String company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1),
              Container(
                // TODO: check if data entered is valid and displaying error message
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(left: 20,top: 20,bottom: 20),
                  ),
                  onChanged: (val1) {
                    setState(() {
                      name = val1;
                    });
                  },
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(left: 20,top: 20,bottom: 20),
                  ),
                  onChanged: (val2) {
                    setState(() {
                      mobnumber = val2.toString();
                    });
                  },
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Company',
                    labelStyle: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(left: 20,top: 20,bottom: 20),
                  ),
                  onChanged: (val3) {
                    setState(() {
                      company = val3;
                    });
                  },
                ),
              ),
              SizedBox(height: 20,),
              Text(
                '*Please provide all the details',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 20,),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                    onTap: (){
                      try {
                        if (name != null ||
                            mobnumber != null ||
                            company != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SelectImage(name, mobnumber, company)),
                          );
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: 'Please provide all the details',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Text('Next',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

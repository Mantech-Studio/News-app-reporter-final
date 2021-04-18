import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'LoginScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SelectImage extends StatefulWidget {
  //Data of user to upload
  String name;
  String mobnum;
  String company;
  SelectImage(this.name, this.mobnum, this.company);
  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  late File _image;
  final picker = ImagePicker();
  bool loading = false;

  // Selecting image from gallery
  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        loading = true;
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  //Function to store data in database(collection->profile)
  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('profile');

    await firebase_storage.FirebaseStorage.instance
        .ref('profile/$uid.png')
        .putFile((_image));
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('profile/$uid.png')
        .getDownloadURL();
    return users.doc(uid).set({
      'full_name': widget.name,
      'company': widget.company,
      'mobile_number': widget.mobnum,
      'image_url': downloadURL,
      'followers': 0,
      'total_blogs': 0
    }).then((value) {
      setState(() {});
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.1,),
          loading == false
              ? Center(
              child: Text('Please Select an Image',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),))
              : Center(
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 200, width: MediaQuery.of(context).size.width*0.8, child: Image.file(_image))),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: getImage,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text('Select Image',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: ()async{
                try {
                  if (_image != null) {
                    await addUser();

                    await Fluttertoast.showToast(
                        msg: 'Account Created',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false);
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: 'Please Upload An Image',
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
                    child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

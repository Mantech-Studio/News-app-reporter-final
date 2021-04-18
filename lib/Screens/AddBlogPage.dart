import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  String category = 'Please Select Category';
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Please Select Category';
  final picker = ImagePicker();
  late File _image;
  late String title;
  late String description;
  late String username;
  var docid;
  // Retrieving user id and storing it in uid
  String uid = FirebaseDb().getuid().toString();
  // Widget to select Date
  _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ))!;
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Function to get the image from gallery
  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to get the current users username
  Future<void> getemail() async {
    FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .snapshots()
        .listen((event) {
      setState(() {
        username = event.get("full_name");
      });
    });
  }

  //Function to Add Data to Database (category-> All news)
  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user

    CollectionReference users =
        FirebaseFirestore.instance.collection('All News');
    CollectionReference profile =
        FirebaseFirestore.instance.collection('profile');
    await firebase_storage.FirebaseStorage.instance
        .ref('blog/$uid$title.png')
        .putFile((_image));
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('blog/$uid$title.png')
        .getDownloadURL();
    await addcategory(downloadURL);
    await profile.doc(uid).update({'total_blogs': FieldValue.increment(1)});
    return users
        .doc(docid)
        .set({
          'title': title,
          'description': description,
          'date': selectedDate.toString().split(' ')[0],
          'category': category,
          'uid': uid,
          'image_url': downloadURL,
          'username': username,
          'views': 0,
          'impression': 0,
          'timestamp': Timestamp.now(),
        })
        .then((value) => print('blog added'))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Function to add data based on category
  Future<void> addcategory(downloadUrl) async {
    // Call the user's CollectionReference to add a new user
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('$category');
    return users.add({
      'title': title,
      'description': description,
      'date': selectedDate.toString().split(' ')[0],
      'category': category,
      'uid': uid,
      'image_url': downloadUrl,
      'username': username,
      'views': 0,
      'impression': 0,
      'timestamp': Timestamp.now(),
    }).then((value) {
      setState(() {
        docid = value.id;
      });
    }).catchError((error) => print("Failed to add user: $error"));
  }

  List<double> fontSizes = [12, 16, 20, 24, 32, 48];
  List<String> categories = [
    'चुरू',
    'राजस्थान',
    'राष्ट्रीय',
    'अंतरराष्ट्रीय',
    'खेल',
    'मनोरंजन ',
    'व्यापार',
    'राशिफल',
  ];
  late String CurrentCategory = '';
  late double fontSize = 0;

  @override
  void initState() {
    // TODO: implement initState
    getemail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blog')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await addUser().then((value) {
            Fluttertoast.showToast(
                msg: 'Please wait ... uploading blog',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(context);
          });
        },
        backgroundColor: Theme.of(context).accentColor,
        label: Text(
          'Upload',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          Icons.add_box_rounded,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            // TODO: check if data entered is valid and displaying error message
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  //width: MediaQuery.of(context).size.width*0.6,
                  child: DropdownButton(
                    hint: CurrentCategory == ''
                        ? Text(
                            'Select Category',
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            CurrentCategory,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                    isExpanded: false,
                    iconSize: 30.0,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    items: categories.map(
                      (val2) {
                        return DropdownMenuItem<String>(
                          value: val2,
                          child: Text(val2),
                        );
                      },
                    ).toList(),
                    onChanged: (String? val2) {
                      setState(() {
                        CurrentCategory = val2.toString();
                        category = CurrentCategory;
                      });
                    },
                  ),
                ),
                Container(
                  child: DropdownButton(
                    hint: fontSize == 0
                        ? Text(
                            'Font Size',
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            '$fontSize',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                    isExpanded: false,
                    iconSize: 30.0,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    items: fontSizes.map(
                      (val) {
                        return DropdownMenuItem<double>(
                          value: val,
                          child: Text(val.toString()),
                        );
                      },
                    ).toList(),
                    onChanged: (double? val) {
                      setState(
                        () {
                          fontSize = val == null ? 12 : val.toDouble();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Title',
                  labelStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      EdgeInsets.only(left: 20, top: 20, bottom: 20),
                ),
                onChanged: (val1) {
                  setState(() {
                    title = val1;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  labelText: 'Description',
                ),
                onChanged: (val2) {
                  setState(() {
                    description = val2;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    'Date :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Change Date',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await getImage().then((value) {
                  Fluttertoast.showToast(
                      msg: 'Image Added',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add_to_photos,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

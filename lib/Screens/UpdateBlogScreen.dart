import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class UpdateBlogPage extends StatefulWidget {
  DocumentSnapshot ds;
  UpdateBlogPage(this.ds);
  @override
  _UpdateBlogPageState createState() => _UpdateBlogPageState();
}

class _UpdateBlogPageState extends State<UpdateBlogPage> {
  DateTime selectedDate = DateTime.now();
  late String title;
  late String description;
  final picker = ImagePicker();
  late File _image;
  String uid = FirebaseDb().getuid().toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Blogs'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()async {
          Fluttertoast.showToast(
              msg: 'Please wait ... updating blog',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
              await FirebaseDb().UpdateBlog(
              widget.ds.id,
              selectedDate.toString().split(' ')[0],
              description,
              title,
              widget.ds['category'],
              _image,
              uid);
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).accentColor,
        label: Text('Upload',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        icon: Icon(Icons.add_box_rounded,color: Colors.white,),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20,),
              // TODO: check if data entered is valid and displaying error message
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(left: 20,top: 20,bottom: 20),
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
                    labelStyle: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(left: 20,top: 20,bottom: 20),
                    labelText: 'Description',
                  ),
                  onChanged: (val2) {
                    setState(() {
                      description = val2;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () async{
                  await getImage().then((value){
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
                    width: MediaQuery.of(context).size.width*0.5,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add Image',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(width: 5,),
                          Icon(Icons.add_to_photos,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text('Date :',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
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
                          onTap: (){
                            _selectDate(context);
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Change Date',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
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
            ],
          ),
        ),
      ),
    );
  }
}

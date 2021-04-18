import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('profile');
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done)
                  {
                    Map<String, dynamic> data = snapshot.data!.data()!;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height*0.5,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70.5,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: CachedNetworkImageProvider(data['image_url'],),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('${data['full_name']}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
                          SizedBox(height: 20,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Mobile: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                                    TextSpan(text: '${data['mobile_number']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.black)),
                                  ]
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Company: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                                    TextSpan(text: '${data['company']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.black)),
                                  ]
                                ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Followers: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                                    TextSpan(text: '${data['followers']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.black)),
                                  ]
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Total Blog: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black)),
                                    TextSpan(text: '${data['total_blogs']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.black)),
                                  ]
                              ),
                            ),
                          ),
                    ],
                  ),
                );
                  }
                return Container();
              },
      ),
      );
  }



}


/*
Scaffold(
      // Retrieving data of user and displaying it in profile section
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data()!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 180.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(data['image_url']),
                        ),
                      ),
                    ),
                    Text('Full Name: ${data['full_name']}'),
                    Text('Mobile Number: ${data['mobile_number']}'),
                    Text('Company: ${data['company']}'),
                    Text('Followers: ${data['followers']}'),
                    Text('Total_blogs: ${data['total_blogs']}')
                  ],
                ),
              ),
            );
            //Text("Full Name: ${data['full_name']} ${data['company']}");
          }

          return Text("loading");
        },
      ),
    );
 */

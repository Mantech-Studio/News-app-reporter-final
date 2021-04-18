import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayBlog extends StatefulWidget {
  DocumentSnapshot ds;
  DisplayBlog(this.ds);
  @override
  _DisplayBlogState createState() => _DisplayBlogState();
}

class _DisplayBlogState extends State<DisplayBlog> {
  int fontSize = 14;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: (){
                    if(fontSize>44)
                      {
                        setState(() {
                          fontSize = 14;
                        });
                      }
                    else
                      {
                        setState(() {
                          fontSize = fontSize + 4;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Icon(Icons.font_download_sharp,size: 28,),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.ds['category']),
                  Text(widget.ds['date']),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(widget.ds['image_url']),
                  ),
                ),
              ),
              Text(widget.ds['title'],maxLines: null,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              Text(widget.ds['description'],style: TextStyle(fontSize: fontSize.toDouble()),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: 'Views: ',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black)),
                      TextSpan(text: widget.ds['views'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
                    ]
                  )),
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Impressions: ',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black)),
                        TextSpan(text: widget.ds['impression'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
                      ]
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

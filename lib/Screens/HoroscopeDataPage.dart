import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class HoroscopeData extends StatefulWidget {
  String sign;
  HoroscopeData(this.sign);
  @override
  _HoroscopeDataState createState() => _HoroscopeDataState();
}

class _HoroscopeDataState extends State<HoroscopeData> {
  String uid = FirebaseDb().getuid().toString();
  late String data;
  DateTime currentDate = DateTime.now();
  late String updateddata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sign),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Column(children: [
                        Container(
                            width: 100,
                            height: 100,
                            child: Image.asset('assets/${widget.sign}.jpg')),
                        Text(widget.sign)
                      ]),
                      content: TextField(
                        minLines: 3,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            data = value;
                          });
                        },
                        decoration: InputDecoration(hintText: "Enter the data"),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text('upload'),
                          onPressed: () async {
                            await FirebaseDb().addzodiacdata(
                                data,
                                currentDate.toString().split(' ')[0],
                                widget.sign,
                                uid);
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.sign)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No Data available'));
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  if (ds['uid'] == uid) {
                    return GestureDetector(
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(ds['data']),
                            Text(ds['date']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Column(children: [
                                                Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: Image.asset(
                                                        'assets/${widget.sign}.jpg')),
                                                Text(widget.sign)
                                              ]),
                                              content: TextField(
                                                minLines: 3,
                                                maxLines: 5,
                                                onChanged: (value) {
                                                  setState(() {
                                                    updateddata = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter the data to be updated"),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  color: Colors.green,
                                                  textColor: Colors.white,
                                                  child: Text('upload'),
                                                  onPressed: () async {
                                                    await FirebaseDb()
                                                        .updatezodiacdata(
                                                            updateddata,
                                                            ds.id,
                                                            widget.sign);
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                  onPressed: () {
                                    FirebaseDb()
                                        .deletezodiacdata(ds.id, widget.sign);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.visibility),
                                    ),
                                    Text(ds['views'].toString())
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                });
          }
        },
      ),
    );
  }
}

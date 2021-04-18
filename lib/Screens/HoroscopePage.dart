import 'package:flutter/material.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:news_app_reporter/Screens/HoroscopeDataPage.dart';

class HoroscopePage extends StatefulWidget {
  @override
  _HoroscopePageState createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  List<String> months = [
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius',
    'capricorn',
    'aquarius',
    'pisces',
  ];
  late String data;
  DateTime currentDate = DateTime.now();
  String uid = FirebaseDb().getuid().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Update'),
        icon: Icon(Icons.update,color: Colors.white,),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          for (int i = 0; i < 12; i++) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/' + months[i].toLowerCase().toString() + '.jpg'),),
                      Text(months[i])
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
                        child: Text('Save'),
                        onPressed: () async {
                          await FirebaseDb().addzodiacdata(
                              data,
                              currentDate.toString().split(' ')[0],
                              months[i],
                              uid);
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                });
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(months.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HoroscopeData(months[index])));
              },
              child: Container(
                  child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/${months[index]}.jpg',),
                  ),
                  SizedBox(height: 10,),
                  Text(months[index].toUpperCase(),style: TextStyle(fontWeight: FontWeight.w500),)
                ],
              )),
            );
          }),
        ),
      ),
    );
  }
}

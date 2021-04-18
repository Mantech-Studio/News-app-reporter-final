import 'package:flutter/material.dart';
import 'Screens/BlogPage.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'Screens/HoroscopePage.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/ProfilePage.dart';

class PageControllerScreen extends StatefulWidget {
  @override
  _PageControllerScreenState createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('जयपुर समय'),
            centerTitle: true,
            leading: Container(),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  //Sign out Function is called
                  await FirebaseDb().signout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width,40),
              child: TabBar(
                  isScrollable: true,
                  indicatorWeight: 3,
                  physics: ScrollPhysics(),
                  tabs: <Widget>[
                    Tab(
                      text: 'Blog Page',
                    ),
                    Tab(
                      text: 'Horoscope Page',
                    ),
                    Tab(
                      text: 'Profile Page',
                    ),
                  ]),
            ),
          ),
          body: TabBarView(
            physics: ScrollPhysics(),
            children: [
              BlogPage(),
              HoroscopePage(),
              ProfilePage(),
              ],
          ),
        ),
    );
  }

}

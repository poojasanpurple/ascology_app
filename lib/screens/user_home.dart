import 'package:ascology_app/screens/user_call.dart';
import 'package:ascology_app/screens/user_chat.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_profile.dart';
import 'package:ascology_app/screens/user_services.dart';
import 'package:ascology_app/screens/user_support.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget
{

  @override
  _UserHomePageState createState() => _UserHomePageState();
  }

  class _UserHomePageState extends State<UserHomePage> {

    int _selectedIndex = 0;

    final formKey = GlobalKey<FormState>();

  static List<Widget> _widgetOptions = <Widget>[
    UserDashboard(),
    ServicesPage(),
    UserChat(),
    UserProfile(),
   // UserCall()
  ];


    int _selectedScreenIndex = 0;
    final List _screens = [
      {"screen":  UserDashboard(), "title": "Dashboard"},
      {"screen":  ServicesPage(), "title": "Services"},
      {"screen":  UserChat(), "title": "Chat"},
      {"screen":  UserProfile(), "title": "Profile"}
    ];


    /*void _onItemTapped(int index) {

      setState(() {
        _selectedIndex = index;
      });
    }*/

    void _selectScreen(int index) {
      setState(() {
        _selectedScreenIndex = index;
      });
    }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(
            child: Scaffold(
              body:
              _screens[_selectedScreenIndex]["screen"],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedScreenIndex,
                unselectedItemColor: const Color(0xffe22525),
                selectedItemColor: Colors.blueGrey,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                onTap: _selectScreen,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
                  BottomNavigationBarItem(icon: Icon(Icons.miscellaneous_services), label: "Services"),
                  BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
                  BottomNavigationBarItem(icon: Icon(Icons.perm_contact_cal_rounded), label: "Profile")
                ],
              ),/*Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),*/
/*
              bottomNavigationBar: BottomNavigationBar(
                  index: 0,
                  height: 50.0,
                  items: <Widget>[


                   Icon(Icons.home,color: const Color(0xffe22525),size: 30),
                   Icon(Icons.miscellaneous_services,color: const Color(0xffe22525),size: 30),
                   Icon(Icons.chat,color: const Color(0xffe22525),size: 30),
                   Icon(Icons.perm_contact_cal_rounded,color: const Color(0xffe22525),size: 30),

                  ],
                   color: Colors.white,
                  buttonBackgroundColor: Colors.grey,
                  backgroundColor: Colors.white,
                  animationCurve: Curves.decelerate,
                  animationDuration: Duration(milliseconds: 600),
                  onTap: _onItemTapped
              ),
*/
            )
        )
    );

  }

  }
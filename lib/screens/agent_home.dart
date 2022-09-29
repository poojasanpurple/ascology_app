import 'package:ascology_app/screens/agent_call_history.dart';
import 'package:ascology_app/screens/agent_chat.dart';
import 'package:ascology_app/screens/agent_dashboard.dart';
import 'package:ascology_app/screens/agent_profile.dart';
import 'package:ascology_app/screens/user_call.dart';
import 'package:ascology_app/screens/user_chat.dart';
import 'package:ascology_app/screens/user_support.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AgentHomePage extends StatefulWidget
{

  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {

  final formKey = GlobalKey<FormState>();

  int _selectedIndex = 0;


  static List<Widget> _widgetOptions = <Widget>[
    AgentDashboard(),
    AgentCallHistory(),
    AgentChat(),
    AgentProfile(),

  ];

  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen":  AgentDashboard(), "title": "Dashboard"},
    {"screen":  AgentCallHistory(), "title": "Call History"},
    {"screen":  AgentChat(), "title": "Chat"},
    {"screen":  AgentProfile(), "title": "Profile"}
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }
  /*void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });
  }*/

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(
            child: Scaffold(
              body: /*Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),*/

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
                  BottomNavigationBarItem(icon: Icon(Icons.call), label: "Call History"),
                  BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
                  BottomNavigationBarItem(icon: Icon(Icons.perm_contact_cal_rounded), label: "Profile")
                ],
              ),

             /* bottomNavigationBar: CurvedNavigationBar(
                  index: 0,
                  height: 50.0,
                  items: <Widget>[

                    Icon(Icons.home,color: const Color(0xffe22525),size: 30, semanticLabel: 'Dashboard'),
                    Icon(Icons.call,color: const Color(0xffe22525),size: 30,semanticLabel: 'Call history'),
                    Icon(Icons.chat,color: const Color(0xffe22525),size: 30,semanticLabel: 'Chat'),
                    Icon(Icons.perm_contact_cal_rounded,color: const Color(0xffe22525),size: 30,semanticLabel: 'Profile'),


                  ],


                  color: Colors.white,
                  buttonBackgroundColor: Colors.grey,
                  backgroundColor: Colors.white,
                  animationCurve: Curves.decelerate,
                  animationDuration: Duration(milliseconds: 600),
                  onTap: _onItemTapped
              ),*/
            )
        )
    );

  }

}
import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/graph.dart';
import 'package:hand_gesture/screens/home.dart';
import 'package:hand_gesture/screens/home2.dart';
import 'package:hand_gesture/screens/home_connected.dart';
import 'package:hand_gesture/screens/learn.dart';
import 'package:hand_gesture/screens/profile.dart';
import 'package:hand_gesture/screens/serial.dart';
import 'package:hand_gesture/screens/tutorial.dart';
import 'package:hand_gesture/screens/values.dart';
import 'package:hand_gesture/utils/constants.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    switch (_selectedIndex) {
      case 0:
        bodyWidget = const Tutorial();
        break;
      case 1:
        bodyWidget = const Graph();
        break;
      case 2:
        bodyWidget = const Home2();
        break;
      case 3:
        bodyWidget = const Learn();
        break;
      case 4:
        bodyWidget = const BluetoothSerialMonitor();
        break;
      case 5:
        bodyWidget = const Values();
        break;
      default:
        bodyWidget = const Home2();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "H",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: PRIMARY_COLOR,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.play_circle,
              size: _selectedIndex == 0 ? 40 : 30,
              color: _selectedIndex == 0 ? PRIMARY_COLOR : Colors.grey[600],
            ),
            label: "Tutorials",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.trending_up,
              size: _selectedIndex == 1 ? 40 : 30,
              color: _selectedIndex == 1 ? PRIMARY_COLOR : Colors.grey[600],
            ),
            label: "Graphs",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: _selectedIndex == 2 ? 40 : 30,
              color: _selectedIndex == 2 ? PRIMARY_COLOR : Colors.grey[600],
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_library,
              size: _selectedIndex == 3 ? 40 : 30,
              color: _selectedIndex == 3 ? PRIMARY_COLOR : Colors.grey[600],
            ),
            label: "Learn",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: _selectedIndex == 4 ? 40 : 30,
              color: _selectedIndex == 4 ? PRIMARY_COLOR : Colors.grey[600],
            ),
            label: "Profile",
          ),BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
              size: _selectedIndex == 4 ? 40 : 30,
              color: _selectedIndex == 4 ? PRIMARY_COLOR : Colors.grey[600],
            ),
            label: "Values",
          ),
        ],
      ),
    );
  }
}

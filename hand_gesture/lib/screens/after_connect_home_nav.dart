import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/graph.dart';
import 'package:hand_gesture/screens/home.dart';
import 'package:hand_gesture/screens/home_connected.dart';
import 'package:hand_gesture/screens/learn.dart';
import 'package:hand_gesture/screens/profile.dart';
import 'package:hand_gesture/screens/tutorial.dart';
import 'package:hand_gesture/utils/constants.dart';
import 'dart:async';

class AfterConnectHomeNav extends StatefulWidget {
  final Stream<String> signedLetterStream;
  const AfterConnectHomeNav({super.key, required this.signedLetterStream});

  @override
  State<AfterConnectHomeNav> createState() => _LandingState();
}

class _LandingState extends State<AfterConnectHomeNav> {
  int _selectedIndex = 2;
  late StreamSubscription<String> _subscription;
  String currentSignedLetter = "";
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    // Listen to the signedLetterStream
    _subscription = widget.signedLetterStream.listen((signedLetter) {
      setState(() {
        currentSignedLetter = signedLetter;
        if (signedLetter.isNotEmpty) {
          history.add(signedLetter);
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

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
        bodyWidget = HomeConnected();
        break;
      case 3:
        bodyWidget = const Learn();
        break;
      case 4:
        bodyWidget = const Profile();
        break;
      default:
        bodyWidget = const Home();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: const Text("Hand Gesture Detector"),
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
          ),
        ],
      ),
    );
  }
}

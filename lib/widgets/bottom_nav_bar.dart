import 'package:BBTS/views/help_page.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/permission.dart';
import '../utils/constants.dart';
import '../views/routers/router_page.dart';
import '../views/switches/switch_page.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  late final LocalAuthentication auth;
  bool _supportState = true; // Adjusted to true
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication(); // Initialize local authentication

    // Initialize page controller
    _pageController = PageController(initialPage: _selectedIndex);

    // Uncomment if needed for local auth
    // auth.isDeviceSupported().then((value) {
    //   setState(() async {
    //     _supportState = value;
    //     if (value) {
    //       List<BiometricType> biometrics = await auth.getAvailableBiometrics();
    //       print(biometrics);
    //     }
    //   });
    // });

    // Request necessary permissions
    requestPermission(Permission.camera);
    requestPermission(Permission.location);
    // requestPermission(Permission.accessMediaLocation);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          // HomePage(),
          // GroupingPage(),
          RouterPage(),
          SwitchPage(),
          const HelpPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/group_icon.png",
              height: 45,
            ),
            label: 'Groups',
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/wifi-router.png",
              height: 40,
            ),
            label: 'Routers', // Removed unnecessary parentheses
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/switch.png",
              height: 45,
            ),
            label: 'Switches',
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/question-bubble.png",
              height: 35,
            ),
            label: 'Help',
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/question-bubble.png",
              height: 35,
            ),
            label: 'Help',
            backgroundColor: backGroundColour,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}

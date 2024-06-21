import 'package:flutter/material.dart';

import '../utils/constants.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key, Key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "Help",
            style: TextStyle(
              color: appBarColour,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              HelpDropdown(
                title: "CAUTION",
                content: "Make sure to keep the GPS location and Wi-Fi activated at all times. Obtain the QR code from the lock owner and verify that it is not expired. If the QR code has expired, please reach out to the owner for a new one.",
              ),
              HelpDropdown(
                title: "How to CONNECT",
                content: "Kindly select the router icon and add a router using the QR code shared by the owner. Next, tap the locks icon and add a lock using the QR code provided by the owner. Once added, access the locks icon, choose the specific lock, and then tap the on/off button to either lock or unlock it.",
              ),
              HelpDropdown(
                title: "Support from Manufacturer",
                content: "Contact : Mr.Rajender Dandu: Ph: +91 7996907698, Mail : rajendar.dandu@belbirdtechnologies.com ",
              ),
              // Add more HelpDropdown widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}


class HelpDropdown extends StatefulWidget {
  final String title;
  final String content;

  const HelpDropdown({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  _HelpDropdownState createState() => _HelpDropdownState();
}

class _HelpDropdownState extends State<HelpDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


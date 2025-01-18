import 'package:BBTS/views/routers/router_page.dart';
import 'package:BBTS/views/switches/switch_page.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'groups/grouping_page.dart';
import 'home_page.dart';
import 'matrix_group/grouping_page_matrix.dart';
import 'matrix_router/router_page_matrix.dart';
import 'matrix_switch/switch_page_matrix.dart';

class SelectType extends StatefulWidget {
  final String type;
  const SelectType({required this.type, super.key});

  @override
  State<SelectType> createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  final List<GridItem> switchPages = [
    GridItem(
        name: "SWITCHES",
        color: Colors.purple,
        navigateTo: SwitchPage(),
        icon: 'assets/images/switch.png'),
    GridItem(
        name: "SWITCHES MATRIX",
        color: Colors.deepOrangeAccent,
        navigateTo: const SwitchMatrixPage(),
        icon: 'assets/images/group.png'),
  ];
  final List<GridItem> routerPages = [
    GridItem(
        name: "ROUTERS",
        color: Colors.redAccent,
        navigateTo: RouterPage(),
        icon: 'assets/images/wifi-router.png'),
    GridItem(
        name: "ROUTERS MATRIX",
        color: Colors.indigo,
        navigateTo: RouterMatrixPage(),
        icon: 'assets/images/group.png'),
  ];
  final List<GridItem> groupPages = [
    GridItem(
        name: "GROUPS",
        color: Colors.green,
        navigateTo: GroupingPage(),
        icon: 'assets/images/img.png'),
    GridItem(
        name: "GROUPS MATRIX",
        color: Colors.yellow,
        navigateTo: GroupsMatrixPage(),
        icon: 'assets/images/group.png')
  ];

  List<GridItem> get selectedPages {
    switch (widget.type) {
      case "ROUTERS":
        return routerPages;
      case "SWITCHES":
        return switchPages;
      default:
        return groupPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    return DefaultTabController(
      length: selectedPages.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 30,
            ),
          ),
          centerTitle: true,
          elevation: 3,
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          title: Text(
            widget.type,
            style: TextStyle(
                color: appBarColour,
                fontSize: width * 0.07,
                fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: selectedPages
                .map((item) => Tab(
                      text: item.name,
                    ))
                .toList(),
            labelStyle: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            unselectedLabelStyle: TextStyle(
              fontSize: width * 0.045,
            ),
          ),
        ),
        body: TabBarView(
          children: selectedPages.map((item) {
            return item.navigateTo;
          }).toList(),
        ),
      ),
    );
  }
}

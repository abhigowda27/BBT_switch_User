import 'package:BBTS/views/home_page.dart';
import 'package:flutter/material.dart';

import '../controller/storage_controller.dart';
import '../model/group.dart';
import '../model/routers.dart';
import '../utils/constants.dart';

class GroupCard extends StatefulWidget {
  final GroupDetails groupDetails;

  const GroupCard({required this.groupDetails, Key? key}) : super(key: key);

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  final StorageController _storageController = StorageController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(5, 5),
              ),
            ],
            color: whiteColour,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Group Name: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.groupDetails.groupName,
                        style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Selected Router: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.groupDetails.selectedRouter,
                        style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Switches:",
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.groupDetails.selectedSwitches
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        RouterDetails switchDetail = entry.value;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Switch ${index + 1} :',
                              style: TextStyle(
                                fontSize: 20,
                                color: blackColour,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              switchDetail.switchName,
                              style: TextStyle(
                                fontSize: 20,
                                color: blackColour,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: appBarColour,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: "Delete Group",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (cont) {
                              return AlertDialog(
                                title: const Text('Delete Group'),
                                content:
                                    const Text('This will delete the Group'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      await _storageController
                                          .deleteOneGroup(widget.groupDetails);
                                      Navigator.pushAndRemoveUntil<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              const HomePage(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete_outline_outlined,
                            color: backGroundColour),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

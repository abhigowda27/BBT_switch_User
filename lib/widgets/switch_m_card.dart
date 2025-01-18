import 'package:BBTS/views/home_page.dart';
import 'package:flutter/material.dart';

import '../controller/matrix_storage.dart';
import '../model/switches_m.dart';
import '../utils/constants.dart';

class SwitchesCard extends StatefulWidget {
  final SwitchMDetails switchesDetails;
  const SwitchesCard({
    required this.switchesDetails,
    super.key,
  });

  @override
  State<SwitchesCard> createState() => _SwitchesCardState();
}

class _SwitchesCardState extends State<SwitchesCard> {
  final MatrixStorageController _storageController = MatrixStorageController();

  @override
  Widget build(BuildContext context) {
    print("widget.switchesDetails");
    print(widget.switchesDetails.switchTypes);
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
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
                      "Switch ID : ",
                      style: TextStyle(
                          fontSize: width * 0.04,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.switchesDetails.switchId,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: width * 0.04,
                              color: blackColour,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Switch Name : ",
                      style: TextStyle(
                          fontSize: width * 0.04,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.switchesDetails.switchSSID,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: width * 0.04,
                              color: blackColour,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                if (widget.switchesDetails.switchTypes.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Switches:",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: blackColour,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.switchesDetails.switchTypes
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String switchType = entry.value;
                          return Row(
                            children: [
                              Text(
                                '${index + 1}: ',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: blackColour,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  switchType,
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    color: blackColour,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  )
                ],
                if (widget.switchesDetails.selectedFan!.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        "Selected fan: ",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: blackColour,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.switchesDetails.selectedFan!,
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: blackColour,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                Container(
                  decoration: BoxDecoration(
                    color: appBarColour,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        iconSize: 30,
                        tooltip: "Delete Switch",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (cont) {
                              return AlertDialog(
                                title: const Text('BBT Switch'),
                                content:
                                    const Text('This will delete the Switch'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      _storageController.deleteOneSwitch(
                                          widget.switchesDetails);
                                      Navigator.pushAndRemoveUntil<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              const HomePage(),
                                        ),
                                        (route) =>
                                            false, //if you want to disable back feature set to false
                                      );
                                    },
                                    child: Text('OK',
                                        style:
                                            TextStyle(color: backGroundColour)),
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

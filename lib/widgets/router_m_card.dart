import 'package:BBTS/views/home_page.dart';
import 'package:flutter/material.dart';

import '../controller/matrix_storage.dart';
import '../model/routers_m.dart';
import '../utils/constants.dart';

class RouterCard extends StatefulWidget {
  final RouterMDetails routerDetails;
  const RouterCard({
    required this.routerDetails,
    super.key,
  });

  @override
  State<RouterCard> createState() => _RouterCardState();
}

class _RouterCardState extends State<RouterCard> {
  bool hide = true;
  //bool isLightOn = false;
  final MatrixStorageController _storageController = MatrixStorageController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          // height: 150,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5), // changes position of shadow
            ),
          ], color: whiteColour, borderRadius: BorderRadius.circular(12)),
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
                          widget.routerDetails.switchID,
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
                          widget.routerDetails.switchName,
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
                      "Router Name : ",
                      style: TextStyle(
                          fontSize: width * 0.04,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.routerDetails.routerName,
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
                if (widget.routerDetails.switchTypes.isNotEmpty) ...[
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
                        children: widget.routerDetails.switchTypes
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
                if (widget.routerDetails.selectedFan!.isNotEmpty) ...[
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
                          widget.routerDetails.selectedFan!,
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
                      borderRadius: BorderRadius.circular(11)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      IconButton(
                          tooltip: "Delete Router",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (cont) {
                                  return AlertDialog(
                                    title: const Text('BBT Switch'),
                                    content: const Text(
                                        'This will delete the Switch'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          _storageController.deleteOneRouter(
                                              widget.routerDetails);
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
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete_outline_outlined,
                              color: backGroundColour)),
                      const SizedBox(
                        width: 10,
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

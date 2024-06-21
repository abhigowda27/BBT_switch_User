import 'package:flutter/material.dart';
import '../controller/storage_controller.dart';
import '../model/routers.dart';
import '../utils/constants.dart';
import 'bottom_nav_bar.dart';

class RouterCard extends StatefulWidget {
  final RouterDetails routerDetails;
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
  final StorageController _storageController = StorageController();

  @override
  Widget build(BuildContext context) {
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
                          fontSize: 20,
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
                              fontSize: 20,
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
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.routerDetails.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: blackColour,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     Text(
                //       "Switch PassKey : ",
                //       style: TextStyle(
                //           fontSize: 20,
                //           color: blackColour,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       hide
                //           ? List.generate(
                //               widget.routerDetails.switchPasskey.length,
                //               (index) => "*").join()
                //           : widget.routerDetails.switchPasskey,
                //       style: TextStyle(
                //           fontSize: 20,
                //           color: blackColour,
                //           fontWeight: FontWeight.w400),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Text(
                //       "Router Password: ",
                //       style: TextStyle(
                //           fontSize: 20,
                //           color: blackColour,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       hide
                //           ? List.generate(widget.routerDetails.password.length,
                //               (index) => "*").join()
                //           : widget.routerDetails.password,
                //       style: TextStyle(
                //           fontSize: 20,
                //           color: blackColour,
                //           fontWeight: FontWeight.w400),
                //     )
                //   ],
                // ),
                Container(
                  decoration: BoxDecoration(
                      color: backGroundColour,
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
                                          _storageController.deleteOneRouter(
                                              widget.routerDetails);
                                          Navigator.pushAndRemoveUntil<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  const MyNavigationBar(),
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
                          icon: const Icon(Icons.delete)),
                      const SizedBox(
                        width: 10,
                      ),
                  // IconButton(
                  //   tooltip: "Toggle Light",
                  //   onPressed: () {
                  //     setState(() {
                  //       isLightOn = !isLightOn;
                  //       // Logic to control the light
                  //       if (isLightOn) {
                  //         // Send command to turn on the light
                  //         print('Light turned ON');
                  //       } else {
                  //         // Send command to turn off the light
                  //         print('Light turned OFF');
                  //       }
                  //     });
                  //   },
                  //   icon: Icon(
                  //     Icons.power_settings_new_outlined,
                  //     color: isLightOn ? Colors.yellow : Colors.grey,
                  //   ),
                  // ),

                      // IconButton(
                      //     tooltip: "Show Details",
                      //     onPressed: () {
                      //       setState(() {
                      //         hide = !hide;
                      //       });
                      //     },
                      //     icon: hide
                      //         ? const Icon(Icons.remove_red_eye)
                      //         : const Icon(CupertinoIcons.eye_slash_fill)),
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

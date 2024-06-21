import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../controller/storage_controller.dart';
import '../model/switches.dart';
import '../utils/constants.dart';
import '../widgets/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../widgets/bottom_nav_bar.dart';
import '../controller/api.dart';
import '../controller/permission.dart';

class SwitchesCard extends StatefulWidget {
  final SwitchDetails switchesDetails;
  const SwitchesCard({
    required this.switchesDetails,
    super.key,
  });

  @override
  State<SwitchesCard> createState() => _SwitchesCardState();
}

class _SwitchesCardState extends State<SwitchesCard> {
  final StorageController _storageController = StorageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String switchStatus = "Off";
  bool switchOff = true;
  late Timer _timer;

  void _navigateToNextPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyNavigationBar(),
      ),
          (route) => false, //if you want to disable back feature set to false
    );
  }

  void _buttonPressed() {
    _timer.cancel();
    _timer = Timer(const Duration(seconds: 20), () {
      _navigateToNextPage();
    });
  }

  void updateSwitch() async {
    String res = await ApiConnect.hitApiGet("${widget.switchesDetails.iPAddress}/Switchstatus");
    setState(() {
      if (res == "OK CLOSE") {
        switchOff = true;
        switchStatus = "Off";
      } else {
        switchOff = false;
        switchStatus = "On";
      }
    });
    _buttonPressed();
  }

  ConnectivityResult _connectionStatusS = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();

    connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    for (var result in results) {
      _initNetworkInfo(); // Process each result as needed
    }
  }

  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<void> _initNetworkInfo() async {
    String? wifiName, wifiBSSID, wifiIPv4, wifiIPv6, wifiGatewayIP, wifiBroadcast, wifiSubmask;

    try {
      await requestPermission(Permission.nearbyWifiDevices);
      // await requestPermission(Permission.locationWhenInUse);
    } catch (e) {
      print(e.toString());
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      _connectionStatus = wifiName!.toString();
    });
  }

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
                      "Switch ID : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.switchesDetails.switchld,
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
                      "Switch Name : ",
                      style: TextStyle(
                          fontSize: 20,
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
                              fontSize: 20,
                              color: blackColour,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: backGroundColour,
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
                                content: const Text('This will delete the Switch'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      _storageController.deleteOneSwitch(widget.switchesDetails);
                                      Navigator.pushAndRemoveUntil<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) => const MyNavigationBar(),
                                        ),
                                            (route) => false, //if you want to disable back feature set to false
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      const SizedBox(width: 200),
                      Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: (value) async {
                            String localConnectStatus = _connectionStatus;
                            localConnectStatus = localConnectStatus.substring(1, localConnectStatus.length - 1);
                            if (localConnectStatus != widget.switchesDetails.switchSSID) {
                              showToast(context, "You should be connected to ${widget.switchesDetails.switchSSID} to Enable the Switch");
                              setState(() {
                                widget.switchesDetails.isAutoSwitch = !value;
                              });
                              return;
                            }
                            try {
                              if (value) {
                                ApiConnect.hitApiPost("${widget.switchesDetails
                                    .iPAddress}/getSwitchcmd", {
                                  "Lock_id": widget.switchesDetails.switchld,
                                  "lock_passkey": widget.switchesDetails
                                      .switchPassKey,
                                  "lock_cmd": "ON"
                                });
                                setState(() {
                                  switchOff = false;
                                  switchStatus = "On";
                                });
                              } else if (!value) {
                                ApiConnect.hitApiPost("${widget.switchesDetails
                                    .iPAddress}/getSwitchcmd", {
                                  "Lock_id": widget.switchesDetails.switchld,
                                  "lock_passkey": widget.switchesDetails
                                      .switchPassKey,
                                  "lock_cmd": "OFF"
                                });
                                setState(() {
                                  switchStatus = "Off";
                                  switchOff = true;
                                });
                              } else {}
                            }on DioException {
                              final scaffold = ScaffoldMessenger.of(context);
                              scaffold.showSnackBar(const SnackBar(
                                content: Text("Unable to perform. Try Again."),),);
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          value: !switchOff,
                          activeColor: greenButtonColour,
                          activeTrackColor: greenColour,
                          inactiveThumbColor: redButtonColour,
                          inactiveTrackColor: redColour,
                        ),
                      )
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

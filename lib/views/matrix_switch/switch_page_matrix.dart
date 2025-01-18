// import 'dart:async';
// import 'dart:developer' as developer;
// import 'dart:io';
//
// import 'package:BBTS/widgets/switch_m_card.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../controller/matrix_storage.dart';
// import '../controller/permission.dart';
// import '../model/switches_m.dart';
// import '../utils/constants.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/toast.dart';
// import 'matrix_qr.dart';
// import 'matrix_switch_on_off.dart';
//
// class SwitchMatrixPage extends StatefulWidget {
//   const SwitchMatrixPage({super.key});
//
//   @override
//   State<SwitchMatrixPage> createState() => _SwitchMatrixPageState();
// }
//
// class _SwitchMatrixPageState extends State<SwitchMatrixPage> {
//   final MatrixStorageController _storageController = MatrixStorageController();
//   final TextEditingController _searchController = TextEditingController();
//   List<SwitchMDetails> _allSwitches = [];
//   List<SwitchMDetails> _filteredSwitches = [];
//
//   Future<List<SwitchMDetails>> fetchSwitches() async {
//     _allSwitches = await _storageController.readSwitches();
//     _filteredSwitches = _allSwitches;
//     return _filteredSwitches;
//   }
//
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _initNetworkInfo();
//     _searchController.addListener(_filterSwitches);
//     connectivitySubscription = _connectivity.onConnectivityChanged
//         .listen((List<ConnectivityResult> results) {
//       _updateConnectionStatus(results);
//     });
//   }
//
//   @override
//   void dispose() {
//     connectivitySubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
//     for (var result in results) {
//       _initNetworkInfo();
//     }
//   }
//
//   _filterSwitches() {
//     print(">>>>>>>>>>>>>>>>>");
//     setState(() {
//       if (_searchController.text.isEmpty) {
//         _filteredSwitches = _allSwitches;
//       } else {
//         _filteredSwitches = _allSwitches
//             .where((switchDetails) => switchDetails.switchSSID
//                 .toLowerCase()
//                 .contains(_searchController.text.toLowerCase()))
//             .toList();
//       }
//     });
//     print("_searchController.text");
//     print(_searchController.text);
//     print(_filteredSwitches);
//   }
//
//   String _connectionStatus = 'Unknown';
//   final NetworkInfo _networkInfo = NetworkInfo();
//   Future<void> _initNetworkInfo() async {
//     String? wifiName,
//         wifiBSSID,
//         wifiIPv4,
//         wifiIPv6,
//         wifiGatewayIP,
//         wifiBroadcast,
//         wifiSubmask;
//
//     try {
//       await requestPermission(Permission.nearbyWifiDevices);
//       // await requestPermission(Permission.locationWhenInUse);
//     } catch (e) {
//       print(e.toString());
//     }
//
//     try {
//       if (!kIsWeb && Platform.isIOS) {
//         // ignore: deprecated_member_use
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           // ignore: deprecated_member_use
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiName = await _networkInfo.getWifiName();
//         } else {
//           wifiName = await _networkInfo.getWifiName();
//         }
//       } else {
//         wifiName = await _networkInfo.getWifiName();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi Name', error: e);
//       wifiName = 'Failed to get Wifi Name';
//     }
//
//     try {
//       if (!kIsWeb && Platform.isIOS) {
//         // ignore: deprecated_member_use
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           // ignore: deprecated_member_use
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         } else {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         }
//       } else {
//         wifiBSSID = await _networkInfo.getWifiBSSID();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi BSSID', error: e);
//       wifiBSSID = 'Failed to get Wifi BSSID';
//     }
//
//     try {
//       wifiIPv4 = await _networkInfo.getWifiIP();
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi IPv4', error: e);
//       wifiIPv4 = 'Failed to get Wifi IPv4';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiIPv6 = await _networkInfo.getWifiIPv6();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi IPv6', error: e);
//       wifiIPv6 = 'Failed to get Wifi IPv6';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiSubmask = await _networkInfo.getWifiSubmask();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi submask address', error: e);
//       wifiSubmask = 'Failed to get Wifi submask address';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiBroadcast = await _networkInfo.getWifiBroadcast();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi broadcast', error: e);
//       wifiBroadcast = 'Failed to get Wifi broadcast';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi gateway address', error: e);
//       wifiGatewayIP = 'Failed to get Wifi gateway address';
//     }
//
//     setState(() {
//       _connectionStatus = wifiName!.toString();
//       // 'Wifi BSSID: $wifiBSSID\n'
//       // 'Wifi IPv4: $wifiIPv4\n'
//       // 'Wifi IPv6: $wifiIPv6\n'
//       // 'Wifi Broadcast: $wifiBroadcast\n'
//       // 'Wifi Gateway: $wifiGatewayIP\n'
//       // 'Wifi Submask: $wifiSubmask\n';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SizedBox(
//               height: 70,
//               width: 180,
//               child: FloatingActionButton.large(
//                 backgroundColor: appBarColour,
//                 onPressed: () {},
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => const ScanQr(type: "switch"),
//                         ));
//                       },
//                       icon: Icon(Icons.camera_alt_outlined,
//                           color: backGroundColour),
//                     ),
//                     const VerticalDivider(
//                       color: Colors.white,
//                       thickness: 2,
//                       endIndent: 20,
//                       indent: 20,
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => const ScanQr(type: "switch"),
//                         ));
//                       },
//                       icon: Icon(Icons.image_outlined, color: backGroundColour),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: CustomAppBar(
//           heading: "SWITCHES M",
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Update the TextField and _filterSwitches function
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _searchController,
//                 // onChanged: (query) => _filterSwitches(query), // Correct usage
//                 decoration: InputDecoration(
//                   labelText: "Search Switch",
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             FutureBuilder(
//               future: fetchSwitches(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }
//                 if (snapshot.hasError) {
//                   return Text("Error: ${snapshot.error}");
//                 }
//                 if (!snapshot.hasData || _filteredSwitches.isEmpty) {
//                   return const Text("No switches available.");
//                 }
//                 return ListView.builder(
//                   padding: const EdgeInsets.only(top: 10),
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: _filteredSwitches.length,
//                   itemBuilder: (context, index) {
//                     final switchDetails = _filteredSwitches[index];
//                     return GestureDetector(
//                       onTap: () {
//                         if (switchDetails.contactsModel.accessType
//                             .contains("Timed Access")) {
//                           DateTime now = DateTime.now();
//                           DateTime startDate =
//                               switchDetails.contactsModel.startDateTime;
//                           DateTime endDate =
//                               switchDetails.contactsModel.endDateTime;
//                           if (switchDetails.contactsModel.accessType
//                                   .contains("Timed") &&
//                               now.isAfter(endDate)) {
//                             showToast(context,
//                                 "You have surpassed the end date. Contact the admin for fresh approval");
//                             return;
//                           }
//                         }
//                         if (!_connectionStatus
//                             .contains(switchDetails.switchSSID)) {
//                           showToast(context,
//                               "Wifi is not connected to the correct switch");
//                           return;
//                         }
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SwitchOnOff(
//                               switchDetails: switchDetails,
//                             ),
//                           ),
//                         );
//                       },
//                       child: SwitchesCard(switchesDetails: switchDetails),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:BBTS/widgets/switch_m_card.dart';
import 'package:flutter/material.dart';

import '../../controller/matrix_storage.dart';
import '../../model/switches_m.dart';
import '../../utils/constants.dart';
import '../../widgets/toast.dart';
import '../qr_matrix/matrix_gallery_qr.dart';
import '../qr_matrix/matrix_qr.dart';
import 'connect_to_mswitch.dart';

class SwitchMatrixPage extends StatefulWidget {
  const SwitchMatrixPage({super.key});

  @override
  State<SwitchMatrixPage> createState() => _SwitchMatrixPageState();
}

class _SwitchMatrixPageState extends State<SwitchMatrixPage> {
  final MatrixStorageController _storageController = MatrixStorageController();
  final TextEditingController _searchController = TextEditingController();
  List<SwitchMDetails> _allSwitches = [];
  List<SwitchMDetails> _filteredSwitches = [];

  void _filterSwitches() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredSwitches = _allSwitches;
      } else {
        _filteredSwitches = _allSwitches.where((switchDetails) {
          return switchDetails.switchSSID
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _loadSwitches() async {
    _allSwitches = await _storageController.readSwitches();
    setState(() {
      _filteredSwitches = _allSwitches;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSwitches);
    _loadSwitches(); // Load switches on initialization
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 70,
              width: 180,
              child: FloatingActionButton.large(
                backgroundColor: appBarColour,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ScanQr(type: "switch"),
                        ));
                      },
                      icon: Icon(Icons.camera_alt_outlined,
                          color: backGroundColour),
                    ),
                    const VerticalDivider(
                        color: Colors.white,
                        thickness: 2,
                        endIndent: 20,
                        indent: 20),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const GalleryQRMPage(type: "switch"),
                        ));
                      },
                      icon: Icon(Icons.image_outlined, color: backGroundColour),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(60),
      //   child: CustomAppBar(
      //     heading: "SWITCHES M",
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Search Switch",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            if (_filteredSwitches.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No switches available."),
                ),
              )
            else
              ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredSwitches.length,
                itemBuilder: (context, index) {
                  final switchDetails = _filteredSwitches[index];
                  return GestureDetector(
                    onTap: () {
                      if (switchDetails.contactsModel.accessType
                          .contains("Timed Access")) {
                        DateTime now = DateTime.now();
                        DateTime startDate =
                            switchDetails.contactsModel.startDateTime;
                        DateTime endDate =
                            switchDetails.contactsModel.endDateTime;
                        if (now.isAfter(endDate)) {
                          showToast(context,
                              "You have surpassed the end date. Contact the admin for fresh approval");
                          return;
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConnectToSwitchPage(
                            switchDetails: switchDetails,
                          ),
                        ),
                      );
                    },
                    child: SwitchesCard(switchesDetails: switchDetails),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
